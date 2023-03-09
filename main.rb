require 'sinatra/base'
require 'sinatra/reloader'
require 'json'
require 'pry'
require 'http'
require 'dotenv/load'
require 'rake'
Dir.glob('lib/tasks/*.rake').each { |r| load r }

require_relative 'lib/pocket_client'
require_relative 'lib/mastodon'
require_relative 'lib/link_repository'

JSON_DB_PATH = '/data/data.json'.freeze

class LubieniebieskiAPI < Sinatra::Base
  configure :development do
    register Sinatra::Reloader
  end

  before do
    content_type 'application/json'
  end

  get '/links' do
    Rake::Task['links:create'].invoke unless File.exist?(JSON_DB_PATH)
    LinkRepository.from_file(JSON_DB_PATH).to_json
  end
end
