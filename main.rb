# frozen_string_literal: true

require 'sinatra/base'
require 'sinatra/reloader'
require 'json'

# Main API class
class LubieniebieskiAPI < Sinatra::Base
  configure :development do
    register Sinatra::Reloader
  end

  before do
    content_type 'application/json'
  end

  get '/links' do
    IO.read('links.json')
  end
end
