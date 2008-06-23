require 'rubygems'
require 'active_support'

silence_warnings do
  require 'active_record'
end

module ActiveRecordTestHelper
  def self.included(base)
    ActiveRecord::Base.configurations = {'test' => {'adapter' => "sqlite3", "dbfile" => ":memory:"}}    
  end
  
  def ar_setup
    ActiveRecord::Base.logger = Logger.new(STDOUT)
    ActiveRecord::Base.logger.level = Logger::WARN
    ActiveRecord::Base.logger.level = Logger::DEBUG if ENV['DEBUG_SQL'] == 'true'
    
    ActiveRecord::Base.establish_connection
    ActiveRecord::Base.connection.reconnect!
  end
  
  def ar_teardown
    ActiveRecord::Base.connection.tables.each do |table|
      ActiveRecord::Base.connection.drop_table(table)
    end
    ActiveRecord::Base.connection.disconnect!
  end
  
end