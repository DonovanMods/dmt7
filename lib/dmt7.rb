# frozen_string_literal: true

require "config"

require_relative "dmt7/globals"
require_relative "dmt7/logging"
require_relative "dmt7/application_service"
require_relative "dmt7/cli"

module DMT7
  include Logging

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
    Config.load_and_set_settings("")
  end
end
