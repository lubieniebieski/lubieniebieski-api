module Mastodon
  class Card
    attr_reader :raw_data

    def initialize(data)
      @raw_data = data
    end

    def url
      @raw_data.fetch("url")
    end

    def title
      @raw_data.fetch("title")
    end

    def description
      @raw_data.fetch("description")
    end

    def to_h
      {
        url:,
        title:,
        description:
      }
    end
  end
end
