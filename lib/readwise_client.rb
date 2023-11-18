require 'date'
require 'http'
require_relative 'link'

class ReadwiseClient
  class Item
    def initialize(data)
      @data = data
    end

    def url
      @data.fetch('url')
    end

    def title
      @data.fetch('title')
    end

    def public?
      all_tags.include?('public') || all_tags.include?('bullets')
    end

    def tags
      all_tags.reject { |t| t == 'public' }
    end

    def timestamp
      DateTime.parse(@data.fetch('created_at'))
    end

    def description
      @data.fetch('summary')
    end

    private

    def all_tags
      @data.fetch('tags', {}).keys
    end
  end

  def initialize(token)
    @token = token
    @updated_after = DateTime.now.prev_day(100).to_s
    @location = 'archive'
  end

  def links(size: 20)
    items(size).select(&:public?).map do |i|
      create_link_from_item(i)
    end
  end

  private

  def items(_count)
    params = { updatedAfter: @updated_after, location: @location }
    headers = { 'Authorization' => "Token #{@token}" }
    response = HTTP.headers(headers).get('https://readwise.io/api/v3/list/', params:)
    json = JSON.parse(response.body)
    json.fetch('results').map do |result|
      Item.new(result)
    end
  end

  def create_link_from_item(item)
    Link.new(url: item.url, title: item.title, timestamp: item.timestamp, description: item.description,
             source: 'readwise', tags: item.tags)
  end
end
