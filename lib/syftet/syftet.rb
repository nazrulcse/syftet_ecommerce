require 'syftet/configuration'
module Syftet

  class << self
    attr_accessor :config
  end

  def self.configuration
    self.config ||= Configuration.new
  end

  def self.configure
    yield(configuration)
  end
end