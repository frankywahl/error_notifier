# frozen_string_literal: true

Dir["#{File.expand_path('../support', __FILE__)}/**/*.rb"].each { |f| require f }

require "pry"

$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)
require "error_notifier"

RSpec.configure do |c|
  c.before(:each) do
    notifiers = ErrorNotifier.instance_variable_get("@notifiers")
    notifiers && notifiers.clear
  end
end
