require 'rake/testtask'

# NOTE: replaces ruby -I test:lib test/test_chronos.rb
Rake::TestTask.new do |task|
  task.libs << %w(test)
  task.pattern = 'test/**/test_*.rb'
end

task :default => :test
