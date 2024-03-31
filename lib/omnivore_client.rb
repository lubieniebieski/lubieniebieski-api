require "http"
require "json"
require_relative "link"

LINKS_QUERY = <<~GRAPHQL
  query Search {
      search {
          ... on SearchSuccess {
              edges {
                  cursor
                  node {
                      id
                      title
                      slug
                      url
                      pageType
                      createdAt
                      updatedAt
                      author
                      image
                      description
                      publishedAt
                      originalArticleUrl
                      labels {
                          name
                      }
                      siteName
                      readAt
                      savedAt
                      highlights {
                          quote
                          id
                          representation
                          type
                          annotation
                      }
                      wordsCount
                  }
              }
              pageInfo {
                  hasNextPage
                  hasPreviousPage
                  startCursor
                  endCursor
                  totalCount
              }
          }
      }
  }
GRAPHQL

class OmnivoreClient
  class Item
    PUBLIC_TAGS = %w[public bullets].freeze

    def initialize(data)
      @data = data
    end

    def url
      @data["url"]
    end

    def title
      @data["title"]
    end

    def timestamp
      @data["savedAt"]
    end

    def description
      @data["description"]
    end

    def commentary
      @data["highlights"].find { |highlight| highlight["type"] == "NOTE" }.fetch("annotation", nil)
    end

    def public?
      all_tags.any? { |tag| PUBLIC_TAGS.include?(tag) }
    end

    def tags
      all_tags.reject { |tag| PUBLIC_TAGS.include?(tag) }
    end

    def all_tags
      @data["labels"].map { |label| label["name"] }
    end
  end

  def initialize(token)
    @token = token
  end

  def saved_links
    headers = {"Authorization" => @token, "Content-Type" => "application/json"}
    response = HTTP.get("https://api-prod.omnivore.app/api/graphql", params: {query: LINKS_QUERY}, headers: headers)
    data = JSON.parse(response.body)
    results = data["data"]["search"]["edges"]
    results.each do |result|
      item = Item.new(result["node"])
      create_link_from_item(item) if item.public?
    end
  end

  def create_link_from_item(item)
    Link.new(url: item.url, title: item.title, timestamp: item.timestamp, description: item.description,
      source: "omnivore", tags: item.tags, commentary: item.commentary)
  end
end
