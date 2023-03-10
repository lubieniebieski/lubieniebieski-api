require 'bundler/setup'
require 'dotenv/load'
require 'http'
require 'json'
require 'pry'
require 'rake'
require 'sinatra/base'
require 'sinatra/reloader'
require_relative 'lib/main_api'

class Server < Sinatra::Base
  configure :development do
    register Sinatra::Reloader
  end

  helpers do
    def api
      @api ||= MainAPI.from_env(ENV)
    end
  end

  before do
    content_type 'application/json'
  end

  get '/links' do
    api.links.to_json
  end

  post '/refresh' do
    if request.env['HTTP_TOKEN'] == ENV.fetch('ACCESS_TOKEN', 'secret')
      api.create_links unless File.exist?(api.repository_path)
      api.update_links!
      status 200
      { message: 'Refresh successful' }.to_json
    else
      halt 401, { error: 'Unauthorized' }.to_json
    end
  end
end
