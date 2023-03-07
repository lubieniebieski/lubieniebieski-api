class Link
  attr_reader :url, :title, :description, :source, :timestamp, :source_url, :tags

  def initialize(url:, timestamp:, title: nil, description: nil, source: nil, source_url: nil, tags: [])
    @url = url
    @title = title
    @description = description
    @source = source
    @timestamp = DateTime.parse(timestamp.to_s).to_datetime.to_s
    @source_url = source_url
    @tags = tags + [source]
  end

  def to_h
    {
      url:,
      title:,
      description:,
      source:,
      timestamp:,
      sourceUrl: source_url,
      tags:,
    }
  end
end
