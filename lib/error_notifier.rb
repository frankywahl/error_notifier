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
#     c.add_notifier(NewRelic::Agent, :notice_error)
#     c.add_notifier(Honeybadger, :notify)
#     c.add_notifier(Bugsnag, :notify)
#     c.add_notifier(Kernel, :puts)
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
  # Configuration class
  #
  # This class is in charge for managing the configuration of
  # the notifiers. Namely, it's used to store a link
  # to all the different ways the notifier can send out
  # infomation about an exception
  class Configuration
    attr_reader :notifiers

    def initialize
      @notifiers = {}
    end

    def add_notifier(notifier, method)
      raise NoMethodError, "#{notifier} does not respond to #{method}" unless notifier.respond_to? method
      @notifiers = {} unless defined? @notifiers
      @notifiers[notifier] = method
    end

    def delete_notifier(notifier)
      @notifiers.delete(notifier) if defined? @notifiers
    end
  end

  class << self
    def configure
      @configuration ||= Configuration.new
      yield @configuration
    end

    # Actually send out the notifications
    # to all the registered services
    def notify(e)
      configuration.notifiers.each do |notifier, method|
        notifier.send(method, e)
      end
      nil
    end

    private
    def configuration
      @configuration ||= Configuration.new
    end
  end
end
