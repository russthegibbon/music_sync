class Track
  attr_reader :filename, :favourite, :essentials

  def initialize(filename:, favourite:, essentials:)
    @filename = filename
    @favourite = favourite
    @essentials = essentials
  end

end