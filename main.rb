require "bundler/setup"
require "dotenv/load"
require "http"
require "json"
require "pry"
require "rake"
require "sinatra/base"
require "sinatra/reloader"
require_relative "lib/main_api"

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
    content_type "application/json"
  end

  get "/links" do
    api.links.to_json
  end

  get "/tootlink" do
    response.headers["Access-Control-Allow-Origin"] = "https://lubieniebieski.pl"
    halt 400, {error: "Missing url parameter"}.to_json if params[:url].nil?
    puts params[:url]
    link = api.url_to_mastodon_link(params[:url])
    halt 204, {message: "Toot not found"}.to_json if link.nil?
    status 200
    {message: "Toot found", tootURL: link}.to_json
  end

  post "/refresh" do
    if request.env["HTTP_TOKEN"] == ENV.fetch("ACCESS_TOKEN", "secret")
      api.create_links unless File.exist?(api.repository_path)
      repo = api.update_links!
      status 200
      {message: "Refresh successful!", lastUpdated: repo.last_updated, changed: repo.dirty?}.to_json
    else
      halt 401, {error: "Unauthorized"}.to_json
    end
  end
end
