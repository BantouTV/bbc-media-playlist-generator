describe BBC::MediaPlaylist do
    
  programme_one = OpenStruct.new({ kind: 'ident', pid: 'ident_pid' })
  programme_two = OpenStruct.new({ kind: 'programme', pid: 'video_on_demand_pid', duration: 'duration_in_seconds', availability_class: 'ondemand' })
  
  it "holds a list of items" do
    playlist = BBC::MediaPlaylist.new do |playlist|
      playlist << programme_one
      playlist << programme_two
    end
    playlist.media_items.should == [programme_one, programme_two]
  end
  
  it "holds a reason when they are no items" do
    no_items = OpenStruct.new({ reason: 'Off air' })
    playlist = BBC::MediaPlaylist.new do |playlist|
      playlist << no_items
    end 
    playlist.reason.should == no_items.reason
  end
  
  it "can be serialized via a serializer" do
    playlist = BBC::MediaPlaylist.new do |playlist|
      playlist << programme_one
    end
    serializer = double('serializer')
    serializer.should_receive(:serialize).with(playlist)
    playlist.serialize(serializer)
  end
  
end