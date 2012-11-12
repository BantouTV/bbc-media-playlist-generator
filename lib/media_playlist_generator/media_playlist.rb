module BBC
  
  class MediaPlaylist
    
    attr_writer :items
  
    def initialize
      @items = []
      @no_items = NoItems.new
      yield self if block_given?
    end
  
    def <<(item_attributes)
      item = ItemFactory.build(item_attributes)
      case item
      when Item
        @items << item
      when NoItems
        @no_items = item
      end
    end 
    
    def ==(other)
      self.items == other.items
    end
  
    def items
      raise NoItemsError, reason if @items.empty?
      @items
    end
    
    def reason
      @no_items.reason
    end
    
    def serialize(serializer)
      serializer.serialize(self)
    end
    
    def to_xml
      serialize(XMLSerializer.new)
    end
    
    module ItemFactory
  
      def self.build attributes
        reason = attributes.fetch(:reason) { nil }
        reason ? NoItems.new(reason) : Item.new(attributes)
      end
    
    end
  
    class Item
      
      def initialize hash
        @hash = hash
      end 
    
      def ==(other)
        @hash.to_hash == other.to_hash
      end
    
      def attributes
        deprecated_item_identifier = [@hash.fetch(:pid) { nil }, 'deprecated'].compact.join('-')
        deprecated_programme_attributes = { group: 'deprecated', identifier: deprecated_item_identifier }
        attributes = @hash.reject { |key, value| (key == :pid || key == :media) }
        attributes.merge!(deprecated_programme_attributes) if attributes.any? { |key,value| key == :kind && value == 'programme' }
        attributes
      end   
      
      def pid
        @hash.fetch(:pid) { nil }
      end
      
      def media
        @hash.fetch(:media) { [] }
      end
      
      def mediator_attributes
        attributes, deprecated_mediator_attributes = {}, { name: 'deprecated' }
        attributes.merge!({ identifier: pid }).merge!(deprecated_mediator_attributes) unless pid.nil?
        attributes
      end

    
    end

    class NoItems
    
      attr_reader :reason
    
      def initialize(reason = '')
        @reason = reason.empty? ? 'unknown' : reason
      end
    
    end
  
    class NoItemsError < StandardError; end
      
  end
  
end