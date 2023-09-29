# frozen_string_literal: true

require "nokogiri"

module DMT7
  module Plugins
    module XML
      class Validate
        include ApplicationHelpers

        attr_reader :errors, :game_configs, :modlet_configs

        def initialize(modlet_path:, game_configs:, options: {})
          @errors = []
          @options = options
          @verbosity = options.fetch(:verbosity, 0)

          @game_configs = game_configs
          @modlet_configs = load_xml modlet_path

          validate
        end

        def validate
          # TODO: Validate XML
          true
        end

        def valid?
          @errors.empty?
        end

        private

        def load_xml(path)
          path = Pathname.new(path)
          raise DMT7error, "Invalid Directory #{path}" unless path.directory? && path.readable?

          puts "Loading XMLs from #{truncate_path(path)}" if @verbosity
          result = XML::Parse.call(path, **@options)
          raise DMT7error, result.errors.join("\n") unless result.success?

          result
        end
      end
    end
  end
end
