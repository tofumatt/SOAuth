require 'rake'

Gem::Specification.new do |s|
  s.name = "soauth"
  s.version = "0.2"
  s.date = Time.now
  s.authors = ["Matthew Riley MacPherson"]
  s.email = "matt@lonelyvegan.com"
  s.has_rdoc = true
  s.rdoc_options << '--title' << "SOAuth -- Ruby library that creates HTTP headers for OAuth Authorization" << '--main' << 'README.markdown' << '--line-numbers'
  s.summary = "Ruby library that creates HTTP headers for OAuth Authorization using previously-obtained OAuth keys/secrets"
  s.homepage = "http://github.com/tofumatt/soauth"
  s.files = FileList['lib/*.rb', '[A-Z]*', 'soauth.gemspec', 'test/*.rb'].to_a
  s.test_file = 'test/soauth_test.rb'
  s.add_development_dependency('mocha') # Used to run the tests, that's all...
end