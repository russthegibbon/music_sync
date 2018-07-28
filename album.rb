class Album
  def initialize(artist_name:, title:)
    @artist_name = artist_name
    @title = title
  end

  attr_reader :artist_name, :title
end