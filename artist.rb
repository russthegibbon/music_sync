class Artist
  attr_reader :name, :albums

  def initialize(name:)
    @name = name
    @albums = []
  end

  def add_album(album)
    @albums.push(album)
  end

  def add_track(album_title:, track_name:, favourite:, essentials:, date_added:)
    album = find_album_by_title album_title
    album.add_track(filename: track_name, favourite: favourite, essentials: essentials, date_added: date_added)
  end

  def is_favourite_album?(album_title)
    find_album_by_title(album_title).favourite
  end

  def is_favourite_track?(album_title:, track_name:)
    if has_album_named? album_title
      album = find_album_by_title(album_title)
      track = album.tracks.find { |track| track.filename == track_name }
      track && track.favourite
    else
      false
    end
  end

  def is_essentials_track?(album_title:, track_name:)
    if has_album_named? album_title
      album = find_album_by_title(album_title)
      track = album.tracks.find { |track| track.filename == track_name }
      track && track.essentials
    else
      false
    end
  end

  def initial_dir
    "#{name[0].upcase}/"
  end

  def has_album_named?(title)
    # TODO: use `any`
    !!albums.find { |album| album.title == title }
  end

  def essentials_tracks
    essentials = []
    @albums.each do |album|
      album.tracks.map do |track|
        if track.essentials
          essentials.push "#{album.title}/#{track.filename}"
        end
      end
    end
    essentials
  end

  def has_essentials_tracks?
    essentials_tracks != []
  end

  def has_track?(album_title:, track_name:)
    return false unless has_album_named? album_title

    find_album_by_title(album_title).has_track_named? track_name
  end

  def find_album_by_title(title)
    matching_albums = @albums.find_all { |album| album.title == title }
    case
      when matching_albums.nil?
        raise "#{title} does not exist."
      when matching_albums.count == 0
        raise "#{title} does not exist."
      when matching_albums.count > 1
        raise "Multiple instances of #{title} defined."
    end
    matching_albums.first
  end

  def find_track(album_title:, track_name:)
    find_album_by_title(album_title).find_track_by_name(track_name)
  end
end
