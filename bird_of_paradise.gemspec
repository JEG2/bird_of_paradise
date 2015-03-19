# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'bird_of_paradise/version'

Gem::Specification.new do |spec|
  spec.name          = "bird_of_paradise"
  spec.version       = BirdOfParadise::VERSION
  spec.authors       = ["James Edward Gray II"]
  spec.email         = ["james@graysoftinc.com"]

  spec.summary       = %q{A command-line Twitter client as an example of how to build a curses application.}
  spec.description   = %q{This Twitter client uses the Rurses library to build a moderate sized curses application that uses many typical input and output features.  This is meant to serve as an example for how to build your own curses applications.}
  spec.homepage      = "https://github.com/JEG2/bird_of_paradise"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "dotenv",       "~> 2.0.0"
  spec.add_dependency "twitter",      "~> 5.14.0"
  spec.add_dependency "htmlentities", "~> 4.3.3"
  spec.add_dependency "rurses",       "~> 0.1.0"

  spec.add_development_dependency "bundler", "~> 1.8"
  spec.add_development_dependency "rake",    "~> 10.0"
end
