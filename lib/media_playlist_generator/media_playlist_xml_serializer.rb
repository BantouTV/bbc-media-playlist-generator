module BBC
  
  class MediaPlaylist
    
    class XMLSerializer
  
      attr_reader :xml_builder
  
      def initialize(xml_builder = Nokogiri::XML::Builder)
        @xml_builder = xml_builder
      end
  
      def serialize(playlist)
        build = xml_builder.new(:encoding => 'UTF-8') do |xml|
          xml.playlist('xmlns' => 'http://bbc.co.uk/2008/emp/playlist', 'revision' => '1') do
            begin 
              build_item_elements xml, playlist.items
            rescue NoItemsError => e
              xml.noItems(reason: e.message)
            end
          end
        end
        build.to_xml
      end
  
      private 
  
      def build_item_elements xml, media_items
        media_items.each do |media_item|
          xml.item(media_item.attributes) do 
            if !media_item.media.empty? 
              build_media_elements xml, media_item.media
            else
              build_mediator_element(xml, media_item.pid)
            end
          end
        end
      end
  
      def build_mediator_element xml, pid
        xml.mediator({identifier: pid, name: 'pips'}) unless pid.nil?
      end
  
      def build_media_elements xml, media_elements
        media_elements.each do |media_element|
          connections = media_element.fetch :connections
          media_attributes = media_element.reject { |key, value| key == :connections }
          xml.media(media_attributes) do
            connections.each do |connection|
              xml.connection(connection)
            end
          end
        end
      end
  
      end
    
    end

end