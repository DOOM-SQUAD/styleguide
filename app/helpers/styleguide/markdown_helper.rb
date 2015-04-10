module Styleguide
  module MarkdownHelper

    def markdown(text)
      MarkdownParser.render(text).html_safe
    end

  end
end
