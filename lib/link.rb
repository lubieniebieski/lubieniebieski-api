class Link
  attr_reader :url, :title, :description, :source, :timestamp

  def initialize(url:, timestamp:, title: nil, description: nil, source: nil)
    @url = url
    @title = title
    @description = description
    @source = source
    @timestamp = timestamp
  end

  def to_h
    {
      url:,
      title:,
      description:,
      source:,
      timestamp:,
    }
  end
end
