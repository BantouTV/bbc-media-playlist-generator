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
      item = objectify item
      begin
        self.reason = item.reason unless item.reason.nil? || item.reason.empty?
        @media_items << item unless item.reason
      rescue NoMethodError
        @media_items << item
      end
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
    
    private
    
    def objectify data
      case data
      when Hash then OpenStruct.new(data)
      when OpenStruct then data
      else
        raise ArgumentError, "Media items should be a hash or a struct"
      end
    end
      
  end

  class NoMediaItems < StandardError; end

end