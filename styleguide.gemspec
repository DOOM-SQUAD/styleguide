$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "styleguide/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "styleguide"
  s.version     = Styleguide::VERSION
  s.authors     = ["Jared Hoyt"]
  s.email       = ["jaredhoyt@gmail.com"]
  s.homepage    = "http://github.com/doom-squad/styleguide"
  s.summary     = "Styleguide Engine"
  s.description = "Internal styleguide generator."

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.md"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 3.1.12"
  s.add_dependency 'kss', '>= 0.5.0'
  s.add_dependency 'redcarpet', '>= 3.0.0'
  s.add_dependency 'pygments.rb', '>= 0.5.4'
  s.add_dependency 'haml', '>= 3.1.8'

  s.add_development_dependency 'sqlite3'
end
