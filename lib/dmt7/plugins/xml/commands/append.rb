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

            logger.info ["Appending to #{@xpath}... ", @node.children.to_xml]

            @xml.at(@xpath).add_child(@node.children)

            success
          rescue StandardError => e
            failure(e.message)
          end
        end
      end
    end
  end
end
