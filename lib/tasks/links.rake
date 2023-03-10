desc 'Generate list of links and save it to data.json file'
task 'links:create' do
  MainAPI.from_env(ENV).create_links!
end

task 'links:update' do
  MainAPI.from_env(ENV).update_links!
end
