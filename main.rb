require 'sinatra/base'
require 'sinatra/reloader'
require 'json'
require 'pry'
require 'http'
require_relative 'lib/mastodon'

class LubieniebieskiAPI < Sinatra::Base
  MY_MASTODON_ID = '109714665825852984'.freeze

  configure :development do
    register Sinatra::Reloader
  end

  before do
    content_type 'application/json'
  end

  get '/boosted_links' do
    mastodon = Mastodon.new MY_MASTODON_ID
    mastodon.boosted_links.map(&:to_h).to_json
  end
end
