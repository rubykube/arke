#-*- RUBY -*-

Gem::Specification.new do |spec|
  spec.name = "arke"
  spec.version = "0.0.1"
  spec.summary = %q{Arke trading bot library}
  spec.files = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.require_paths = ["lib"]
  spec.bindir = "bin"
  spec.executables = ["arke"]
  spec.authors = ["Louis Bellet", "Camille Meulien"]
  spec.email = ["lbellet@heliostech.fr", "cmeulien@heliostech.fr"]

  spec.add_dependency "clamp"
  spec.add_dependency "em-synchrony"
  spec.add_dependency "em-http-request"
  spec.add_dependency "faraday"
  spec.add_dependency "faraday_middleware"
  spec.add_dependency "faye-websocket"
  spec.add_dependency "json"
  spec.add_dependency "rbtree"
  spec.add_dependency "tty-table"

  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "webmock"
  spec.add_development_dependency "pry"
  spec.add_development_dependency "simplecov"
  spec.add_development_dependency "simplecov-rcov"
  spec.add_development_dependency "codecov"
end
