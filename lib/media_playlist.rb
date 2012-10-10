require 'media_playlist_xml_serializer'

class MediaPlaylist
  
  attr_reader :reason, :items
  
  def initialize(items = [], reason = 'unknown')
    @items = items
    @reason = reason
  end

  def serialize(serializer = MediaPlaylistXMLSerializer.new)
    serializer.serialize(self)
  end
  
  def items
    raise NoMediaItems, @reason if (@items.nil? || @items.empty?)
    @items
  end
  
end

class NoMediaItems < StandardError
end