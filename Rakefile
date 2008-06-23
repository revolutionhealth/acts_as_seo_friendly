require 'rubygems'
require 'rake/gempackagetask'
require 'rubygems/specification'
require 'date'

GEM = "acts_as_seo_friendly"
GEM_VERSION = "1.1.0"
AUTHOR = "Revolution Health"
EMAIL = "rails-trunk@revolutionhealth.com"
HOMEPAGE = %q{http://github.com/revolutionhealth/acts_as_seo_friendly}
SUMMARY = "provides a seo friendly version of field on a table"
DESCRIPTION = "provides a seo friendly version of field on a table"


spec = Gem::Specification.new do |s|
  s.name = GEM
  s.version = GEM_VERSION
  s.platform = Gem::Platform::RUBY
  s.has_rdoc = false
  s.extra_rdoc_files = ["README", "LICENSE", 'TODO']
  s.summary = SUMMARY
  s.description = DESCRIPTION
  s.author = AUTHOR
  s.email = EMAIL
  s.homepage = HOMEPAGE
  s.rdoc_options = ["--main", "README"]
  
  
  # Uncomment this to add a dependency
  # s.add_dependency "foo"
  
  s.require_path = 'lib'
  s.autorequire = GEM
  s.files = %w(LICENSE README Rakefile TODO) + Dir.glob("{lib,specs,test, config}/**/*") 
  s.test_files = Dir.glob("{test}/**/*") 
end

Rake::GemPackageTask.new(spec) do |pkg|
  pkg.gem_spec = spec
end

desc "install the gem locally"
task :install => [:package] do
  sh %{sudo gem install pkg/#{GEM}-#{GEM_VERSION}}
end

desc "create a gemspec file"
task :make_spec do
  File.open("#{GEM}.gemspec", "w") do |file|
    file.puts spec.to_ruby
  end
end

require 'test/unit'
 
task :test do
 runner = Test::Unit::AutoRunner.new(true)
 runner.to_run << 'test'
 runner.pattern = [/_test.rb$/]
 exit if !runner.run
end
 
task :default => [:test, :package] do
end
