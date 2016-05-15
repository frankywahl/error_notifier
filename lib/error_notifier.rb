# frozen_string_literal: true
require 'error_notifier/version'
# Error Notifier
#
# Central points for all of your Error notification
#
#
# Example:
#
#   ErrorNotifier.configure do |c|
#     c.add_notifier(:newrelic) do |exception, _options|
#       NewRelic::Agent.notice_error(e)
#     end
#     c.add_notifier(:honeybadger) do |exception, options|
#       Honeybadger.notify(exception, options)
#     end
#     c.add_notifier(:bugsnag) do |exception|
#       Bugsnag.notify(exception)
#     end
#     c.add_notifier(:kernel) do |exception, options|
#       Kernel.puts(exception)
#     end
#   end
#
# ... later ...
#
# begin
#   # something that raises an error
# rescue => e
#   ErrorNotifier.notify(e)
# end
#
module ErrorNotifier
  class << self
    # Actually send out the notifications
    # to all the registered services
    def notify(e, options = {})
      @notifiers = {} unless defined? @notifiers
      @notifiers.each do |_name, notifier|
        notifier.call(e, options)
      end
      nil
    end

    def add_notifier(name, &block)
      @notifiers = {} unless defined? @notifiers
      @notifiers[name] = block
    end

    def delete_notifier(name)
      @notifiers.delete(name) if defined? @notifiers
    end
  end
end
