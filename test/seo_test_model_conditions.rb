class SeoTestModelConditions < ActiveRecord::Base
  set_table_name :seo_test_models
  acts_as_seo_friendly :seo_friendly_id_field => :seo_id, :resource_id => :name, 
                       :conditions => Proc.new {|model| ["name != ?", model.name_test] }

  def name_test
    "test"
  end
end
