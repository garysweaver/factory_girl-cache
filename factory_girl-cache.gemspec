# -*- encoding: utf-8 -*-  
$:.push File.expand_path("../lib", __FILE__)  
require "factory_girl-cache/version" 

Gem::Specification.new do |s|
  s.name        = 'factory_girl-cache'
  s.version     = RestfulJson::VERSION
  s.authors     = ['Gary S. Weaver']
  s.email       = ['garysweaver@gmail.com']
  s.homepage    = 'https://github.com/garysweaver/factory_girl-cache'
  s.summary     = %q{Caches FactoryGirl factory results.}
  s.description = %q{Use FactoryGirlCache to call or retrieve cached results from FactoryGirl factories.}
  s.files = Dir['lib/**/*'] + ['Rakefile', 'README.md']
  s.license = 'MIT'
  s.add_dependency 'factory_girl', '>= 2.0.0'
end
