#!/usr/local/bin/ruby -w

raise "Usage: list.rb path/to/directory/containing/library/spreadsheets" unless ARGV.size == 1

require_relative 'setup'

include Setup

library_path = ARGV[0]
library_path = library_path + '/' unless library_path[-1] == '/'

library = Library.get_latest library_path
@artists = library.nil? ? [] : library.artists

new_artists = Dir["#{SOURCE_PATH}*/*"].sort_by(&:downcase)

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

new_artists.each_with_index do |artist_path|
  albums = Dir["#{artist_path}/*/"].sort_by(&:downcase)
  albums.each do |album_path|
    artist_name = dir_name_from_path artist_path
    album_title = dir_name_from_path album_path
    puts "Processing #{artist_name} / #{album_title}"
    albums_worksheet.add_cell albums_row, 0, artist_name
    albums_worksheet.add_cell albums_row, 1, album_title
    if library && library.artist_known?(artist_name)
      artist = library.find_artist_by_name artist_name
      if artist.has_album_named? album_title
        albums_worksheet.add_cell(albums_row, ALBUM_FAVOURITE_COLUMN_INDEX, MARKER) if artist.is_favourite_album?(album_title)
        albums_worksheet.add_cell(albums_row, ALBUM_DATE_ADDED_COLUMN_INDEX, artist.find_album_by_title(album_title).date_added_string)
      else
        albums_worksheet.add_cell(albums_row, ALBUM_DATE_ADDED_COLUMN_INDEX, Date.today.strftime('%Y%m%d'))
      end
    else
      albums_worksheet.add_cell(albums_row, ALBUM_DATE_ADDED_COLUMN_INDEX, Date.today.strftime('%Y%m%d'))
    end
    tracks = Dir["#{album_path}#{FILE_TYPES}"]
    tracks.each do |track_path|
      track_name = dir_name_from_path track_path
      tracks_worksheet.add_cell songs_row, 0, artist_name
      tracks_worksheet.add_cell songs_row, 1, album_title
      tracks_worksheet.add_cell songs_row, 2, track_name
      if library && library.artist_known?(artist_name)
        artist = library.find_artist_by_name artist_name
        if artist.is_favourite_track?(album_title: album_title, track_name: track_name)
          tracks_worksheet.add_cell(songs_row, TRACK_FAVOURITE_COLUMN_INDEX, MARKER)
        end
        if artist.is_essentials_track?(album_title: album_title, track_name: track_name)
          tracks_worksheet.add_cell(songs_row, TRACK_ESSENTIALS_COLUMN_INDEX, MARKER)
        end
        if artist.has_track?(album_title: album_title, track_name: track_name)
          tracks_worksheet.add_cell(songs_row, TRACK_DATE_ADDED_COLUMN_INDEX, artist.find_track(album_title: album_title, track_name: track_name).date_added_string)
        else
          tracks_worksheet.add_cell(songs_row, TRACK_DATE_ADDED_COLUMN_INDEX, Date.today.strftime('%Y%m%d'))
        end
      else
        tracks_worksheet.add_cell(songs_row, TRACK_DATE_ADDED_COLUMN_INDEX, Date.today.strftime('%Y%m%d'))
      end
      songs_row += 1
    end
    albums_row += 1
  end
end

new_workbook.write "#{library_path}/#{LIST_FILENAME}"
