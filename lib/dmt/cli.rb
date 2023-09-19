# frozen_string_literal: true

require "thor"

module DMT
  class CLI < Thor
    class_option :verbose, type: :boolean, aliases: "-v"
    class_option :debug,   type: :boolean

    map %w[--version -V] => :version
    desc "version, --version, -V", "Prints the version"
    def version
      puts "#{DMT::PROGRAM_NAME} v#{DMT::VERSION}"
    end

    def self.exit_on_failure?
      true
    end
  end
end
