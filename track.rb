class Track
  attr_reader :artist, :album, :filename, :favourite, :essentials, :hotlist

  def initialize(artist:, album:, filename:, favourite:, essentials:, hotlist:)
    @artist = artist
    @album = album
    @filename = filename
    @favourite = favourite
    @essentials = essentials
    @hotlist = hotlist
  end
end
