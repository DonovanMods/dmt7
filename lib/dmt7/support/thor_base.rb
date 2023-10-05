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

    no_commands do
      def options
        original_options = super.transform_keys(&:to_sym)
        config_options = load_config(original_options.fetch(:config, DMT7::CONFIG_FILE))
        config_options[:verbosity] = set_verbosity(config_options.fetch(:verbosity, 0), original_options)
        original_options.merge(config_options)
      end
    end

    private

    def load_config(file)
      raise DMT7::Error, "Config file #{file} not found" unless File.readable?(file)

      @load_config ||= YAML.load_file(file).transform_keys(&:to_sym)
    end

    def print_errors(errors = [])
      logger.error errors.flatten.compact.uniq.join("\n") if options[:verbosity]&.positive?
    end

    def set_verbosity(verbosity, options)
      if options.fetch(:verbose, nil).is_a?(Array)
        verbosity = options[:verbose].all? ? options[:verbose].size : 0
      end

      # Overide verbosity if dry_run is set
      verbosity = 1 if options[:dry_run] && verbosity.zero?

      # Overide verbosity if DEBUG is set
      verbosity = 5 if ENV.fetch("DEBUG", nil)

      verbosity
    end

    def version_string
      puts DMT7::PROGRAM_NAME.upcase.white +
           " v#{DMT7::VERSION} " +
           "by #{DMT7::AUTHOR}".cyanish
    end
  end
end
