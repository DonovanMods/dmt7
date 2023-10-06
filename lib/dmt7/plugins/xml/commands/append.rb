# frozen_string_literal: true

module DMT7
  module Plugins
    module XML
      module Commands
        class Append < ApplicationService
          include ApplicationHelpers

          def initialize(node, xml)
            super()

            @node = node
            @xpath = clean_xpath(node["xpath"])
            @xml = xml
          end

          def call
            raise DMT7error, "Invalid node #{@node}" unless @node.is_a?(Nokogiri::XML::Node)

            parent = @xml.at_xpath(@xpath)
            raise "Failed to find xpath #{@xpath}" if parent.nil?

            logger.info ["Appending to #{@xpath}... ", @node.children.to_xml]

            parent.add_child(@node.children)
            raise "Failed to append XML to #{@xpath}" if @xml.errors.any?

            success
          rescue StandardError => e
            failure(e.message, errors: @xml.errors)
          end
        end
      end
    end
  end
end
