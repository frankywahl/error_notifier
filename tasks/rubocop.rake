# frozen_string_literal: true
require 'rubocop/rake_task'

desc 'Run RuboCop on the lib directory'
RuboCop::RakeTask.new(:rubocop) do |task|
  task.patterns = ['lib/**/*.rb']

  # only show the files with failures
  task.formatters = ['files']

  task.options += %w(
    --display-cop-names
    --extra-details
    --format clang
  )

  # abort rake on failure
  task.fail_on_error = true
end
