require 'yaml'
require 'media_playlist_generator'

def programmes
  @programmes ||= YAML.load_file(File.join(File.dirname(__FILE__), '..', 'support', 'programmes.yml'))
end

When /^I ask for the playlist for a "(.*?)"$/ do |programme|
  programme = programmes.fetch(programme)
  @playlist = BBC::MediaPlaylist.new { |playlist| playlist << programme }.to_xml
end

When /^I ask for the playlist for "(.*?)" live simulcast$/ do |programme|
  programme = programmes.fetch(programme).merge({ live: true, simulcast: true })
  @playlist = BBC::MediaPlaylist.new { |playlist| playlist << programme }.to_xml
end

When /^I ask for the playlist for "(.*?)" live rewind$/ do |programme|
  programme = programmes.fetch(programme).merge({ live: true, liverewind: true })
  @playlist = BBC::MediaPlaylist.new { |playlist| playlist << programme }.to_xml
end

When /^I ask for the playlist for "(.*?)" live rewind simulcast$/ do |programme|
  programme = programmes.fetch(programme).merge({ live: 'true', simulcast: 'true', liverewind: 'true' })
  @playlist = BBC::MediaPlaylist.new { |playlist| playlist << programme }.to_xml
end

When /^I ask for the playlist with a "(.*?)" and "(.*?)"$/ do |programme_one, programme_two|
  programme_one = programmes.fetch(programme_one)
  programme_two = programmes.fetch(programme_two)
  @playlist = BBC::MediaPlaylist.new do |playlist|
    playlist << programme_one
    playlist << programme_two
  end.to_xml
end

When /^I ask for the playlist for a servcie that hasn't started broadcasting yet$/ do
  @playlist = BBC::MediaPlaylist.new { |playlist| playlist << { reason: 'preAvailability' } }.to_xml
end

When /^I ask for the playlist for a live programme that has finished broadcasting$/ do
  @playlist = BBC::MediaPlaylist.new { |playlist| playlist << { reason: 'postLiveAvailability'} }.to_xml
end

When /^I ask for the playlist for a programme that has finished broadcasting$/ do
  @playlist = BBC::MediaPlaylist.new { |playlist| playlist << { reason: 'postAvailability' } }.to_xml
end

When /^I ask for a playlist for a service that is currently off air$/ do
  @playlist = BBC::MediaPlaylist.new { |playlist| playlist << { reason: 'offAir' } }.to_xml
end

When /^I ask for a playlist that is empty for no reason$/ do
  @playlist = BBC::MediaPlaylist.new { |playlist| playlist << { reason: 'unknown' } }.to_xml
end

When /^I ask for a playlist that has no playable items$/ do
  @playlist = BBC::MediaPlaylist.new { |playlist| playlist << { reason: 'noPlayableItems' } }.to_xml
end

When /^I ask for a playlist whose media unavailable to international users$/ do
  @playlist = BBC::MediaPlaylist.new { |playlist| playlist << { reason: 'regionRestriction' } }.to_xml
end

When /^I ask for a playlist whose media is missing$/ do
  @playlist = BBC::MediaPlaylist.new { |playlist| playlist << { kind: 'programme' } }.to_xml
end

When /^I ask for a playlist which has no media$/ do
  @playlist = BBC::MediaPlaylist.new { |playlist| playlist << { reason: 'noMedia' } }.to_xml
end

When /^the playlist is malformed$/ do
  no_of_lines =  @playlist.lines.count
  line_to_be_deleted = Random.new.rand(1...no_of_lines)
  @playlist = @playlist.to_s.lines.to_a
  @playlist.delete_at(line_to_be_deleted)
  @playlist = @playlist.join('')
end

Then /^I should get the playlist:$/ do |playlist|
  @playlist.should represent_the_same_xml_as playlist
end

Then /^I should not get the playlist:$/ do |playlist|
  @playlist.should_not represent_the_same_xml_as playlist
end