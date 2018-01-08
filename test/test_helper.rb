require 'minitest/autorun'
require 'minitest/reporters'
require 'shoulda'
require 'chronos/configuration'

Minitest::Reporters.use!(
  Minitest::Reporters::SpecReporter.new
)

Chronos.configure do |config|
  config.data_path = 'test/data'
end
