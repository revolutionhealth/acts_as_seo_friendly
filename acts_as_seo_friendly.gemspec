Gem::Specification.new do |s|
  s.name = %q{acts_as_seo_friendly}
  s.version = "1.1.0"

  s.specification_version = 2 if s.respond_to? :specification_version=

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Revolution Health"]
  s.autorequire = %q{acts_as_seo_friendly}
  s.date = %q{2008-06-23}
  s.description = %q{provides a seo friendly version of field on a table}
  s.email = %q{rails-trunk@revolutionhealth.com}
  s.extra_rdoc_files = ["README", "LICENSE", "TODO"]
  s.files = ["LICENSE", "README", "Rakefile", "TODO", "lib/acts_as_seo_friendly", "lib/acts_as_seo_friendly/version.rb", "lib/acts_as_seo_friendly.rb", "test/active_record_test_helper.rb", "test/seo_test_model.rb", "test/seo_test_model_conditions.rb", "test/test_acts_as_seo_friendly.rb", "test/test_helper.rb"]
  s.homepage = %q{http://github.com/revolutionhealth/acts_as_seo_friendly}
  s.rdoc_options = ["--main", "README"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.1.1}
  s.summary = %q{provides a seo friendly version of field on a table}
  s.test_files = ["test/active_record_test_helper.rb", "test/seo_test_model.rb", "test/seo_test_model_conditions.rb", "test/test_acts_as_seo_friendly.rb", "test/test_helper.rb"]
end
