# frozen_string_literal: true

require "colorize"

require_relative "dmt7/cli"

# require_relative "dmt7/plugins/version"
# require_relative "dmt7/plugins/xml/validate"

module DMT7
  PROGRAM_NAME = "dmt7"
  VERSION = "0.1.0"
  AUTHOR = "Donovan C. Young"

  class DMT7error < StandardError; end

  def self.print_error(message)
    puts "\nWhoops! Something went wrong!".colorize(color: :yellow, mode: :bold)
    puts "\n#{message}\n".colorize(color: :red, mode: :bold)
  end

  def self.run!
    DMT7::CLI.start(ARGV)
  rescue StandardError => e
    DMT7.print_error(e.message)
    puts "Backtrace:\n\n#{e.backtrace.join("\n")}" if ENV.fetch("DEBUG", false)
    exit 1
  end
end
