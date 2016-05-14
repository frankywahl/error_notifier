require 'simplecov'
require 'simplecov-console'
require 'codeclimate-test-reporter'

CodeClimate::TestReporter.start

SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter.new([
                                                                 SimpleCov::Formatter::HTMLFormatter,
                                                                 SimpleCov::Formatter::Console,
                                                                 CodeClimate::TestReporter::Formatter
                                                               ])

SimpleCov.start do
  SimpleCov.minimum_coverage 100
end unless ENV.fetch('NO_TEST_COVERAGE', false)
