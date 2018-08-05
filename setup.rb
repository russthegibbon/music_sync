require 'open3'
require 'rubygems'
require 'fileutils'

require_relative 'album'
require_relative 'artist'
require_relative 'track'
require_relative 'library'

module Setup
  WORKING_DIR = Dir.pwd
  LIST_FILE_PREFIX = 'library'
  FILE_TYPES = "*.{mp3,wav,flac,alac,m4a,aac}"
  LIBRARY_PATH = '/tmp/sync/'
  LIST_FILENAME = "#{LIST_FILE_PREFIX}_#{Time.now.strftime('%Y%m%d_%H%M%S')}.xlsx"
  Dir.mkdir LIBRARY_PATH if Dir[LIBRARY_PATH] == []
  Open3.capture3 "mount -r -o nobrowse -t afp 'afp://sync:aYg-6kX-hon-bAQ@diskstation.local/music/Music' #{LIBRARY_PATH}"

  ALBUMS_WORKSHEET_NAME = 'albums'
  TRACKS_WORKSHEET_NAME = 'tracks'

  ALBUM_FAVOURITE_HEADER = 'favourite'
  TRACK_FAVOURITE_HEADER = 'favourite'
  ESSENTIALS_HEADER = 'essentials'
  ARTIST_HEADER = 'artist'
  ALBUM_COLUMN_HEADERS = %W{artist album #{ALBUM_FAVOURITE_HEADER}}
  TRACK_COLUMN_HEADERS = %W{artist album track #{TRACK_FAVOURITE_HEADER} #{ESSENTIALS_HEADER}}

  ALBUM_FAVOURITE_COLUMN_INDEX = ALBUM_COLUMN_HEADERS.find_index ALBUM_FAVOURITE_HEADER
  TRACK_FAVOURITE_COLUMN_INDEX = TRACK_COLUMN_HEADERS.find_index TRACK_FAVOURITE_HEADER
  TRACK_ESSENTIALS_COLUMN_INDEX = TRACK_COLUMN_HEADERS.find_index ESSENTIALS_HEADER
  ALBUMS_SHEET_ARTIST_COLUMN_INDEX = ALBUM_COLUMN_HEADERS.find_index ARTIST_HEADER

  MAX_ROWS = 20000
  MARKER = 'X'

  def dir_name_from_path(path)
    path.scan(/\/([^\/]+)\/?$/).flatten.first
  end

end