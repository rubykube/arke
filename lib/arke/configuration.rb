module Arke
  class << self
    attr_accessor :configuration
  end

  def self.configure
    self.configuration ||= Configuration.new
    yield(configuration)
  end

  class Configuration
    attr_accessor :host, :api_key

    def initialize
      @host = ''
      @api_key = {}
    end
  end
end
