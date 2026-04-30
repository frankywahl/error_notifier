# frozen_string_literal: true

require "yard"

YARD::Rake::YardocTask.new do |t|
  t.files = ["lib/**/*.rb"] # optional
  t.options = ["--markup",  "markdown"]
  t.stats_options = ["--list-undoc"]
end
