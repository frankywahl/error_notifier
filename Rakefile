# frozen_string_literal: true

require "bundler/gem_tasks"
require "rspec/core/rake_task"

Rake.add_rakelib("tasks")

task test: :spec
task default: %i[rubocop spec]

task rebuild: %i[build install]
