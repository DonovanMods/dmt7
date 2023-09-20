# frozen_string_literal: true

require "colorize"

require_relative "dmt/plugins/version"
require_relative "dmt/cli"

module DMT
  PROGRAM_NAME = "dmt"
  VERSION = "0.1.0"

  class DMTerror < StandardError; end

  def self.print_error(message)
    puts "Whoops! Something went wrong!".colorize(color: :yellow, mode: :bold)
    puts "\n#{message}\n".colorize(color: :red, mode: :bold)
  end
end
