require 'rubygems/package_task'
require 'yard'
require 'yard/rake/yardoc_task'
require 'rake/testtask'

require_relative 'lib/jacman/core/version.rb'

spec = Gem::Specification.new do |s|
  s.name = 'jacman-core'
  s.version = JacintheManagement::Core::VERSION
  s.has_rdoc = true
  s.extra_rdoc_files = %w(README.md LICENSE)
  s.summary = 'Script tools (core) for Jacinthe DB management'
  s.description = 'Script tools (core) for Jacinthe DB management'

  s.add_development_dependency('rake')
  s.add_development_dependency('yard')
  s.add_development_dependency('minitest')
  s.add_development_dependency('minitest-reporters')

  s.add_dependency('net-ssh')
  s.add_dependency('net-scp')
  s.add_dependency('net-sftp')
  s.add_dependency('mysql2', '0.3.13')
  s.add_dependency('sequel')
  s.add_dependency('prawn')

  s.author = 'Michel Demazure'
  s.email = 'michel@demazure.com'
  s.files = %w(LICENSE README.md HISTORY.md MANIFEST Rakefile) + Dir.glob('{lib,spec}/**/*')
  s.require_path = 'lib'
  s.bindir = 'bin'
end

Gem::PackageTask.new(spec) do |p|
  p.gem_spec = spec
  # p.need_tar = true
  # p.need_zip = true
end

desc 'build Manifest'
task :manifest do
  system ' mast lib spec HISTORY.md LICENSE Rakefile README.md > MANIFEST '
end

YARD::Rake::YardocTask.new do |t|
  t.options += ['--title', "Jacinthe Management #{JacintheManagement::Core::VERSION} Documentation"]
  t.options += %w(--files LICENSE)
  t.options += ['--files', 'HISTORY.md']
  t.options += ['--files', 'TODO.md']
  t.options += %w(--files MANIFEST)
  t.options += ['--no-private']
end

Rake::TestTask.new do |t|
  t.libs.push 'lib'
  t.test_files = FileList['spec/*_spec.rb']
  t.verbose = true
end

import('metrics.rake') if File.exist?('metrics.rake')
