class Track
  attr_reader :artist, :album, :filename, :favourite, :essentials, :date_added

  def initialize(artist:, album:, filename:, favourite:, essentials:, date_added: Date.today)
    @artist = artist
    @album = album
    @filename = filename
    @favourite = favourite
    @essentials = essentials
    @date_added = if date_added.is_a?(Date) || date_added == ''
                    date_added
                  else
                    Date.strptime(date_added.to_s, '%Y%m%d')
                  end
  end

  def date_added_string
    if @date_added == ''
      ''
    else
      @date_added.strftime '%Y%m%d'
    end
  end
end
