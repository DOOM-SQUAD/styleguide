# Dependencies
require 'kss'
require 'redcarpet'
require 'pygments.rb'
require 'haml'

# Styleguide Engine
require "styleguide/engine"

module Styleguide
  autoload :Configuration, 'styleguide/configuration'

  def self.setup
    @config = Styleguide::Configuration.new
    yield @config
  end

  def self.config
    @config
  end
end
