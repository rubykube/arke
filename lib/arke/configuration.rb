module Arke
  PropertyNotSetError = Class.new(StandardError)

  class << self
    attr_accessor :config
  end

  def self.configure
    self.config ||= OpenStruct.new
    yield(config)
  end
end
