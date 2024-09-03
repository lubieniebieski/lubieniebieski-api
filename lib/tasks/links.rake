require_relative "../main_api"

desc "Generates list of links from APIs and saves it to file"
task "links:create" do
  MainAPI.from_env(ENV).create_links!
end

desc "Updates links from APIs and saves to file"
task "links:update" do
  MainAPI.from_env(ENV).update_links!
end
