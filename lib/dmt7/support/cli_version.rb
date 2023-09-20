# frozen_string_literal: true

require "thor"

module DMT7
  class CLIversion < Thor
    class_option :verbose, type: :boolean, aliases: "-v"
    class_option :dry_run, type: :boolean

    desc "bump MODLET_PATH", "Bumps the version included in the MODLET_PATH/ModInfo.xml file"
    option :major, type: :numeric, aliases: "-M"
    option :minor, type: :numeric, aliases: "-m"
    option :patch, type: :numeric, aliases: "-p"
    def bump(modlet_path)
      Plugins::Version.new(modlet_path, options).bump.save
    rescue DMT7error => e
      DMT7.print_error(e.message)
      exit 1
    end
  end
end
