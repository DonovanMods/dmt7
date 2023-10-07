# frozen_string_literal: true

module DMT7
  module Plugins
    module XML
      module Commands
        class Append < ApplicationService
          include ApplicationHelpers

          def initialize(node, parent)
            super()

            @node = node
            @xpath = clean_xpath(node["xpath"])
            @parent = parent
          end

          def call
            raise DMT7error, "Invalid node #{@node}" unless @node.is_a?(Nokogiri::XML::Node)

            logger.info ["Appending to #{@xpath}... ", @node.children.to_xml]

            @parent.add_child(@node.children)
            raise "Failed to append XML to #{@xpath}" if @parent.errors.any?

            success
          rescue StandardError => e
            failure(e.message, errors: @parent.errors)
          end
        end
      end
    end
  end
end
