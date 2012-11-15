# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'kramdown-gist/version'

Gem::Specification.new do |gem|
  gem.name          = "kramdown-gist"
  gem.version       = Kramdown::Gist::VERSION
  gem.platform      = Gem::Platform::RUBY
  gem.authors       = ["Matteo Panella"]
  gem.email         = ["morpheus@level28.org"]
  gem.description   = %q{Kramdown syntax for embedded gists}
  gem.summary       = %q{Extend Kramdown syntax to generate script tags for embedded gists}
  gem.homepage      = "https://github.com/rfc1459/kramdown-gist"

  gem.add_dependency('kramdown', '~> 0.14.0')

  gem.add_development_dependency('yard', '~> 0.8.3')
  gem.add_development_dependency('bundler', '>= 1.0.0')

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
end
