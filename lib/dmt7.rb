# frozen_string_literal: true

require "config"

require_relative "dmt7/logging"

module DMT7
  include Logging

  AUTHOR = "Donovan C. Young"
  PROGRAM_NAME = "dmt7"
  VERSION = "0.1.0"
  CONFIG_FILE = Pathname.new(File.join(Dir.pwd, ".dmt7.yml"))

  class DMT7error < StandardError; end

  def self.run!
    init
    DMT7::CLI.start(ARGV)
  rescue StandardError => e
    Logging.print_error(e)
    exit 1
  end

  def self.init
    Config.setup do |config|
      config.const_name = "Opt"
    end
  end
end

require_relative "dmt7/cli"
