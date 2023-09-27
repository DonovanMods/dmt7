# frozen_string_literal: true

require "nokogiri"

module DMT7
  module Plugins
    module XML
      class Validate
        include ApplicationHelpers

        attr_reader :errors, :game, :modlet

        def initialize(modlet, options = {})
          @errors = []
          @options = options
          @verbosity = options.fetch(:verbosity, 0)

          @game = load_xml options.fetch(:game_config_path)
          @modlet = load_xml File.join(modlet, "Config")

          validate
        end

        def validate
          # TODO: Validate XML
          true
        end

        def valid?
          # TODO: True or False depending on validation result
          @errors.empty?
        end

        private

        def load_xml(path)
          path = Pathname.new(path)
          raise DMT7error, "Invalid Directory #{path}" unless path.directory? && path.readable?

          puts "Loading XMLs from #{truncate_path(path)}" if @verbosity
          XML::Parse.call(path:, verbosity: @verbosity)
        end
      end
    end
  end
end
