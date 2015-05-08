require 'rubocop/rake_task'
require 'rspec/core/rake_task'

RuboCop::RakeTask.new
RSpec::Core::RakeTask.new(:chefspec)

begin
  require 'kitchen/rake_tasks'
  Kitchen::RakeTasks.new
rescue LoadError
  puts '>>>>> Kitchen gem not loaded, omitting tasks' unless ENV['CI']
end

# default tasks are quick, commit tests
desc 'Run without kitchen'
task default: %w(rubocop chefspec)
desc 'Run with kitchen'
task all: %w(rubocop chefspec kitchen:all)
