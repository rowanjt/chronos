Gem::Specification.new do |spec|
  spec.name        = 'chronos'
  spec.version     = '0.0.1'
  spec.date        = '2017-12-15'
  spec.summary     = 'Recurring Event Manager'
  spec.description = 'Recurring Event Manager'
  spec.authors     = ['Jeff Rowan']
  spec.email       = ''

  # `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  # also remove .gitignore and .travis.yml
  spec.files       = Dir["{lib}/**/*.rb"]
  spec.homepage    = 'http://rubygems.org/gems/chronos'
  spec.license     = 'MIT'

  spec.metadata       = {
    'source_code_uri' => 'https://github.com/rowanjt/chronos'
  }

  spec.add_development_dependency 'guard', '~> 2.14'
  spec.add_development_dependency 'guard-minitest', '~> 2.4'
  spec.add_development_dependency 'minitest', '~> 5.11'
  spec.add_development_dependency 'minitest-reporters', '~> 1.1'
  spec.add_development_dependency 'rake', '~> 12.3'
  spec.add_development_dependency 'shoulda', '~> 3.6'

  spec.add_dependency 'activesupport', '~> 5.2'
  spec.add_dependency 'json', '2.3.0'
  # The application's Gemfile must tell bundler where to find that library
  # gem 'runt', git: 'https://github.com/rowanjt/runt.git', branch: 'master'
  spec.add_dependency 'runt'
end
