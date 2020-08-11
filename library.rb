require 'rubyXL'

class Library
  attr_accessor :artists

  def initialize(filename)
    puts "Reading library: #{filename}"
    @filename = filename
    @workbook = RubyXL::Parser.parse filename
    @albums_worksheet = @workbook[ALBUMS_WORKSHEET_NAME]
    @tracks_worksheet = @workbook[TRACKS_WORKSHEET_NAME]

    check_column_headers
    process_albums_sheet
    process_tracks_sheet
  end

  def self.get_latest(path)
    Dir.chdir path
    old_list_filenames = Dir["[^~]*.xlsx"]
    # TODO: the next line implies that a template has to be manually created when starting from nothing.  Add a command
    # line option to create it automatically.
    raise "No library files found at #{path}" if old_list_filenames == []
    previous_library_filename = old_list_filenames.sort.last
    Library.new previous_library_filename
  end

  def artist_known?(name)
    !!(@artists.find { |artist| artist.name == name })
  end

  def find_artist_by_name(name)
    matching_artists = @artists.find_all { |artist| artist.name == name }
    case matching_artists.count
      when matching_artists.count == 0
        raise "#{name} does not exist."
      when matching_artists.count > 1
        raise "Multiple instances of #{name} defined."
    end
    matching_artists.first
  end

  def favourite_tracks
    favourites = []
    artists.each do |artist|
      artist.albums.each do |album|
        album.tracks.each do |track|
          favourites.push(track) if track.favourite
        end
      end
    end
    favourites
  end

  def hotlist_tracks
    hotlist = []
    artists.each do |artist|
      artist.albums.each do |album|
        album.tracks.each do |track|
          hotlist.push(track) if track.hotlist
        end
      end
    end
    hotlist
  end

  private

  def check_column_headers
    ALBUM_COLUMN_HEADERS.each_with_index do |expected_header, column_index|
      actual_header = @albums_worksheet[0][column_index].value
      unless actual_header == expected_header
        raise "Column #{column_index} of albums worksheet should be #{expected_header} but is #{actual_header}."
      end
    end

    TRACK_COLUMN_HEADERS.each_with_index do |expected_header, column_index|
      actual_header = @tracks_worksheet[0][column_index].value
      unless actual_header == expected_header
        raise "Column #{column_index} of tracks worksheet should be #{expected_header} but is #{actual_header}."
      end
    end
  end

  START_ROW = 1

  def process_albums_sheet
    artist_column_index = ALBUMS_SHEET_ARTIST_COLUMN_INDEX
    album_column_index = ALBUM_COLUMN_HEADERS.find_index 'album'
    @artists = []
    row_index = START_ROW
    row = @albums_worksheet[row_index]
    while row_index <= MAX_ROWS && row && row.cells != []
      artist_name = row[artist_column_index].value
      raise "Duplicate artist in albums spreadsheet: #{artist_name}" if artist_known?(artist_name)
      artist = Artist.new(name: artist_name)
      begin
        title = row[album_column_index].value
        favourite = !!(row[ALBUM_FAVOURITE_COLUMN_INDEX] && row[ALBUM_FAVOURITE_COLUMN_INDEX].value)
        album = Album.new(artist: artist, title: title, favourite: favourite)
        artist.add_album album
        old_row = row.clone
        row_index += 1
        row = @albums_worksheet[row_index]
      end while row_index <= MAX_ROWS && row && row.cells != [] && row[artist_column_index].value == old_row[artist_column_index].value
      @artists.push(artist)
    end
  end

  def process_tracks_sheet
    artist_name_column_index = TRACK_COLUMN_HEADERS.find_index 'artist'
    album_title_column_index = TRACK_COLUMN_HEADERS.find_index 'album'
    track_name_column_index = TRACK_COLUMN_HEADERS.find_index 'track'
    row_index = START_ROW
    row = @tracks_worksheet[row_index]
    while row_index < MAX_ROWS && row
      artist_name = row[artist_name_column_index].value
      artist = find_artist_by_name artist_name
      begin
        album_title = row[album_title_column_index].value
        track_name = row[track_name_column_index].value
        favourite = !!(row[TRACK_FAVOURITE_COLUMN_INDEX] && row[TRACK_FAVOURITE_COLUMN_INDEX].value)
        essentials = !!(row[TRACK_ESSENTIALS_COLUMN_INDEX] && row[TRACK_ESSENTIALS_COLUMN_INDEX].value)
        hotlist = !!(row[TRACK_HOTLIST_COLUMN_INDEX] && row[TRACK_HOTLIST_COLUMN_INDEX].value)
        artist.add_track(album_title: album_title, track_name: track_name, favourite: favourite, essentials: essentials, hotlist: hotlist)
        row_index += 1
        old_row = row.clone
        row = @tracks_worksheet[row_index]
      end while row_index < MAX_ROWS && row && row[artist_name_column_index].value == old_row[artist_name_column_index].value
    end
  end
end
