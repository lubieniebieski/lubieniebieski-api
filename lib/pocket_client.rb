require 'date'
require_relative 'link'

class PocketClient
  class Item
    def initialize(data)
      @data = data
    end

    def tags
      @data.fetch('tags', {}).keys
    end

    def url
      @data.fetch('resolved_url')
    end

    def title
      @data.fetch('resolved_title')
    end

    def public?
      tags.include?('public')
    end

    def description
      @data.fetch('excerpt')
    end

    def timestamp
      Time.at(@data.fetch('time_added').to_i).to_datetime
    end
  end

  def initialize(consumer_key, access_token)
    @consumer_key = consumer_key
    @access_token = access_token
  end

  def links
    items.select(&:public?).map do |i|
      create_link_from_item(i)
    end
  end

  private

  def items
    params = { consumer_key: @consumer_key, access_token: @access_token }
             .merge({ state: 'all', detailType: 'complete', count: 20 })
    response = HTTP.get('https://getpocket.com/v3/get', params:)
    json = JSON.parse(response.body)
    json.fetch('list').values.map do |v|
      Item.new(v)
    end
  end

  def create_link_from_item(item)
    Link.new(url: item.url, title: item.title, timestamp: item.timestamp, description: item.description,
             source: 'pocket')
  end
end
