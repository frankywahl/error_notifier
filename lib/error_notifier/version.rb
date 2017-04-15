# frozen_string_literal: true

module ErrorNotifier
  # A version object
  class Version
    # Major release
    MAJOR = 0
    # Minor release
    MINOR = 0
    # Patch level
    PATCH = 1
    # Preview
    PRE = nil

    # Return the current version of ErrorNotifer
    # following the semantics versioning
    #
    # @return [String]
    def self.to_s
      [MAJOR, MINOR, PATCH, PRE].compact.join(".")
    end
  end

  # The current version of ErrorNotifer
  VERSION = Version.to_s
end
