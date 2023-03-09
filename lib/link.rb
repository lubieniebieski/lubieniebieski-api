Link = Struct.new(:url, :title, :description, :source, :timestamp, :source_url, :tags, keyword_init: true) do
  def initialize(url:, timestamp:, title: nil, description: nil, source: nil, source_url: nil, tags: [])
    timestamp = DateTime.parse(timestamp.to_s).to_datetime.to_s
    tags |= [source]

    super(url:, title:, description:, source:, timestamp:, source_url:, tags:)
  end

  def id
    url
  end

  def self.from_hash(hash)
    new(
      url: hash.fetch('url'),
      title: hash.fetch('title'),
      description: hash.fetch('description'),
      source: hash.fetch('source'),
      timestamp: hash.fetch('timestamp'),
      source_url: hash.fetch('source_url'),
      tags: hash.fetch('tags')
    )
  end
end
