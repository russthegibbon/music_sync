require 'open3'
require 'rubygems'
require 'fileutils'

require_relative 'album'
require_relative 'artist'
require_relative 'track'
require_relative 'library'

module Setup
  def self.connect_to_server
    Open3.capture3 "mount -r -o nobrowse -t afp 'afp://sync:aYg-6kX-hon-bAQ@diskstation.local/music/Music' #{SOURCE_PATH}"
  end

  def dir_name_from_path(path)
    path.scan(/\/([^\/]+)\/?$/).flatten.first
  end

  LIST_FILE_PREFIX = 'library'
  FILE_TYPES = "*.{mp3,wav,flac,alac,m4a,aac}"
  SOURCE_PATH = 'C:/Users/russe/Music/Library/'
  LIST_FILENAME = "#{LIST_FILE_PREFIX}_#{Time.now.strftime('%Y%m%d_%H%M%S')}.xlsx"
  # TODO: not sure why the following line was needed.
  # Dir.mkdir SOURCE_PATH if Dir[SOURCE_PATH] == []

  ALBUMS_WORKSHEET_NAME = 'albums'
  TRACKS_WORKSHEET_NAME = 'tracks'

  ALBUM_FAVOURITE_HEADER = 'favourite'
  TRACK_FAVOURITE_HEADER = 'favourite'
  ESSENTIALS_HEADER = 'essentials'
  ARTIST_HEADER = 'artist'
  NEW_HEADER = 'new'
  ALBUM_COLUMN_HEADERS = %W{artist album #{ALBUM_FAVOURITE_HEADER} #{NEW_HEADER}}
  TRACK_COLUMN_HEADERS = %W{artist album track #{TRACK_FAVOURITE_HEADER} #{ESSENTIALS_HEADER} #{NEW_HEADER}}

  ALBUM_FAVOURITE_COLUMN_INDEX = ALBUM_COLUMN_HEADERS.find_index ALBUM_FAVOURITE_HEADER
  TRACK_FAVOURITE_COLUMN_INDEX = TRACK_COLUMN_HEADERS.find_index TRACK_FAVOURITE_HEADER
  TRACK_ESSENTIALS_COLUMN_INDEX = TRACK_COLUMN_HEADERS.find_index ESSENTIALS_HEADER
  TRACK_NEW_COLUMN_INDEX = TRACK_COLUMN_HEADERS.find_index NEW_HEADER
  ALBUMS_SHEET_ARTIST_COLUMN_INDEX = TRACK_COLUMN_HEADERS.find_index ARTIST_HEADER
  ALBUM_NEW_COLUMN_INDEX = ALBUM_COLUMN_HEADERS.find_index NEW_HEADER

  MAX_ROWS = 20000
  MARKER = 'X'

  # connect_to_server
end