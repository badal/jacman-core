# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'jacman/core/version'


Gem::Specification.new do |s|
  s.name = "jacman-core"
  s.version = JacintheManagement::Core::VERSION
  s.authors = ["Michel Demazure"]
  s.description = "Core and Script tools for Jacinthe DB management"
  s.email = "michel@demazure.com"
  s.executables = ["batman", "cronman", "jacdev"]
  s.extra_rdoc_files = ["README.md", "LICENSE"]
  s.files = ["bin/batman", "bin/cronman", "bin/jacdev", "README.md", "LICENSE"]
  s.homepage = "http://github/badal/jacman-core"
  s.require_paths = ["lib"]
  s.summary = "Core methods for Jacinthe DB management"

  s.add_development_dependency(%q<rake>, [">= 0"])
  s.add_development_dependency(%q<yard>, [">= 0"])
  s.add_development_dependency(%q<minitest>, [">= 0"])
  s.add_development_dependency(%q<minitest-reporters>, [">= 0"])

  s.add_runtime_dependency(%q<net-ssh>, [">= 0"])
  s.add_runtime_dependency(%q<net-scp>, [">= 0"])
  s.add_runtime_dependency(%q<net-sftp>, [">= 0"])
  s.add_runtime_dependency(%q<mysql2>, ["= 0.3.13"])
  s.add_runtime_dependency(%q<sequel>, [">= 0"])
  s.add_runtime_dependency(%q<prawn>, [">= 0"])

end
