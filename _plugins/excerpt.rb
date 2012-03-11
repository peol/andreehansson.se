# modified, original at http://www.jacquesf.com/2011/03/creating-excerpts-in-jekyll-with-wordpress-style-more-html-comments/

module Excerpt
  def excerpt(input, url, text)
    if input.include? "<!--more-->"
      input.split("<!--more-->").first + "<p class=\"more\"><a href=\"#{url}\">#{text}</a></p>"
    else
      input
    end
  end
end

Liquid::Template.register_filter(Excerpt)