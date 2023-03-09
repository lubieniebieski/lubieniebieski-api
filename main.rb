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

class LubieniebieskiAPI < Sinatra::Base
  configure :development do
    register Sinatra::Reloader
  end

  before do
    content_type 'application/json'
  end

  get '/links' do
    Rake::Task['links:generate'].invoke unless File.exist?('data.json')
    LinkRepository.from_file('data.json').to_json
  end
end
