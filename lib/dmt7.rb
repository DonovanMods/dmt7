# frozen_string_literal: true

require "yaml"

require_relative "dmt7/cli"
require_relative "dmt7/logging"

module DMT7
  include Logging

  PROGRAM_NAME = "dmt7"
  VERSION = "0.1.0"
  AUTHOR = "Donovan C. Young"

  class DMT7error < StandardError; end

  def self.run!
    init
    DMT7::CLI.start(ARGV)
  rescue StandardError => e
    Logging.print_error(e)
    exit 1
  end

  def self.init
    true
  end
end
