class ArchiveTag < Liquid::Tag

  def initialize(tag_name, name, tokens)
    super tag_name, name, tokens
  end

  def render(context)
    @markup = ""
    all_posts = context.registers[:site].posts.sort! { |a,b| b.date <=> a.date }
    years = all_posts.group_by {|post| post.date.year}
    years.each do |year, year_posts|
      @markup += "###{year}\n\n"
      year_posts.each do |post|
        @markup += "#{post.date.strftime "%d %B"}: [#{post.to_liquid['title']}](#{post.url})\n\n"
      end
    end

    @markup
  end

end

Liquid::Template.register_tag('generate_archive_list', ArchiveTag)