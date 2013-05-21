Gem::Specification.new do |s|
  s.platform    = Gem::Platform::RUBY
  s.name        = 'spree_user_groups'
  s.version     = '0.40.2'
  s.summary     = 'Adds user groups'
  s.description = 'Provides opportunity to add some rules for calculation price depending on the user group'
  s.required_ruby_version = '>= 1.8.7'

  s.author            = 'Roman Smirnov'
  s.email             = 'roman@railsdog.com'
  s.homepage          = 'https://github.com/romul/spree_user_groups'
  # s.rubyforge_project = 'actionmailer'

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.require_path = 'lib'
  s.requirements << 'none'

  s.has_rdoc = true

  s.add_dependency 'spree_core', '~> 1.3.0'
  s.add_dependency 'spree_auth_devise', '~> 1.0'
  s.add_development_dependency 'factory_girl'
  s.add_development_dependency 'rspec-rails',  '~> 2.7'
  s.add_development_dependency 'shoulda-matchers', '~> 1.4.2'
  s.add_development_dependency 'sqlite3'
end
