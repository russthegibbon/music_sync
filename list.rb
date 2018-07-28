#!/usr/local/bin/ruby -w

# TODO: allow the previous list to be passed in as an argument.

require 'rubygems'
require 'fileutils'
require 'open3'
require 'rubyXL'
require_relative 'album'
require_relative 'artist'
require_relative 'track'

LIST_FILE_PREFIX = 'library'
LIBRARY_DIR = '/Volumes/music/Music/'
LIST_FILENAME = "#{LIST_FILE_PREFIX}_#{Time.now.strftime('%Y%m%d_%H%M%S')}.xlsx"
FILE_TYPES = "*.{mp3,wav,flac,alac,m4a,aac}"
START_DIRECTORY = Dir.pwd
OLD_LIST_FILENAMES = Dir.glob("*.xlsx")
PREVIOUS_LIST_FILENAME = OLD_LIST_FILENAMES.sort.last # remember this will be nil if this is the first run
PREVIOUS_WORKBOOK = RubyXL::Parser.parse PREVIOUS_LIST_FILENAME
ALBUMS_WORKSHEET_NAME = 'albums'
TRACKS_WORKSHEET_NAME = 'tracks'
PREVIOUS_ALBUMS_WORKSHEET = PREVIOUS_WORKBOOK[ALBUMS_WORKSHEET_NAME]
PREVIOUS_TRACKS_WORKSHEET = PREVIOUS_WORKBOOK[TRACKS_WORKSHEET_NAME]
ALBUM_FAVOURITE_HEADER = 'favourite'
TRACK_FAVOURITE_HEADER = 'favourite'
ESSENTIALS_HEADER = 'essentials'
ALBUM_COLUMN_HEADERS = %W{artist album #{ALBUM_FAVOURITE_HEADER}}
TRACK_COLUMN_HEADERS = %W{artist album track #{TRACK_FAVOURITE_HEADER} #{ESSENTIALS_HEADER}}
MAX_ROWS = 20000
MARKER = 'X'

ALBUM_FAVOURITE_COLUMN_INDEX = ALBUM_COLUMN_HEADERS.find_index ALBUM_FAVOURITE_HEADER
TRACK_FAVOURITE_COLUMN_INDEX = TRACK_COLUMN_HEADERS.find_index TRACK_FAVOURITE_HEADER
TRACK_ESSENTIALS_COLUMN_INDEX = TRACK_COLUMN_HEADERS.find_index ESSENTIALS_HEADER

ALBUM_COLUMN_HEADERS.each_with_index do |expected_header, column_index|
  actual_header = PREVIOUS_ALBUMS_WORKSHEET[0][column_index].value
  unless actual_header == expected_header
    raise "Column #{column_index} of albums worksheet should be #{expected_header} but is #{actual_header}."
  end
end

def albums_sheet_artist_column_index
  ALBUM_COLUMN_HEADERS.find_index 'artist'
end

def previous_artists
  @previous_artists ||= get_previous_artists
end

def get_previous_artists
  artist_column_index = albums_sheet_artist_column_index
  artists = {}
  row_index = 1
  until PREVIOUS_ALBUMS_WORKSHEET[row_index].nil? || row_index >= MAX_ROWS do
    name = PREVIOUS_ALBUMS_WORKSHEET[row_index][artist_column_index].value
    artists.store(name, Artist.new(name: name))
    row_index += 1
  end
  artists
end

def get_favourite_albums
  artist_column_index = albums_sheet_artist_column_index
  album_column_index = ALBUM_COLUMN_HEADERS.find_index 'album'
  row_index = 1
  until PREVIOUS_ALBUMS_WORKSHEET[row_index].nil? || row_index >= MAX_ROWS do
    puts row_index.to_s + PREVIOUS_ALBUMS_WORKSHEET[row_index][0].value
    current_row = PREVIOUS_ALBUMS_WORKSHEET[row_index]
    if current_row[ALBUM_FAVOURITE_COLUMN_INDEX] && current_row[ALBUM_FAVOURITE_COLUMN_INDEX].value
      artist_name = current_row[artist_column_index].value
      album = Album.new(artist_name: artist_name,
                        title: current_row[album_column_index].value)
      previous_artists[artist_name].favourite_albums.push album
    end
    row_index += 1
  end
end

TRACK_COLUMN_HEADERS.each_with_index do |expected_header, column_index|
  actual_header = PREVIOUS_TRACKS_WORKSHEET[0][column_index].value
  unless actual_header == expected_header
    raise "Column #{column_index} of tracks worksheet should be #{expected_header} but is #{actual_header}."
  end
end

def get_favourite_and_essentials_tracks
  artist_column_index = TRACK_COLUMN_HEADERS.find_index 'artist'
  album_column_index = TRACK_COLUMN_HEADERS.find_index 'album'
  track_column_index = TRACK_COLUMN_HEADERS.find_index 'track'
  row_index = 1
  until PREVIOUS_TRACKS_WORKSHEET[row_index].nil? || row_index >= MAX_ROWS do
    puts row_index.to_s + PREVIOUS_TRACKS_WORKSHEET[row_index][0].value
    current_row = PREVIOUS_TRACKS_WORKSHEET[row_index]
    artist_name = current_row[artist_column_index].value
    track = Track.new(artist_name: artist_name,
                      album_title: current_row[album_column_index].value,
                      name: current_row[track_column_index].value)
    artist = previous_artists[artist_name]
    if current_row[TRACK_FAVOURITE_COLUMN_INDEX] && current_row[TRACK_FAVOURITE_COLUMN_INDEX].value
      artist.favourite_tracks.push track
    end
    if current_row[TRACK_ESSENTIALS_COLUMN_INDEX] && current_row[TRACK_ESSENTIALS_COLUMN_INDEX].value
      artist.essentials_tracks.push track
    end
    row_index += 1
  end
end

get_favourite_albums
get_favourite_and_essentials_tracks

Dir.chdir LIBRARY_DIR
new_artists = Dir['*/']

new_workbook = RubyXL::Workbook.new
albums_worksheet = new_workbook.add_worksheet ALBUMS_WORKSHEET_NAME
tracks_worksheet = new_workbook.add_worksheet TRACKS_WORKSHEET_NAME

ALBUM_COLUMN_HEADERS.each_with_index do |header, column|
  albums_worksheet.add_cell 0, column, header
end

TRACK_COLUMN_HEADERS.each_with_index do |header, column|
  tracks_worksheet.add_cell 0, column, header
end

songs_row = albums_row = 1

new_artists[0..10].each_with_index do |artist|
  Dir.chdir(LIBRARY_DIR + artist)
  albums = Dir['*/']
  albums.each do |album|
    artist_name = artist.chomp('/')
    album_title = album.chomp('/')
    albums_worksheet.add_cell albums_row, 0, artist_name
    albums_worksheet.add_cell albums_row, 1, album_title
    if previous_artists[artist_name] && previous_artists[artist_name].favourite_albums.map(&:title).include?(album_title)
      albums_worksheet.add_cell(albums_row, ALBUM_FAVOURITE_COLUMN_INDEX, MARKER)
    end

    Dir.chdir(LIBRARY_DIR + artist + album)
    tracks = Dir.glob FILE_TYPES
    tracks.each do |track|
      track_name = track.chomp('/')
      tracks_worksheet.add_cell songs_row, 0, artist_name
      tracks_worksheet.add_cell songs_row, 1, album_title
      tracks_worksheet.add_cell songs_row, 2, track_name
      if previous_artists[artist_name] && previous_artists[artist_name].favourite_tracks.map(&:name).include?(track_name)
        tracks_worksheet.add_cell(songs_row, TRACK_FAVOURITE_COLUMN_INDEX, MARKER)
      end
      if previous_artists[artist_name] && previous_artists[artist_name].essentials_tracks.map(&:name).include?(track_name)
        tracks_worksheet.add_cell(songs_row, TRACK_ESSENTIALS_COLUMN_INDEX, MARKER)
      end
      songs_row += 1
    end
    albums_row += 1
  end
end

new_workbook.write "#{START_DIRECTORY}/#{LIST_FILENAME}"
