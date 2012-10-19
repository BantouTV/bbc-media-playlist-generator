module BBC
  
  class MediaPlaylist
    
    class XMLSerializer
  
      attr_reader :xml_builder, :media_items
  
      def initialize(xml_builder = Nokogiri::XML::Builder)
        @xml_builder = xml_builder
      end
  
      def serialize(playlist)
        build = xml_builder.new(:encoding => 'UTF-8') do |xml|
          xml.playlist('xmlns' => 'http://bbc.co.uk/2008/emp/playlist', 'revision' => '1') do
            begin 
              build_item_elements xml, playlist.media_items
            rescue NoMediaItems => e
              xml.noItems(reason: e.message)
            end
          end
        end
        build.to_xml
      end
  
      private 
  
      def build_item_elements xml, media_items
        media_items.each do |media_item|
          media_item = media_item.marshal_dump
      
          def media_item.remove(key)
            hash = self.clone
            self.delete key
            hash.delete_if { | k, v | k != key }
          end
      
          def media_item.rename_key(old, new)
            self[new] = self.delete(old) if self[old]
          end
      
          mediator_attributes = media_item.remove(:pid)
          mediator_attributes.rename_key(:pid, :identifier) 
          media_elements = media_item.delete(:media)
          xml.item(media_item) do 
            if media_elements
              build_media_elements xml, media_elements
            else
              build_mediator_element(xml, mediator_attributes)
            end
          end
        end
      end
  
      def build_mediator_element xml, mediator_attributes
        xml.mediator mediator_attributes unless mediator_attributes.empty?
      end
  
      def build_media_elements xml, media_elements
        media_elements ||= []
        media_elements.each do |media_properties|
          connections = media_properties.delete :connections
          xml.media(media_properties) do
            connections.each do |connection_properties|
              xml.connection(connection_properties)
            end
          end
        end
      end
  
      end
    
    end

end