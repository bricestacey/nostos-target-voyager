# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "nostos-target-voyager/version"

Gem::Specification.new do |s|
  s.name        = "nostos-target-voyager"
  s.version     = Target::Voyager::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Brice Stacey"]
  s.email       = ["bricestacey@gmail.com"]
  s.homepage    = "https://github.com/bricestacey/nostos-target-voyager"
  s.summary     = %q{Nostos Target Driver for Voyager ILS}
  s.description = %q{Nostos Target Driver for Voyager ILS}

  s.rubyforge_project = "nostos-target-voyager"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
  s.add_dependency('voyager')
  s.add_dependency('rails')
end
