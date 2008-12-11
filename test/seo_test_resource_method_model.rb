class SeoTestResourceMethodModel < ActiveRecord::Base
  set_table_name :seo_test_models
  #use a method as a resource id
  acts_as_seo_friendly :seo_friendly_id_field => :seo_id, :resource_id => :foo
  
  def foo
    self.name
  end
  
end