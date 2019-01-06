class Track
  attr_reader :artist, :album, :filename, :favourite, :essentials

  def initialize(artist:, album:, filename:, favourite:, essentials:)
    @artist = artist
    @album = album
    @filename = filename
    @favourite = favourite
    @essentials = essentials
  end
end
