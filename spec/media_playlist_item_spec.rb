require 'media_playlist_generator'

describe BBC::MediaPlaylist::Item do
  
  
  describe "that uses a mediation pid" do
    
    let :programme do 
      { kind: 'programme', pid: 'video-on-demand-pid', duration: 'duration_in_seconds', availability_class: 'ondemand' } 
    end
  
    it "has attributes" do
      BBC::MediaPlaylist::Item.new(programme).attributes.should == { kind: 'programme', pid: 'video-on-demand-pid', duration: 'duration_in_seconds', availability_class: 'ondemand', group: 'deprecated', identifier: 'video-on-demand-pid-deprecated'  } 
    end
  
    it "has a pid" do
      BBC::MediaPlaylist::Item.new(programme).pid.should == 'video-on-demand-pid'
    end
  
    it "creates an item when no pid is available" do
      item = BBC::MediaPlaylist::Item.new({ kind: 'programme'})
      item.attributes.should == { kind: 'programme', group: 'deprecated', identifier: 'deprecated' }
      item.pid.should be_nil
    end
    
  end
  
  describe "that uses media connections" do
    
    let :programme do 
      { kind: 'programme', duration: 'duration_in_seconds', availability_class: 'ondemand', media: [ { bitrate: 1500, connections: [ { href: 'http://www.example.org' } ] } ] } 
    end
    
    it "has attributes" do
      BBC::MediaPlaylist::Item.new(programme).attributes.should == { kind: 'programme', duration: 'duration_in_seconds', availability_class: 'ondemand', group: 'deprecated', identifier: 'deprecated', media: [{ bitrate: 1500, connections: [ { href: "http://www.example.org" } ] } ] }  
    end
    
    it "has media" do
      BBC::MediaPlaylist::Item.new(programme).media.should == [ { bitrate: 1500, connections: [ { href: 'http://www.example.org' } ] } ]
    end
    
  end
  
end