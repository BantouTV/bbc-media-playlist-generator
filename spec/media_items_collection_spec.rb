require_relative '../lib/media_playlist_generator'

describe BBC::MediaPlaylist::MediaItemsCollection do
  
  programme = OpenStruct.new({ kind: 'programme', pid: 'video_on_demand_pid', duration: 'duration_in_seconds', availability_class: 'ondemand' })
  
  it "stores media items" do
    media_items_collection = BBC::MediaPlaylist::MediaItemsCollection.new
    media_items_collection << programme
    media_items_collection.media_items.should == [programme]
  end

end