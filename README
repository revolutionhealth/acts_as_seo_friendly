= acts_as_seo_friendly

http://revolutiononrails.blogspot.com/

== DESCRIPTION:

Create an SEO friendly field for a model automatically based on a given field.

So if you have a Blogs model, and you would like create an SEO friendly version 
of the 'title' field, you would just add this to your model and then be able to 
use the SEO friendly id as the unique id to the resource.  The plugin will only
append an integer to the SEO id if there is a collision.

== FEATURES/PROBLEMS:

* Only tested on mysql and sqlite3


== SYNOPSIS:


Create seo column migration:

 class CreateSeoTestModels < ActiveRecord::Migration
   def self.up
     create_table :seo_test_models do |t|
       t.string :name
       t.timestamps
     end
	 SeoTestModel.create_seo_friendly_column()
   end

   def self.down
	 SeoTestModel.drop_seo_friendly_column()
     drop_table :seo_test_models
   end
 end


Add to model:

 class SeoTestModel < ActiveRecord::Base
	acts_as_seo_friendly :resource_id => :name, 
					     :seo_friendly_id_field => :seo_id, # default is :seo_friendly_id
					     :seo_friendly_id_limit => 100 # default is 50
 end


To lookup the resource in the controllers use:

  SeoTestModel.find_by_seo_id(params[:id])



== REQUIREMENTS:


== INSTALL:

* sudo gem install revolutionhealth-acts_as_seo_friendly -s http://gems.github.com


== LICENSE:

(The MIT License)

Copyright (c) 2008 Revolution Health Group LLC

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
'Software'), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.