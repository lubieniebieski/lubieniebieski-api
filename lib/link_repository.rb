require_relative 'link'
require 'date'
require 'json'

class LinkRepository
  def self.from_file(file_path)
    data = JSON.parse(File.read(file_path))
    links = data.map { |d| Link.from_hash(d) }
    new(links)
  end

  def initialize(links = [])
    @links = links
  end

  def all
    @links
  end

  def to_json(*_args)
    all.map(&:to_h).to_json
  end

  def find_by_url(url)
    @links.find { |l| l.url == url }
  end

  def add(link)
    @links << link unless find_by_url(link.url)
  end

  def remove(url)
    @links.delete_if { |l| l.url == url }
  end

  def persist!(file_path)
    json = JSON.pretty_generate(@links.sort_by(&:timestamp).reverse.map(&:to_h))
    File.write(file_path, json)
  end

  def update(url, options)
    link = find_by_url(url)
    link.title = options[:title] if options[:title]
    link.description = options[:description] if options[:description]
    link.tags = options[:tags] if options[:tags]
    link.source_url = options[:source_url] if options[:source_url]
    link.source = options[:source] if options[:source]
    link.timestamp = options[:timestamp] if options[:timestamp]
    link
  end
end
