require 'media_playlist'
require 'nokogiri'
require 'active_support/core_ext'

describe MediaPlaylist do
    
  programme_one = { kind: 'ident', pid: 'ident_pid' }
  programme_two = { kind: 'programme', pid: 'video_on_demand_pid', duration: 'duration_in_seconds', availability_class: 'ondemand' }
    
  let(:playlist) do
     MediaPlaylist.new([programme_one, programme_two])
  end 
  
  it "holds a list of media items" do
    playlist.items.should == [{ kind: 'ident', pid: 'ident_pid' },{ kind: 'programme', pid: 'video_on_demand_pid', duration: 'duration_in_seconds', availability_class: 'ondemand' }]
  end
  
  it "can be serialized via a serializer" do
    serializer = double('serializer')
    serializer.should_receive(:serialize).with(playlist)
    playlist.serialize(serializer)
  end
  
end