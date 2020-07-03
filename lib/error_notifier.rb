# frozen_string_literal: true

require "error_notifier/version"
# @author Franky W.
#
# Error Notifier
#
# Central points for all of your Error notification
#
# @example Adding multiple notifiers
#
#   ErrorNotifier.add_notifier(:newrelic) do |exception, _options|
#     NewRelic::Agent.notice_error(e)
#   end
#   ErrorNotifier.add_notifier(:honeybadger) do |exception, options|
#     Honeybadger.notify(exception, options)
#   end
#   ErrorNotifier.add_notifier(:bugsnag) do |exception|
#     Bugsnag.notify(exception)
#   end
#   ErrorNotifier.add_notifier(:kernel) do |exception, options|
#     Kernel.puts(exception)
#   end
#
#   # ... later ...
#
#   begin
#     # something that raises an error
#   rescue => e
#     ErrorNotifier.notify(e)
#   end
#
module ErrorNotifier
  # Raised when an notifer class is added to the the list of
  # notifiers, but the notifiers cannot handle such an object as
  # it notification method
  class InvalidNotiferError < StandardError; end
  class << self
    # Actually send out the notifications
    # to all the registered services
    # @return [nil]
    def notify(err, options = {})
      @notifiers = {} unless defined? @notifiers
      @notifiers.each do |_name, notifier|
        notifier.call(err, options)
      end
      nil
    end

    # Add a notifier to the list of registed notifications
    #
    # @param name [Symbol] Name that will be associated with the notifier
    # @param &block [Proc] Block that will be called with the exception an options
    # @return [nil]
    # @raise [InvalidNotiferError] when passed an object that cannot handle a Notifier interface
    #
    # @example Add HoneyBadger to the list of Error Notification tools
    #   add_notifier(:honeybadger) do |exception, options|
    #     Honeybadger.notice(exception, options)
    #   end
    def add_notifier(name, &block)
      @notifiers = {} unless defined? @notifiers
      if block_given?
        @notifiers[name] = block
      else
        unless (name.respond_to? :call) && (name.method(:call).arity == 2)
          raise InvalidNotiferError "When passing object #{name} to the ErrorNotifier, it must respond to `call(e, options)`"
        end

        @notifiers[name.class.to_s] = name
      end
    end

    # Deletes a notifier from the registered notification tools
    # @param name [Symbol] Name with which the notification was regisitered intiially
    # @return [Notifer]
    def delete_notifier(name)
      @notifiers.delete(name) if defined? @notifiers
    end
  end
end
