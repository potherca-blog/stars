# Liquid tags in the code of dev.to are at:
#
# https://github.com/thepracticaldev/dev.to/tree/master/app/views/liquids
# https://github.com/thepracticaldev/dev.to/tree/HEAD/app/liquid_tags
module Jekyll
  class TextTag < Liquid::Tag
    def render(context) @text end

    def initialize(tag_name, text, tokens)
      super
      @tag_name = tag_name
      @text = text
    end
  end

  class HtmlTag < Jekyll::TextTag
    def render(context)
      @text = super
      <<~HTML
        <p class="liquid-tag liquid-tag--#{@tag_name}">#{@text}</p>
      HTML
    end
  end

  class ImageTag < Jekyll::HtmlTag
    def link(text) text end

    def render(context)
      link = link(@text)
      @text = <<~HTML
                <a href="#{link}"><img alt="#{@text}" src="#{source}" /></a>
      HTML
      super
    end

    def source(text) text end
  end

  class LinkTag < Jekyll::HtmlTag
    def link(text) text end

    def render(context)
      link = link(@text)
      @text = <<~HTML
          <a href="#{link}">#{@text}</a>
      HTML
      super
    end
  end

  class GithubTag < Jekyll::ImageTag
    def link(text) "https://github.com/#{text}" end
    def source(text) "https://gh-card.dev/repos/#{text}.png" end
  end

  class PostTag < Jekyll::LinkTag
    def link(text) "https://dev.to/#{text}" end
  end

  class TwitterTag < Jekyll::LinkTag
    def link(text) "https://twitter.com/#{text}" end
  end
end

# Register tags
Liquid::Template.register_tag('github', Jekyll::GithubTag)
Liquid::Template.register_tag('post', Jekyll::PostTag)
Liquid::Template.register_tag('tag', Jekyll::TextTag)
Liquid::Template.register_tag('twitter', Jekyll::TwitterTag)
Liquid::Template.register_tag('user', Jekyll::HtmlTag)
