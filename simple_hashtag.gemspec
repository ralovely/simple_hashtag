# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'simple_hashtag/version'

Gem::Specification.new do |spec|
  spec.name          = "simple_hashtag"
  spec.version       = SimpleHashtag::VERSION
  spec.authors       = ["Raphael Campardou"]
  spec.email         = ["ralovely@gmail.com"]
  spec.description   = %q{Parse, store retreive and format hashtags in your text.}
  spec.summary       = %q{Simple Hashtag is a mix between–well–hashtags as we know them and categories. It will scan your Active Record attribute for a tag and store it in an index.}
  spec.homepage      = "https://github.com/ralovely/simple_hashtag"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.required_ruby_version = ">= 1.9.3"
  spec.add_dependency "rails", "> 3.2.0"

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec-rails"
  spec.add_development_dependency "sqlite3"
end
