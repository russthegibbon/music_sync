class Album
  attr_reader :artist, :title, :favourite, :continuity, :tracks

  def initialize(artist:, title:, favourite:, continuity:)
    @artist = artist
    @title = title
    @favourite = favourite
    @continuity = continuity
    @tracks = []
  end

  def add_track(filename:, favourite:, essentials:, hotlist:)
    @tracks.push(Track.new(artist: @artist, album: self, filename: filename, favourite: favourite, essentials: essentials, hotlist: hotlist))
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
end
