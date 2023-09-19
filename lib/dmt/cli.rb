# frozen_string_literal: true

require "thor"

module DMT
  class CLI < Thor
    class_option :verbose, type: :boolean, aliases: "-v"
    class_option :debug,   type: :boolean

    map %w[--version -V] => :__version
    desc "--version, -V", "Prints the version of DMT"
    def __version
      puts "#{DMT::PROGRAM_NAME} v#{DMT::VERSION}"
    end

    def self.exit_on_failure?
      true
    end

    desc "bump MODLET_PATH", "Bumps the version included in the MODLET_PATH/ModInfo.xml file"
    option :major, type: :numeric, aliases: "-M"
    option :minor, type: :numeric, aliases: "-m"
    option :patch, type: :numeric, aliases: "-p"
    option :dry_run, type: :boolean, aliases: "-d"
    def bump(modlet_path)
      Plugins::Version.new(modlet_path, options).bump
    end
  end
end
