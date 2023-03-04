require 'http'
require 'pry'
require_relative 'link'
class Mastodon
  class Account
    attr_reader :raw_data

    def initialize(data)
      @raw_data = data
    end
  end

  class Status
    attr_reader :raw_data

    def initialize(data)
      @raw_data = data
    end

    def id
      @raw_data.fetch('id')
    end

    def created_at
      @raw_data.fetch('created_at')
    end

    def content
      @raw_data.fetch('content')
    end

    def account
      Account.new @raw_data.fetch('id')
    end

    def reblog
      return if @raw_data.fetch('reblog').nil?

      self.class.new(@raw_data.fetch('reblog'))
    end

    def card
      return if @raw_data.fetch('card').nil?

      Card.new(@raw_data.fetch('card'))
    end
  end

  class Card
    attr_reader :raw_data

    def initialize(data)
      @raw_data = data
    end

    def url
      @raw_data.fetch('url')
    end

    def title
      @raw_data.fetch('title')
    end

    def description
      @raw_data.fetch('description')
    end

    def to_h
      {
        url:,
        title:,
        description:,
      }
    end
  end

  def initialize(account_id)
    @account_id = account_id
  end

  def last_statuses
    @last_statuses ||= begin
      response = HTTP.get("https://social.lol/api/v1/accounts/#{@account_id}/statuses?exclude_replies=true")
      json = JSON.parse(response.body)
      json.map { |j| Status.new(j) }
    end
  end

  def boosted_links
    last_statuses.reject { |s| s.reblog.nil? || s.reblog.card.nil? }
                 .map(&:reblog)
                 .map do |s|
      Link.new(url: s.card.url, title: s.card.title,
               description: s.card.description,
               timestamp: s.created_at)
    end
  end
end
