# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'atl_config/version'

Gem::Specification.new do |spec|
  spec.name          = "atl_config"
  spec.version       = AtlConfig::VERSION
  spec.authors       = ["Jeff Turner"]
  spec.email         = ["jeff@redradishtech.com"]

  spec.summary       = %q{Code for parsing config files for Atlassian products}
  spec.description   = %q{Handles server.xml, confluence.cfg.xml and dbconfig.xml}
  spec.homepage      = nil
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]
  spec.has_rdoc      = 'yard'

  spec.add_development_dependency "bundler", "~> 1.11"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "minitest", "~> 5.0"
  spec.add_development_dependency "minitest-reporters"
# https://www.smashingmagazine.com/2014/04/how-to-build-a-ruby-gem-with-bundler-test-driven-development-travis-ci-and-coveralls-oh-my/
  spec.add_development_dependency "guard"
  spec.add_development_dependency "guard-minitest"
  spec.add_development_dependency "pry"
  spec.add_development_dependency "pry-byebug"
  spec.add_development_dependency "yard"

  spec.add_runtime_dependency "parslet"
  spec.add_runtime_dependency "nokogiri"
end
