require 'yaml'
require 'media_playlist'

def programmes
  YAML.load_file(File.join(File.dirname(__FILE__), '..', 'support', 'programmes.yml'))
end

When /^I ask for the playlist for a "(.*?)"$/ do |programme|
  programme = programmes.fetch(programme)
  @playlist = MediaPlaylist.new([programme]).serialize
end

When /^I ask for the playlist for "(.*?)" live simulcast$/ do |programme|
  programme = programmes.fetch(programme).merge(live: 'true', simulcast: 'true')
  @playlist = MediaPlaylist.new([programme]).serialize
end

When /^I ask for the playlist for "(.*?)" live rewind$/ do |programme|
  programme = programmes.fetch(programme).merge(live: 'true', liverewind: 'true')
  @playlist = MediaPlaylist.new([programme]).serialize
end

When /^I ask for the playlist for "(.*?)" live rewind simulcast$/ do |programme|
  programme = programmes.fetch(programme).merge(live: 'true', simulcast: 'true', liverewind: 'true')
  @playlist = MediaPlaylist.new([programme]).serialize
end

When /^I ask for the playlist with a "(.*?)" and "(.*?)"$/ do |programme_one, programme_two|
  programme_one = programmes.fetch(programme_one)
  programme_two = programmes.fetch(programme_two)
  @playlist = MediaPlaylist.new([programme_one, programme_two]).serialize
end

When /^I ask for the playlist for a servcie that hasn't started broadcasting yet$/ do
  @playlist = MediaPlaylist.new([], 'preAvailability').serialize
end

When /^I ask for the playlist for a live programme that has finished broadcasting$/ do
  @playlist = MediaPlaylist.new([], 'postLiveAvailability').serialize
end

When /^I ask for the playlist for a programme that has finished broadcasting$/ do
  @playlist = MediaPlaylist.new([], 'postAvailability').serialize
end

When /^I ask for a playlist for a service that is currently off air$/ do
  @playlist = MediaPlaylist.new([], 'offAir').serialize
end

When /^I ask for a playlist that is empty for no reason$/ do
  @playlist = MediaPlaylist.new([], 'unknown').serialize
end

When /^I ask for a playlist that has no playable items$/ do
  @playlist = MediaPlaylist.new([], 'noPlayableItems').serialize
end

When /^I ask for a playlist whose media unavailable to international users$/ do
  @playlist = MediaPlaylist.new([], 'regionRestriction').serialize
end

When /^I ask for a playlist whose media is missing$/ do
  @playlist = MediaPlaylist.new([{kind: 'programme'}]).serialize
end

When /^I ask for a playlist which has no media$/ do
  @playlist = MediaPlaylist.new([], 'noMedia').serialize
end

When /^the playlist is malformed$/ do
  no_of_lines =  @playlist.lines.count
  line_to_be_deleted = Random.new.rand(1...no_of_lines)
  @playlist = @playlist.to_s.lines.to_a
  @playlist.delete_at(line_to_be_deleted)
  @playlist = @playlist.join('')
end

Then /^I should get the playlist:$/ do |playlist|
  Hash.from_xml(@playlist).should == Hash.from_xml(playlist)
end

Then /^I should not get the playlist:$/ do |playlist|
  begin
    expected_playlist = Hash.from_xml(@playlist)
  rescue REXML::ParseException
    expected_playlist = Hash.new
  end
  expected_playlist.should_not == Hash.from_xml(playlist)
end