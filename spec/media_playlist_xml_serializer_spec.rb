require 'active_support/core_ext'
require 'media_playlist_generator'

describe BBC::MediaPlaylist::XMLSerializer do
  
  describe "serializing a playlist with media items" do
      
    programme_one = {  kind: 'ident', pid: 'ident_pid' }  
    programme_two = OpenStruct.new({ kind: 'programme', pid: 'video_on_demand_pid', duration: 'duration_in_seconds', availability_class: 'ondemand' })
  
    
    xml_representation = Nokogiri::XML(%|<?xml version="1.0" encoding="UTF-8"?>
    <playlist xmlns="http://bbc.co.uk/2008/emp/playlist" revision="1">
      <item kind="ident">
        <mediator identifier="ident_pid"/>
      </item>
      <item kind="programme" duration="duration_in_seconds" availability_class="ondemand">
        <mediator identifier="video_on_demand_pid"/>
      </item>
    </playlist>|).to_xml
  
    it 'serializes a playlist as a xml' do
      
      media_playlist = BBC::MediaPlaylist.new do |playlist|
        playlist << programme_one
        playlist << programme_two
      end
      serialized_playlist = BBC::MediaPlaylist::XMLSerializer.new.serialize(media_playlist)
      Hash.from_xml(serialized_playlist).should == Hash.from_xml(xml_representation)
      
    end
    
  end
 
  describe "serializing a playlist with no media items" do
    
    it "creates a noItems node with an reason attribute" do
   
      xml_representation = Nokogiri::XML(%|<?xml version="1.0" encoding="UTF-8"?>
      <playlist xmlns="http://bbc.co.uk/2008/emp/playlist" revision="1">
        <noItems reason="reason there are no media items" />
      </playlist>>|).to_xml
      
      media_playlist = BBC::MediaPlaylist.new do |playlist|
        playlist << OpenStruct.new(reason: 'reason there are no media items')
      end
    
      serialized_playlist = BBC::MediaPlaylist::XMLSerializer.new.serialize(media_playlist)
      Hash.from_xml(serialized_playlist).should == Hash.from_xml(xml_representation)
    end
    
    it "creates a noItems node with an reason attribute whose default value is 'noreason'" do
   
      xml_representation = Nokogiri::XML(%|<?xml version="1.0" encoding="UTF-8"?>
      <playlist xmlns="http://bbc.co.uk/2008/emp/playlist" revision="1">
        <noItems reason="unknown" />
      </playlist>>|).to_xml
      
      media_playlist = BBC::MediaPlaylist.new do |playlist|
        playlist << OpenStruct.new(reason: '')
      end
    
      serialized_playlist = BBC::MediaPlaylist::XMLSerializer.new.serialize(media_playlist)
      
      Hash.from_xml(serialized_playlist).should == Hash.from_xml(xml_representation)
    end
    
  end
  
end

