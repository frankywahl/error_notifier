# frozen_string_literal: true
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

    def add_notifier(name, &block)
      @notifiers = {} unless defined? @notifiers
      @notifiers[name] = block
    end

    def delete_notifier(name)
      @notifiers.delete(name) if defined? @notifiers
    end
  end
end
