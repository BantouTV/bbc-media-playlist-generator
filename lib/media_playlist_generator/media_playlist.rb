module BBC
  
  class MediaPlaylist
  
    attr_accessor :reason
    attr_writer :media_items
  
    def initialize(media_items_collection = MediaItemsCollection.new)
      @reason = 'unknown'
      @media_items = media_items_collection
      yield self if block_given?
    end
  
    def <<(item)
      self.reason = item.reason unless item.reason.nil? || item.reason.empty?
      @media_items << item unless item.reason
    end 
  
    def media_items
      raise NoMediaItems, reason if @media_items.empty?
      @media_items
    end

    def serialize(serializer)
      serializer.serialize(self)
    end
    
    def to_xml
      serialize(XMLSerializer.new)
    end
    
  end

  class NoMediaItems < StandardError; end

end