module Jekyll

  class PodcastRssPage < Page
    def initialize(site, base, dir, post)
      @site = site
      @base = base
      @dir = dir
      @name = 'feed.rss'

      self.process(@name)
      self.data = post.data.clone
      self.data['layout'] = 'podcast_rss'
      self.data['podcast_url'] = site.config['url'] + post.url
      converter = site.find_converter_instance(::Jekyll::Converters::Markdown)
      self.data['description'] = converter.convert(post.content)
      #STDERR.puts post.content
    end
  end

  class PodcastRssPageGenerator < Generator
    safe true

    def generate(site)
      podcasts = site.collections["podcasts"].docs
      podcasts.each do |podcast|
        dir = File.dirname(podcast.destination(site.dest))
        rsspage = PodcastRssPage.new(site, site.source, dir, podcast)
        #STDERR.puts "#{rsspage.dir}#{rsspage.name}, #{podcast.data}"
        site.pages << rsspage
      end
    end
  end

end
