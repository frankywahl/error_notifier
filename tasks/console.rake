# frozen_string_literal: true
task :console do
  require 'pry'
  require 'error_notifier'
  ARGV.clear
  Pry.start
end
