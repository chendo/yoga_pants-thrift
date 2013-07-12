# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |spec|
  spec.name          = "yoga_pants-thrift"
  spec.version       = "0.0.1"
  spec.authors       = ["Jack Chen (chendo)"]
  spec.email         = ["gems+yoga_pants-thrift@chen.do"]
  spec.description   = %q{A Thrift transport for the yoga_pants elasticsearch client}
  spec.summary       = %q{This gem gives yoga_pants the ability to use Thrift transports}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"

  spec.add_dependency "addressable"
  spec.add_dependency "connection_pool"
  spec.add_dependency "thrift"
end
