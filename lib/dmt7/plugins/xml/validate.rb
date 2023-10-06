# frozen_string_literal: true

require "nokogiri"

module DMT7
  module Plugins
    module XML
      class Validate < ApplicationService
        include ApplicationHelpers

        attr_reader :errors, :modlet_configs

        def initialize(modlet_path:, game_configs:)
          super()

          @modlet_path = Pathname.new(modlet_path)
          @modlet_name = @modlet_path.basename
          @game_configs = game_configs
          @modlet_configs = load_modlet
        end

        def call
          # TODO: Validate XML
          result = @game_configs.apply(@modlet_configs)

          if result.success?
            logger.warn "XMLs for #{@modlet_name} are valid"
          else
            logger.error "XMLs for #{@modlet_name} are NOT valid"
            @errors += result.errors
          end

          self
        end

        def valid?
          @errors.empty?
        end

        private

        def load_modlet
          raise DMT7error, "Invalid Directory #{@modlet_path}" unless @modlet_path.directory? && @modlet_path.readable?

          logger.info "Validating XMLs in #{truncate_path(@modlet_path)}"

          result = XML::Parse.new(@modlet_path)
          raise DMT7error, result.errors.join("\n") unless result.success?

          result
        end
      end
    end
  end
end
