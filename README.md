# Media Playout: Media Playlists

A ruby library for creating XML media playlists for use in testing products based on the BBC Media Player.

## Creation

The MediaPlayer constructor takes a block with which can you add media items to the collection:

    require 'media_playlist'
    
    media_playlist = BBC::MediaPlayer.new do |playlist|
      playlist << playlist_item_one 
      playlist << playlist_item_two
    end

### Playlist Items    

The `playlist_item` is a collection of data attributes that correspond to either a programme identifier to be used with MediaSelector or a media connection that itself can hold a collection of CDN end points.
Currently the playlist item needs to be in the form of a Hash or a Struct.

#### Mediation Items

Playlist items intended to represent mediation points should respond to `#pid`. This example uses Ruby's OpenStruct:
    
    require 'ostruct'
    
    playlist_item = OpenStruct.new(type: 'programme', pid: 'a-pid')
    
#### Media Items

Playlist items intended to represent media connections should respond to the `#connections` method which returns a collection of 'connections' that each respond to `#href`:

    require 'ostruct'
    
    playlist_item = OpenStruct.new(type: 'programme', 
                                   connections: [OpenStruct.new({ href: 'http://www.example.com/path/to/media/file' })])
    
## Serialization


To serialize the media playlist into an xml format use the playlist xml serializer:

    media_playlist.to_xml