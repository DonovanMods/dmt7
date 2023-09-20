# frozen_string_literal: true

require "thor"
require "yaml"
require_relative "support/cli_version"

module DMT7
  CONFIG_FILE = Pathname.new(File.join(Dir.pwd, ".dmt7.yml"))

  class CLI < Thor
    def self.exit_on_failure?
      true
    end

    class_option :config,
                 type: :string,
                 desc: "Specify an alternative config file. Default is \"#{DMT7::CONFIG_FILE.basename}\""
    class_option :verbose,
                 type: :boolean,
                 aliases: "-v",
                 desc: "Prints more verbose output"

    map %w[--version -V] => :__version
    desc "--version, -V", "Prints the version of DMT7"
    def __version
      version_string
      exit 0
    end

    no_commands do
      def options
        original_options = super
        config_options = YAML.load_file(original_options.fetch(:config, DMT7::CONFIG_FILE))
        original_options.merge(config_options)
      end

      def version_string
        puts "#{DMT7::PROGRAM_NAME.upcase.colorize(:bold)} " +
             "v#{DMT7::VERSION} ".colorize(:green) +
             "by #{DMT7::AUTHOR}".colorize(:blue)
      end
    end

    desc "version SUBCOMMAND ...ARGS", "Version related commands"
    subcommand "version", CLIversion
  end
end
