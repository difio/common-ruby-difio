# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "common-ruby-difio/version"

Gem::Specification.new do |s|
  s.name        = "common-ruby-difio"
  s.version     = Difio::DifioBase::VERSION
  s.authors     = ["Svetlozar Argirov"]
  s.email       = ["zarrro@gmail.com"]
  s.homepage    = "http://github.com/difio/common-ruby-difio"
  s.summary     = %q{Common module for Difio ruby clients}
  s.description = %q{Common module for Difio ruby clients. Not intended for direct use. Use a difio-\<vendor\>-ruby gem instead. }

  s.rubyforge_project = "common-ruby-difio"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  # specify any dependencies here; for example:
  # s.add_development_dependency "rspec"
  s.add_runtime_dependency "json"
end
