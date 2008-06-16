class SeoTestModel < ActiveRecord::Base
  acts_as_seo_friendly :seo_friendly_id_field => :seo_id, :resource_id => :name
  
end