# frozen_string_literal: true

Dir["#{File.expand_path('support', __dir__)}/**/*.rb"].sort.each { |f| require f }

require "pry"

$LOAD_PATH.unshift File.expand_path("../lib", __dir__)
require "error_notifier"

RSpec.configure do |c|
  c.before(:each) do
    notifiers = ErrorNotifier.instance_variable_get("@notifiers")
    notifiers&.clear
  end
end
