module Styleguide
  # Custom Redcarpet HTML renderer with syntax highlighting
  class HTMLwithPygments < Redcarpet::Render::HTML
    def block_code(code, language)
      language = language.downcase if language
      html = Pygments.highlight(code, lexer: language)

      "<div class=\"code-block\">#{html}</div>"
    end
  end

  # Application-wide Markdown parser
  MarkdownParser = Redcarpet::Markdown.new(HTMLwithPygments,
    autolink:           true,
    fenced_code_blocks: true,
    hard_wrap:          true,
    no_intraemphasis:   true,
    strikethrough:      true,
    tables:             true
  )

  # Haml :markdown filter
  module Haml::Filters::Markdown
    include Haml::Filters::Base

    lazy_require 'redcarpet'

    def render(text)
      MarkdownParser.render(text)
    end
  end

  # Markdown templates
  class MarkdownTemplateHandler
    def call(template)
      MarkdownParser.render(template.source).inspect + '.html_safe'
    end
  end

  handler = MarkdownTemplateHandler.new

  [:md, :mdown, :markdown].each do |extension|
    ActionView::Template.register_template_handler(extension, handler)
  end
end
