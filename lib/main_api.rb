require_relative 'pocket_client'
require_relative 'mastodon'
require_relative 'readwise_client'
require_relative 'link_repository'

MainAPI = Struct.new(:pocket_client, :mastodon_client, :repository_path, :readwise_client) do
  def self.from_env(env)
    pocket = PocketClient.new(env.fetch('POCKET_CONSUMER_KEY', nil), env.fetch('POCKET_ACCESS_TOKEN', nil))
    mastodon = Mastodon::Client.new env.fetch('MASTODON_ID', nil)
    readwise = ReadwiseClient.new(env.fetch('READWISE_TOKEN', nil))
    repository_path = env.fetch('JSON_DB_PATH', 'data/data.json')
    new(pocket, mastodon, repository_path, readwise)
  end

  def update_links!
    links = (mastodon_client.boosted_links + pocket_client.links + readwise_client.links)
    repository = LinkRepository.from_file(repository_path)
    links.each do |link|
      repository.add(link)
    end
    repository.persist!(repository_path)
  end

  def links
    links_repo.all.map(&:to_h)
  end

  def create_links!
    links = (mastodon_client.boosted_links + pocket_client.links)
    LinkRepository.new(links).persist!(repository_path)
  end

  def url_to_mastodon_link(link)
    mastodon_client.toot_with_link(link)&.source_url
  end

  private

  def links_repo
    @links_repo ||= LinkRepository.from_file(repository_path)
  end
end
