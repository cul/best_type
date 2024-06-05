require File.expand_path("../lib/best_type/version", __FILE__)

Gem::Specification.new do |s|
  s.name        = 'best_type'
  s.version     = BestType::VERSION
  s.platform    = Gem::Platform::RUBY
  s.date        = '2018-03-25'
  s.summary     = "A library for selecting the best mime type or dc type for a file."
  s.description = "A library for selecting the best mime type or dc type for a file."
  s.authors     = ["Eric O'Hanlon"]
  s.email       = 'elo2112@columbia.edu'
  s.homepage    = 'https://github.com/cul/best_type'
  s.license     = 'MIT'

  s.add_dependency("mime-types", "~> 3.4")

  s.add_development_dependency("rake", ">= 10.1")
  s.add_development_dependency("rspec", "~>3.7")
  s.add_development_dependency("rubocul", "~> 4.0.11")
  s.add_development_dependency("simplecov", "~> 0.15.1")

  s.files        = Dir["lib/**/*.rb", "lib/tasks/**/*.rake", "bin/*", "config/*", "LICENSE", "*.md"]
  s.require_paths = ['lib']
end
