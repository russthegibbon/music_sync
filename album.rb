class Album
  attr_reader :artist, :title, :favourite, :tracks, :date_added

  def initialize(artist:, title:, favourite:, date_added: Date.today)
    @artist = artist
    @title = title
    @favourite = favourite
    @tracks = []
    # TODO: move date processing to a module for easier sharing with Track.
    @date_added = if date_added.is_a?(Date) || date_added == ''
                    date_added
                  else
                    Date.strptime(date_added.to_s, '%Y%m%d')
                  end
  end

  def add_track(filename:, favourite:, essentials:, date_added:)
    @tracks.push(Track.new(artist: @artist, album: self, filename: filename, favourite: favourite, essentials: essentials, date_added: date_added))
  end

  def is_favourite_track?(track_name)
    track = @tracks.find { |track| track.filename == track_name }
    track.favourite
  end

  def is_essentials_track?(track_name)
    track = @tracks.find { |track| track.filename == track_name }
    track.essentials
  end

  def has_track_named?(track_name)
    @tracks.any? {|track| track.filename == track_name}
  end

  def find_track_by_name(track_name)
    tracks.find { |track| track.filename == track_name}
  end

  def date_added_string
    if @date_added == ''
      ''
    else
      @date_added.strftime '%Y%m%d'
    end
  end
end
