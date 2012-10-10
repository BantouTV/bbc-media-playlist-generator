require 'nokogiri'
  
class MediaPlaylistXMLSerializer
  
  attr_reader :xml_builder, :items
  
  def initialize(xml_builder = Nokogiri::XML::Builder)
    @xml_builder = xml_builder
  end
  
  def serialize(playlist)
    build = xml_builder.new(:encoding => 'UTF-8') do |xml|
      xml.playlist('xmlns' => 'http://bbc.co.uk/2008/emp/playlist', 'revision' => '1') do
        begin 
          build_item_elements xml, playlist.items
        rescue NoMediaItems => e
          xml.noItems(reason: e.message)
        end
      end
    end
    build.to_xml
  end
  
  private 
  
  def build_item_elements xml, item_elements
    item_elements.each do |item_properties|
      
      def item_properties.remove(key)
        hash = self.clone
        self.delete key
        hash.delete_if { | k, v | k != key }
      end
      
      def item_properties.rename_key(old, new)
        self[new] = self.delete(old) if self[old]
      end
      
      mediator_attributes = item_properties.remove(:pid)
      mediator_attributes.rename_key(:pid, :identifier) 
      media_elements = item_properties.delete(:media)
      xml.item(item_properties) do 
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