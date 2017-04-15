# frozen_string_literal: true

task :console do
  require "irb"
  require "error_notifier"
  ARGV.clear
  IRB.start
end
