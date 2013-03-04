require 'ostruct'
require 'media_playlist_generator'

describe BBC::MediaPlaylist do
    
  let :programme do 
    { kind: 'programme', pid: 'video_on_demand_pid', duration: 'duration_in_seconds', availability_class: 'ondemand' } 
  end
  
  context "the programme data is supplied as a hash" do
    it "holds a list of items" do
      playlist = BBC::MediaPlaylist.new do |playlist|
        playlist << programme
      end
      playlist.items.should == [programme]
    end
  
    it "holds a list of items" do
      playlist = BBC::MediaPlaylist.new do |playlist|
        playlist << programme
      end
      playlist.items.should == [programme]
    end
  
    it "holds a reason when they are no items" do
      no_items = { reason: 'Off air' }
      playlist = BBC::MediaPlaylist.new do |playlist|
        playlist << no_items
      end 
      playlist.reason.should == no_items.fetch(:reason)
    end
  
    it "can be serialized via a serializer" do
      playlist = BBC::MediaPlaylist.new do |playlist|
        playlist << programme
      end
      serializer = double('serializer')
      serializer.should_receive(:serialize).with(playlist)
      playlist.serialize(serializer)
    end
  end
  
  context "the programme data is supplied as an OpenStruct" do
    it "holds a list of items" do
      playlist = BBC::MediaPlaylist.new do |playlist|
        playlist << OpenStruct.new(programme)
      end
      playlist.items.should == [programme]
    end
  end
  
end