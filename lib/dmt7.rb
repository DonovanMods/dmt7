# frozen_string_literal: true

require "colorize"

require_relative "dmt7/plugins/version"
require_relative "dmt7/cli"

module DMT7
  PROGRAM_NAME = "dmt7"
  VERSION = "0.1.0"

  class DMT7error < StandardError; end

  def self.print_error(message)
    puts "Whoops! Something went wrong!".colorize(color: :yellow, mode: :bold)
    puts "\n#{message}\n".colorize(color: :red, mode: :bold)
  end
end
