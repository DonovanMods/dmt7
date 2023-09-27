# frozen_string_literal: true

require "thor"
require "yaml"
# require_relative "support/thor_base"

# Require all files
base_dir = %w[lib dmt7]
%w[support plugins sub_commands].each do |dir|
  Dir[File.join(base_dir, dir, "**", "**")].each do |path|
    require_relative File.join(path.split("/") - base_dir) if File.file?(path)
  end
end

module DMT7
  CONFIG_FILE = Pathname.new(File.join(Dir.pwd, ".dmt7.yml"))

  class CLI < ThorBase
    def self.exit_on_failure?
      true
    end

    class_option :config,
                 type: :string,
                 desc: "Specify an alternative config file. Default is \"#{DMT7::CONFIG_FILE.basename}\""

    desc "xml SUBCOMMAND ...ARGS", "XML related commands"
    subcommand "xml", SubCommands::Xml

    desc "version SUBCOMMAND ...ARGS", "Version related commands"
    subcommand "version", SubCommands::Version
  end
end
