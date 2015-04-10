module Styleguide
  module KssHelper

    def kss_block(section, &block)
      @section = kss.section(section)

      raise "KSS styleguide section '#{section}' was not found." if @section.raw.blank?

      content = capture(&block)
      render 'styleguide/shared/kss_block', section: @section, example_html: content
    end

    private

    def kss
      @kss ||= Kss::Parser.new(*Styleguide.config.stylesheet_paths)
    end

  end
end
