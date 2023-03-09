desc 'Generate list of links and save it to data.json file'
task 'links:create' do
  pocket = PocketClient.new(ENV.fetch('POCKET_CONSUMER_KEY', nil), ENV.fetch('POCKET_ACCESS_TOKEN', nil))
  mastodon = Mastodon::Client.new ENV.fetch('MASTODON_ID', nil)
  links = (mastodon.boosted_links + pocket.links)
  LinkRepository.new(links).persist!(JSON_DB_PATH)
  links.map(&:to_h).to_json
end

task 'links:update' do
  pocket = PocketClient.new(ENV.fetch('POCKET_CONSUMER_KEY', nil), ENV.fetch('POCKET_ACCESS_TOKEN', nil))
  mastodon = Mastodon::Client.new ENV.fetch('MASTODON_ID', nil)
  links = (mastodon.boosted_links + pocket.links)

  repository = LinkRepository.from_file(JSON_DB_PATH)
  links.each do |link|
    repository.add(link)
  end
  repository.persist!(JSON_DB_PATH)
end
