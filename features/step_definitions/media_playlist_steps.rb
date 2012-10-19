require 'yaml'
require 'ostruct'
require 'media_playlist'

def programmes
  YAML.load_file(File.join(File.dirname(__FILE__), '..', 'support', 'programmes.yml'))
end

When /^I ask for the playlist for a "(.*?)"$/ do |programme|
  programme = OpenStruct.new(programmes.fetch(programme))
  @playlist = BBC::MediaPlaylist.new { |playlist| playlist << programme }.to_xml
end

When /^I ask for the playlist for "(.*?)" live simulcast$/ do |programme|
  programme = OpenStruct.new(programmes.fetch(programme).merge(live: 'true', simulcast: 'true'))
  @playlist = BBC::MediaPlaylist.new { |playlist| playlist << programme }.to_xml
end

When /^I ask for the playlist for "(.*?)" live rewind$/ do |programme|
  programme = OpenStruct.new(programmes.fetch(programme).merge(live: 'true', liverewind: 'true'))
  @playlist = BBC::MediaPlaylist.new { |playlist| playlist << programme }.to_xml
end

When /^I ask for the playlist for "(.*?)" live rewind simulcast$/ do |programme|
  programme = OpenStruct.new(programmes.fetch(programme).merge(live: 'true', simulcast: 'true', liverewind: 'true'))
  @playlist = BBC::MediaPlaylist.new { |playlist| playlist << programme }.to_xml
end

When /^I ask for the playlist with a "(.*?)" and "(.*?)"$/ do |programme_one, programme_two|
  programme_one = OpenStruct.new(programmes.fetch(programme_one))
  programme_two = OpenStruct.new(programmes.fetch(programme_two))
  @playlist = BBC::MediaPlaylist.new do |playlist|
    playlist << programme_one
    playlist << programme_two
  end.to_xml
end

When /^I ask for the playlist for a servcie that hasn't started broadcasting yet$/ do
  @playlist = BBC::MediaPlaylist.new { |playlist| playlist << OpenStruct.new(reason: 'preAvailability') }.to_xml
end

When /^I ask for the playlist for a live programme that has finished broadcasting$/ do
  @playlist = BBC::MediaPlaylist.new { |playlist| playlist << OpenStruct.new(reason: 'postLiveAvailability') }.to_xml
end

When /^I ask for the playlist for a programme that has finished broadcasting$/ do
  @playlist = BBC::MediaPlaylist.new { |playlist| playlist << OpenStruct.new(reason: 'postAvailability') }.to_xml
end

When /^I ask for a playlist for a service that is currently off air$/ do
  @playlist = BBC::MediaPlaylist.new { |playlist| playlist << OpenStruct.new(reason: 'offAir') }.to_xml
end

When /^I ask for a playlist that is empty for no reason$/ do
  @playlist = BBC::MediaPlaylist.new { |playlist| playlist << OpenStruct.new(reason: 'unknown') }.to_xml
end

When /^I ask for a playlist that has no playable items$/ do
  @playlist = BBC::MediaPlaylist.new { |playlist| playlist << OpenStruct.new(reason: 'noPlayableItems') }.to_xml
end

When /^I ask for a playlist whose media unavailable to international users$/ do
  @playlist = BBC::MediaPlaylist.new { |playlist| playlist << OpenStruct.new(reason: 'regionRestriction') }.to_xml
end

When /^I ask for a playlist whose media is missing$/ do
  @playlist = BBC::MediaPlaylist.new { |playlist| playlist << OpenStruct.new(kind: 'programme') }.to_xml
end

When /^I ask for a playlist which has no media$/ do
  @playlist = BBC::MediaPlaylist.new { |playlist| playlist << OpenStruct.new(reason: 'noMedia') }.to_xml
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