RAILS_ENV = 'test' if !defined?(RAILS_ENV) || RAILS_ENV != 'test'
require 'test/unit'
require 'rubygems'

require 'active_record_test_helper'

require File.dirname(__FILE__) + '/../lib/acts_as_seo_friendly'

require 'mocha'
require File.join(File.dirname(__FILE__), 'seo_test_model')
require File.join(File.dirname(__FILE__), 'seo_test_model_conditions')


