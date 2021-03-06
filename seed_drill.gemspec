# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'seed_drill/version'

Gem::Specification.new do |spec|
  spec.name          = "seed_drill"
  spec.version       = SeedDrill::VERSION
  spec.authors       = ["Sean Carey"]
  spec.email         = ["wycleffsean@gmail.com"]

  spec.summary       = %q{Idempotent seeds for your ruby project}
  spec.description   = %q{Idempotent seeds for your ruby project}
  spec.homepage      = "https://github.com/wycleffsean/seed_drill"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org by setting 'allowed_push_host', or
  # delete this section to allow pushing this gem to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise "RubyGems 2.0 or newer is required to protect against public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "sqlite3"
  spec.add_development_dependency "activerecord"
  spec.add_development_dependency "codeclimate-test-reporter"
end
