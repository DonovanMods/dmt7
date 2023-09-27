# frozen_string_literal: true

module DMT7
  class ThorBase < Thor
    include Thor::Actions

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

    no_commands do
      def options
        original_options = super
        config_options = YAML.load_file(original_options.fetch(:config, DMT7::CONFIG_FILE))

        config_options["verbosity"] = 0
        if original_options[:verbose].is_a?(Array)
          config_options["verbosity"] = original_options[:verbose].all? ? original_options[:verbose].size : 0
        end
        # Overide verbosity if DEBUG is set
        config_options["verbosity"] = 5 if ENV.fetch("DEBUG", nil)

        original_options.merge(config_options)
      end

      def version_string
        puts "#{DMT7::PROGRAM_NAME.upcase.colorize(:bold)} " +
             "v#{DMT7::VERSION} ".colorize(:green) +
             "by #{DMT7::AUTHOR}".colorize(:blue)
      end
    end
  end
end
