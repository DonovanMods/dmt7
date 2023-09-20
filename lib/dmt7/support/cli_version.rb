# frozen_string_literal: true

require "thor"

module DMT7
  class CLIversion < Thor
    class_option :verbose,
                 type: :boolean,
                 aliases: "-v",
                 desc: "Prints more verbose output"
    class_option :dry_run,
                 type: :boolean,
                 desc: "Won't actually perform any destructive operations (e.g. writing to files)"

    desc "bump MODLET_PATH", "Bumps the version included in the MODLET_PATH/ModInfo.xml file"
    long_desc <<-LONGDESC
      `dmt7 version bump MODLET_PATH` will bump the version included in the MODLET_PATH/ModInfo.xml file.\n
      If no version options are provided, the patch version will be bumped by default.
    LONGDESC
    option :major, type: :numeric, aliases: "-M", desc: "Specify the major version"
    option :minor, type: :numeric, aliases: "-m", desc: "Specify the minor version"
    option :patch, type: :numeric, aliases: "-p", desc: "Specify the patch version"
    def bump(modlet_path)
      Plugins::Version.new(modlet_path, options).bump.save
    end
  end
end
