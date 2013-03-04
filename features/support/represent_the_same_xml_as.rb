RSpec::Matchers.define :represent_the_same_xml_as do |expected_xml_document|
  
  match do |actual_xml_document|
    actual_xml_document.strip.sub(/\n/, '').eql? expected_xml_document.strip.sub(/\n/, '')
  end

  failure_message_for_should do |actual_xml_document|
    "expected playlist to look like:\n#{expected_xml_document.strip.sub(/\n/, '')}\ninstead it looked like\n#{actual_xml_document.strip.sub(/\n/, '')}"
  end
  
end