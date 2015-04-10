module Styleguide
  module SectionsHelper

    def styleguide_link_to(title, options = {}, html_options = {})
      options = defaults.merge(options)
      html_options[:class] = 'selected' if is_selected?(options)

      link_to title, sections_path(options), html_options
    end

    def highlight_syntax(code, lexer = '')
      Pygments.highlight(code, lexer: lexer)
    end

    def styleguide_section
      params.fetch(:section, 'overview')
    end

    def styleguide_reference
      params.fetch(:reference, 'index')
    end

    private

    def defaults
      { section: styleguide_section }
    end

    def is_selected?(options)
      selected = options[:section] == styleguide_section
      selected = options[:reference].to_s == styleguide_reference if options[:reference].present?
      selected
    end

  end
end
