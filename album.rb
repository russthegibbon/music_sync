class Album
  attr_reader :artist, :title, :favourite, :tracks

  def initialize(artist:, title:, favourite:)
    @artist = artist
    @title = title
    @favourite = favourite
    @tracks = []
  end

  def add_track(filename:, favourite:, essentials:)
    @tracks.push(Track.new(artist: @artist, album: self, filename: filename, favourite: favourite, essentials: essentials))
  end

  def is_favourite_track?(track_name)
    track = @tracks.find { |track| track.filename == track_name }
    track.favourite
  end

  def is_essentials_track?(track_name)
    track = @tracks.find { |track| track.filename == track_name }
    track.essentials
  end
end
