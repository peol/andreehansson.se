module Jekyll

  class CustomPageGenerator < Generator
    safe false
    priority :lowest
    
    def generate(site)
      @site = site

      Dir.glob('./_pages/*.md').each do |item|
        generate_page item
      end
    end

    def generate_page(file)
      page = Page.new(@site, @site.source, '_pages', File.basename(file))
      # override page directory, we want it in root (heh)
      page.dir = './'
      # do not render this page, jekyll renders the "new" page
      # later, so we just concatenate/move it...
      #page.render(@site.layouts, @site.site_payload)
      page.write(@site.dest)
      @site.pages << page
    end
  end

end