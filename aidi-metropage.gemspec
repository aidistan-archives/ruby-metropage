# encoding: UTF-8
$:.push File.expand_path("../lib", __FILE__)
require 'rake'
require 'metropage'

Gem::Specification.new do |s|
  s.name        = "aidi-metropage"
  s.platform    = Gem::Platform::RUBY
  s.summary     = "Windows-8-style page builder"
  s.description = "A tiny library for building windows-8-style single page."

  s.version     = MetroPage::VERSION
  s.license     = 'MIT'

  s.authors     = ["Aidi Stan"]
  s.email       = ["aidistan@live.cn"]
  s.homepage    = "http://aidistan.github.io/aidi-metropage/"

  s.files         = FileList['lib/**/*', '.yardopts', 'rakefile', 'LICENSE', '*.md', ].to_a
  s.require_paths = ["lib"]
end
