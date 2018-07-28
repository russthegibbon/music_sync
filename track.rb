class Track
  def initialize(artist_name:, album_title:, name:)
    @artist_name = artist_name
    @album_title = album_title
    @name = name
  end

  attr_reader :artist_name, :album_title, :name
end