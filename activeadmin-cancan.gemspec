$:.push File.expand_path("../lib", __FILE__)

require "activeadmin-cancan/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "activeadmin-cancan"
  s.version     = ActiveadminCancan::VERSION
  s.authors     = ["Laurent Cobos"]
  s.email       = ["laurent@11factory.fr"]
  s.homepage    = "https://github.com/11factory"
  s.summary     = "Provides CanCan roles to ActiveAdmin"
  s.description = "Provides CanCan roles to ActiveAdmin"

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", ">= 3.0"
  s.add_dependency "cancan", ">= 1.6.2"
  s.add_dependency "activeadmin", ">= 0.4.0"
  
  s.add_development_dependency "sqlite3"
end
