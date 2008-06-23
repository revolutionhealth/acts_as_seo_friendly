require File.dirname(__FILE__) + '/test_helper.rb'
require 'ostruct'

class TestActsAsSeoFriendly < Test::Unit::TestCase
  include ActiveRecordTestHelper
  
  def setup
    ar_setup()
    
    ActiveRecord::Schema.define(:version => 1) do      
      create_table :seo_test_models do |t|
        t.string :name
        t.timestamps
      end
      SeoTestModel.create_seo_friendly_column()
    end
  end
  
  def teardown
    SeoTestModel.drop_seo_friendly_column()
    ar_teardown()
  end

  def test_id_generation

    assert_equal("hi-there-whats-up-yall", create_seo_str("Hi There! What's up y'all"))
    assert_equal("hi-there-whats-up-yall", create_seo_str("Hi There!    What's up y'all"))
    assert_equal("hi-there-whats-up-yall", create_seo_str("Hi There What's up y'all"))
    assert_equal("hi-there-what-s-up-y-all", create_seo_str("Hi There What-s up y-all"))
    assert_equal("hi-there-what-s-up-y-all", create_seo_str("Hi There What---s up y-all"))
    assert_equal("hi-there-what-s-up-y-all", create_seo_str("Hi There What---s up y-all!"))
    
    result = create_seo_str("Hi There! What's up y'all, Howdy there, whatcha doing, whatcha up to?")
    assert result.length <= 50
    assert_equal("hi-there-whats-up-yall-howdy-there-whatcha", result)
    
    result = create_seo_str("onecontinuouslylongwordalskdjflaskjfdlaskdfjlkjsdjsdflkjasdfljlaskdjfallskdfajsdkfj")
    assert_equal(46, result.length)
    assert_equal("onecontinuouslylongwordalskdjflaskjfdlaskdfjlkjsdjsdflkjasdfljlaskdjfallskdfajsdkfj"[0..45], result)
  end
  
  def test_to_param
    assert_nil SeoTestModel.new.to_param
    text_name = "HEY how Are You? I've got a recipe for you!"
    seo_test_model = SeoTestModel.create!(:name => text_name)
    assert_equal("hey-how-are-you-ive-got-a-recipe-for-you", seo_test_model.to_param)
    assert_equal("hey-how-are-you-ive-got-a-recipe-for-you", seo_test_model.seo_id)
    assert_equal(text_name, seo_test_model.name)
  end
  
  def test_incremental_uniques
    text_name = "I'm t@st1ng here!"
    seo_test_model = SeoTestModel.create!(:name => text_name)
    assert_equal(text_name, seo_test_model.name)
    assert_equal("im-t-st1ng-here", seo_test_model.seo_id)
    seo_test_model2 = SeoTestModel.create!(:name => text_name)
    assert_equal("im-t-st1ng-here-1", seo_test_model2.seo_id)
  end
  
  def test_name_change
    text_name = "testing this thing"
    seo_test_model = SeoTestModel.create!(:name => text_name)
    assert_equal(text_name, seo_test_model.name)
    assert_equal("testing-this-thing", seo_test_model.seo_id)
    
    seo_test_model.save!
    seo_test_model.reload
    assert_equal("testing-this-thing", seo_test_model.seo_id)
    
    
    seo_test_model.name = "s@mething else to test w1th"
    seo_test_model.save!
    seo_test_model.reload
    assert_equal("s-mething-else-to-test-w1th", seo_test_model.seo_id)
    
    seo_test_model2 = SeoTestModel.create!(:name => "testing2-2")
    assert_equal("testing2-2", seo_test_model2.seo_id)
    
    seo_test_model3 = SeoTestModel.create!(:name => "testing2-2")
    assert_equal("testing2-2-1", seo_test_model3.seo_id)
    seo_test_model3.name = "testing2-2"
    seo_test_model3.save!
    seo_test_model3.reload
    assert_equal("testing2-2-1", seo_test_model3.seo_id)
    
    seo_test_model3.save!
    seo_test_model3.reload
    assert_equal("testing2-2-1", seo_test_model3.seo_id)
    
  end
  
  def test_something_broken
    oil_1 = SeoTestModel.create!(:name =>"Oil, vegetable, industrial, palm kernel (hydrogenated), confection fat, intermediate grade product")
    assert(oil_1.seo_id.size <= 50)
    oil_2 = SeoTestModel.create!(:name =>"Oil, vegetable, industrial, palm kernel (hydrogenated), confection fat, intermediate grade product")
    assert(oil_2.seo_id.size <= 50)
    broken = SeoTestModel.create!(:name =>"this is soemthing good!")
    assert_not_nil(broken.seo_id)
    broken_2 = SeoTestModel.create!(:name =>"this is soemthing good?")
    assert_not_nil(broken_2.seo_id)
  end
  
  def test_next_dev_issue
    issue = SeoTestModel.create!(:name =>'Test ingredients')
    assert_not_nil issue.seo_id
  end
  
  def test_conditions
    item = SeoTestModelConditions.create!(:name => "test")
    SeoTestModelConditions.expects(:update_all).with('seo_id = \'test\'', ['id = ?', 2]).returns(OpenStruct.new(:seo_id => item.seo_id))
    item2 = SeoTestModelConditions.create!(:name => "test")
    
    # the condition: name != "test" will exclude the first one, 
    # so the second will think it is new, so the seo_id will be the same 
    # (breaking the functionality, but good for testing)
    assert_equal(item.seo_id, item2.seo_id)
  end
  
  def test_collisions
    (0..1001).each do |n|
      oil = SeoTestModel.create!(:name =>"Oil, vegetable, industrial, palm kernel, fat, grade product")
      assert(oil.seo_id.size <= 50)      
    end
    
    oil_short = SeoTestModel.create!(:name =>"Oil")
    assert_equal("oil", oil_short.seo_id)
    assert(oil_short.seo_id.size <= 50)      

    oil_short2 = SeoTestModel.create!(:name =>"Oil")
    assert_equal("oil-1003", oil_short2.seo_id)
    assert(oil_short2.seo_id.size <= 50)

    
    opts = SeoTestModel.read_inheritable_attribute(:seo_friendly_options)
    orig_limit = opts[:seo_friendly_id_limit]    
    opts[:seo_friendly_id_limit] = 8
    SeoTestModel.write_inheritable_attribute(:seo_friendly_options, opts)

    begin
      oil_short3 = SeoTestModel.create!(:name =>"oil")
      assert(oil_short3.seo_id.size <= 8)
    ensure
      opts[:seo_friendly_id_limit] = orig_limit
      SeoTestModel.write_inheritable_attribute(:seo_friendly_options, opts)
    end
    
  end
  
  private
  def create_seo_str(str)
    SeoTestModel.new.send(:create_seo_friendly_str, str)
  end
end
