# frozen_string_literal: true

require "thor"
require_relative "support/cli_version"

module DMT
  class CLI < Thor
    class_option :verbose, type: :boolean, aliases: "-v"

    map %w[--version -V] => :__version
    desc "--version, -V", "Prints the version of DMT"
    def __version
      puts "#{DMT::PROGRAM_NAME} v#{DMT::VERSION}"
    end

    def self.exit_on_failure?
      true
    end

    desc "version SUBCOMMAND ...ARGS", "Version related commands"
    subcommand "version", CLIversion
  end
end
