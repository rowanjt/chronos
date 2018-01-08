Gem::Specification.new do |spec|
  # Only with ruby 2.3.x
  spec.required_ruby_version = '~> 2.3'
  spec.name        = 'chronos'
  spec.version     = '0.0.1'
  spec.date        = '2017-12-15'
  spec.summary     = "Recurring Event Manager"
  spec.description = "Recurring Event Manager"
  spec.authors     = ["Jeff Rowan"]
  spec.email       = ''
# `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
# also remove .gitignore and .travis.yml
  spec.files       = Dir["{lib}/**/*.rb"]
  spec.homepage    = 'http://rubygems.org/gems/chronos'
  spec.license     = 'MIT'

  spec.metadata       = {
    "source_code_uri" => "https://github.com/rowanjt/chronos"
  }

  spec.add_development_dependency 'minitest'
  spec.add_development_dependency 'shoulda'

  spec.add_dependency 'runt'
  spec.add_dependency 'json', '2.1.0'
end
