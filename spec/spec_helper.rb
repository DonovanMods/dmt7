# frozen_string_literal: true

require "config"
require "dmt7"

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end

Config.setup do |config|
  config.const_name = "Opt"
end
Config.load_and_set_settings(File.join(Dir.pwd, "spec", "fixtures", "testopts.yml"))

Logger = DMT7::Logging.logger(stream: nil)
