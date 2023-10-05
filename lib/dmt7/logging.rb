# frozen_string_literal: true

require "logger"
require "awesome_print"

module DMT7
  module Logging
    SEVERITY_COLOR = {
      unknown: :white,
      fatal: :purpleish,
      error: :red,
      warn: :yellowish,
      info: :cyanish,
      debug: :blueish
    }.freeze

    Formatter = proc do |severity, _datetime, _progname, msg|
      #  "#{datetime.strftime("%F %T")} #{severity.red}: #{msg}\n"
      # "#{severity.red}: #{msg}\n"
      color = SEVERITY_COLOR[severity.downcase.to_sym]

      "#{[msg].flatten.map { |m| m.is_a?(String) ? m.send(color) : "#{m.class.ai}\n#{m.ai}" }.join("\n")}\n"
    end

    def self.level
      return :debug if ENV.fetch("DEBUG", nil)


      verbosity = [0, options.fetch(:verbosity, 1).to_i - 1].max

      %i[error warn info][[2, verbosity].min]
    end

    def logger
      Logging.logger
    end

    def print_error
      Logging.print_error
    end

    def self.print_error(error)
      logger.warn "Whoops! Something went wrong!\n".yellow
      logger.error "#{error.message[0...256]}\n"
      logger.fatal "#{error.backtrace.join("\n")[0...2048]}\n"
    end

    def self.logger
      @logger ||= Logger.new($stdout, level:, formatter: Formatter)
    end
  end
end
