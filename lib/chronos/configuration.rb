module Chronos
  class << self
    attr_accessor :configuration
  end

  def self.configure
    self.configuration ||= Configuration.new
    if block_given?
      yield(configuration)
    else
      configuration.reset
    end
  end

  class Configuration
    attr_accessor :data_path

    def initialize
      @data_path = 'data'
    end

    def reset
      @data_path = 'data'
    end
  end
end
