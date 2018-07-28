class Artist
  def initialize(name:)
    @name = name
    @favourite_albums = []
    @favourite_tracks = []
    @essentials_tracks = []
  end

  attr_reader :name
  attr_accessor :favourite_albums, :favourite_tracks, :essentials_tracks
end