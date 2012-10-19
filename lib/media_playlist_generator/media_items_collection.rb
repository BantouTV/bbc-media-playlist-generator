module BBC

  class MediaPlaylist
    
    class MediaItemsCollection
    
      extend Forwardable 
      def_delegators :@media_items, :<<, :size, :empty?, :each
      include Enumerable
  
      attr_reader :media_items
  
      def initialize
        @media_items = []
      end
  
      def ==(other)
        media_items == other
      end
  
    end
  
  end

end