# frozen_string_literal: true
Dir["#{File.expand_path('../support', __FILE__)}/**/*.rb"].each { |f| require f }

require 'codeclimate-test-reporter'
CodeClimate::TestReporter.start

$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'error_notifier'
