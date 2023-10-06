# frozen_string_literal: true

require "config"
require "thor"

# Require all files
base_dir = %w[lib dmt7]
%w[support plugins sub_commands].each do |dir|
  Dir[File.join(base_dir, dir, "**", "*.rb")].each do |path|
    require_relative File.join(path.split("/") - base_dir) if File.file?(path)
  end
end

module DMT7
  class CLI < ThorBase
    def initialize(...)
      super(...)

      config_file = options.fetch(:config, DMT7::CONFIG_FILE)
      puts "Loading settings from #{config_file}"

      Config.load_and_set_settings(config_file)
      Opt.merge!(**options)

      set_verbosity
      Opt.debug = ENV.key?("DEBUG") || Opt.verbosity >= 3

      logger.debug ["DEBUG MODE ENABLED", "CONFIG_FILE: #{config_file}", "OPTIONS", Opt, ""]
    end

    class_option :config,
                 type: :string,
                 desc: "Specify an alternative config file. Default is \"#{CONFIG_FILE.basename}\""

    desc "xml SUBCOMMAND ...ARGS", "XML related commands"
    subcommand "xml", SubCommands::Xml

    desc "version SUBCOMMAND ...ARGS", "Version related commands"
    subcommand "version", SubCommands::Version

    private

    def set_verbosity
      Opt.verbosity ||= 0

      # Set verbosity to the number of times -v is used
      if Opt.verbose.is_a?(Array)
        Opt.verbosity = Opt.verbose.all? ? Opt.verbose.size : 0
      end

      # Overide verbosity zero if dry_run is set
      Opt.verbosity = 1 if Opt.dry_run && Opt.verbosity.zero?

      # Overide verbosity if DEBUG is set
      Opt.verbosity = 5 if ENV.fetch("DEBUG", nil)
    end
  end
end
