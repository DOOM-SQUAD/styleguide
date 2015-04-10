module Styleguide
  class Configuration
    attr_accessor :stylesheet_paths

    def stylesheet_paths
      @stylesheet_paths ||= []
    end
  end
end
