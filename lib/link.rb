class Link
  attr_reader :url, :title, :description, :source, :timestamp

  def initialize(url:, timestamp:, title: nil, description: nil, source: nil)
    @url = url
    @title = title
    @description = description
    @source = source
    @timestamp = DateTime.parse(timestamp.to_s).to_datetime.to_s
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
