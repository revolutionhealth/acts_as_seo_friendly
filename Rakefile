require 'config/requirements'
require 'config/hoe' # setup Hoe + all gem configuration

Dir['tasks/**/*.rake'].each { |rake| load rake }

task :gemspec  do
  `rake debug_gem > #{GEM_NAME}.gemspec`
end
