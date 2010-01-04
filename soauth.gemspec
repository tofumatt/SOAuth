require 'rake'

Gem::Specification.new do |s|
  s.name = "soauth"
  s.version = "0.1"
  #s.date = Time.now.to_s
  s.authors = ["Matthew Riley MacPherson"]
  s.email = "matt@lonelyvegan.com"
  s.has_rdoc = true
  s.rdoc_options << '--title' << "SOAuth -- Ruby Library that creates HTTP headers for OAuth Authorization" << '--main' << 'README.markdown' << '--line-numbers'
  s.summary = "Create OAuth \"Authorization\" HTTP Header using previously-obtained OAuth data"
  s.homepage = "http://github.com/tofumatt/soauth"
  s.files = FileList['lib/*.rb', '[A-Z]*', 'soauth.gemspec', 'test/*.rb'].to_a
  s.test_file = 'test/soauth_test.rb'
  s.add_development_dependency('mocha') # Used to run the tests, that's all...
end