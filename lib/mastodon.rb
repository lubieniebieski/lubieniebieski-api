require "http"
require_relative "link"
require_relative "mastodon/status"
require_relative "mastodon/card"
require_relative "mastodon/account"

module Mastodon
  class Client
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
        .map { |s| create_link_from_status(s) }
    end

    def toot_with_link(link)
      toot = last_statuses.select(&:card)
        .find { |s| s.card.url == link }
      return if toot.nil?

      create_link_from_status(toot)
    end

    private

    def create_link_from_status(status)
      card = status.card
      Link.new(url: card.url, title: card.title,
        description: card.description,
        timestamp: status.created_at, source: "mastodon",
        source_url: status.url)
    end
  end
end
