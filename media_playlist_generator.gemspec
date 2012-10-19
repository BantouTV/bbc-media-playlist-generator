# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'media_playlist_generator/version'

Gem::Specification.new do |gem|
  gem.name          = "media_playlist_generator"
  gem.version       = MediaPlaylistGenerator::VERSION
  gem.authors       = ["Anthony Green"]
  gem.email         = ["anthony.green@bbc.co.uk"]
  gem.description   = %q{BBC Media Playlist Generator}
  gem.summary       = %q{Creates BBC media playlists that you can use to create fake playlists when testing products based on the BBC Media Player}
  gem.homepage      = "http://www.github.com/bbc"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
  gem.add_runtime_dependency 'nokogiri'
  gem.add_development_dependency 'rspec'
  gem.add_development_dependency 'cucumber'
  gem.add_development_dependency 'activesupport'
end
