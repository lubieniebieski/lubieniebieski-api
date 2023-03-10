require 'bundler/setup'
require 'dotenv/load'
require 'http'
require 'json'
require 'pry'
require 'rake'
require 'sinatra/base'
require 'sinatra/reloader'
Dir.glob('lib/tasks/*.rake').each { |r| load r }

require_relative 'lib/pocket_client'
require_relative 'lib/mastodon'
require_relative 'lib/link_repository'

JSON_DB_PATH = ENV.fetch('JSON_DB_PATH', 'data/data.json')

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

  post '/refresh' do
    if request.env['HTTP_TOKEN'] == ENV.fetch('ACCESS_TOKEN', 'secret')
      Rake::Task['links:create'].invoke unless File.exist?(JSON_DB_PATH)
      Rake::Task['links:update'].invoke
      status 200
      { message: 'Refresh successful' }.to_json
    else
      halt 401, { error: 'Unauthorized' }.to_json
    end
  end
end
