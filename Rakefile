require "rake"
require "rspec/core/rake_task"
require "dotenv/load"

# Define RSpec task
RSpec::Core::RakeTask.new(:spec) do |t|
  t.pattern = Dir.glob("spec/**/*_spec.rb")
  t.rspec_opts = "--format documentation"
end

# Import tasks from lib/tasks
Dir.glob("lib/tasks/**/*.rake").each { |rake_file| import rake_file }

# Set the default task
task default: :spec
