class Link
  attr_reader :url, :title, :description, :source, :timestamp, :source_url

  def initialize(url:, timestamp:, title: nil, description: nil, source: nil, source_url: nil)
    @url = url
    @title = title
    @description = description
    @source = source
    @timestamp = DateTime.parse(timestamp.to_s).to_datetime.to_s
    @source_url = source_url
  end

  def to_h
    {
      url:,
      title:,
      description:,
      source:,
      timestamp:,
      sourceUrl: source_url,
    }
  end
end
