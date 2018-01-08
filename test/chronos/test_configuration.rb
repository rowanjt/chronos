require 'test_helper'

class TestConfiguration < Minitest::Test
  def setup
    @orig_path = Chronos.configuration.data_path
  end

  def teardown
    Chronos.configure do |config|
      config.data_path = @orig_path
    end
  end

  should 'configure the default data path' do
    Chronos.configure # set default configuration

    assert_equal 'data', Chronos.configuration.data_path
  end

  should 'configure the data path' do
    config_path = '/usr/src/app/public/system'
    Chronos.configure do |config|
      config.data_path = config_path
    end

    assert_equal config_path, Chronos.configuration.data_path
  end
end
