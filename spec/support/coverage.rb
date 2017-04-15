# frozen_string_literal: true
require 'simplecov'
require 'simplecov-console'

SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter.new([
                                                                 SimpleCov::Formatter::HTMLFormatter,
                                                                 SimpleCov::Formatter::Console
                                                               ])

SimpleCov.start do
  SimpleCov.minimum_coverage 100
end unless ENV.fetch('NO_TEST_COVERAGE', false)
