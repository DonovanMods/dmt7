# frozen_string_literal: true

module DMT7
  class ThorBase < Thor
    include Thor::Actions
    include Logging

    class << self
      def exit_on_failure?
        true
      end
    end

    class_option :verbose,
                 type: :boolean,
                 aliases: "-v",
                 repeatable: true,
                 desc: "Prints more verbose output"
    class_option :dry_run,
                 type: :boolean,
                 desc: "Won't actually perform any destructive operations (e.g. writing to files)"

    map %w[--version -V] => :__version
    desc "--version, -V", "Prints the version of DMT7"
    def __version
      version_string
      exit 0
    end

    private

    def print_errors(errors = [])
      logger.error errors.flatten.compact.uniq.join("\n")
    end

    def version_string
      puts DMT7::PROGRAM_NAME.upcase.white +
           " v#{DMT7::VERSION} " +
           "by #{DMT7::AUTHOR}".cyanish
    end
  end
end
