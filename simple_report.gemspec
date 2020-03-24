# coding: utf-8
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "simple_report/version"

Gem::Specification.new do |spec|
  spec.name          = "simple_report"
  spec.version       = SimpleReport::VERSION
  spec.authors       = ["Joe Francis"]
  spec.email         = ["joe@lostapathy.com"]

  spec.summary       = %q{Generate simple reports.}
  spec.description   = %q{Generate simple reports from Enumerable collections, from simple Arrays to ActiveRecord Collections. }
  spec.homepage      = "https://github.com/lostapathy/simple_report"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/}) || f.match(%r{gem$})
  end
  spec.bindir        = "bin"
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "rake", ">= 12.3.3"
  spec.add_development_dependency "minitest", "~> 5.0"

  spec.add_dependency "rubyXL", '~> 3.4.6'
end
