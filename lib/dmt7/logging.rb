# frozen_string_literal: true

require "logger"
require "awesome_print"

module DMT7
  module Logging
    LEVELS = %i[error warn info debug].freeze
    SEVERITY_COLOR = {
      unknown: :white,
      fatal: :purpleish,
      error: :red,
      warn: :yellowish,
      info: :cyanish,
      debug: :blueish
    }.freeze

    Formatter = proc do |severity, _datetime, _progname, msg|
      color = SEVERITY_COLOR[severity.downcase.to_sym]
      "#{[msg].flatten.map { |m| m.is_a?(String) ? m.send(color) : "#{m.class.ai}\n#{m.ai}" }.join("\n")}\n"
    end

    def self.level
      Opt.level || :error
    end

    def logger(...)
      Logging.logger(...)
    end

    def print_error
      Logging.print_error
    end

    def self.print_error(error)
      logger.warn "Whoops! Something went wrong!\n".yellow
      logger.error "#{error.message[0...256]}\n"
      logger.fatal "#{error.backtrace.join("\n")[0...2048]}\n"
    end

    def self.logger(stream: $stdout)
      @logger ||= Logger.new(stream, level:, formatter: Formatter, progname: DMT7::PROGRAM_NAME)
    end
  end
end
