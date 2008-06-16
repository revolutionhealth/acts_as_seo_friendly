require 'config/requirements'
require 'config/hoe' # setup Hoe + all gem configuration

Dir['tasks/**/*.rake'].each { |rake| load rake }

task :gemspec  do
  gemspec_file = File.join(File.dirname(__FILE__), "#{GEM_NAME}.gemspec")
  `rake debug_gem > #{gemspec_file}`
  gemspec = File.readlines(gemspec_file)
  gemspec.delete_at(0)
  File.open(gemspec_file, "w+") {|f| f <<  gemspec.to_s() }
end
