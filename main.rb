require 'sinatra/base'
require 'sinatra/reloader'
require 'json'
require 'pry'
require 'http'
require 'dotenv/load'

require_relative 'lib/pocket_client'
require_relative 'lib/mastodon'

class LubieniebieskiAPI < Sinatra::Base
  MY_MASTODON_ID = '109714665825852984'.freeze

  configure :development do
    register Sinatra::Reloader
  end

  before do
    content_type 'application/json'
  end

  get '/pocket_links' do
    pocket = PocketClient.new(ENV.fetch('POCKET_CONSUMER_KEY', nil), ENV.fetch('POCKET_ACCESS_TOKEN', nil))
    pocket.links.map(&:to_h).to_json
  end

  get '/links' do
    # TODO: get this from file
    pocket = PocketClient.new(ENV.fetch('POCKET_CONSUMER_KEY', nil), ENV.fetch('POCKET_ACCESS_TOKEN', nil))
    mastodon = Mastodon::Client.new MY_MASTODON_ID
    (mastodon.boosted_links + pocket.links).map(&:to_h).to_json
  end

  get '/boosted_links' do
    mastodon = Mastodon::Client.new MY_MASTODON_ID
    mastodon.boosted_links.map(&:to_h).to_json
  end
end
