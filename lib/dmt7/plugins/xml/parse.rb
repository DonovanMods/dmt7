# frozen_string_literal: true

module DMT7
  module Plugins
    module XML
      class Parse < ApplicationService
        attr_reader :path, :xml

        ROOT_NODE = "configs"

        def initialize(path:, verbosity: 0)
          @path = path
          @verbosity = verbosity
          @xml = Nokogiri::XML("<#{ROOT_NODE}/>")

          super
        end

        def call
          success(load)
        rescue StandardError => e
          failure(e.message)
        end

        def respond_to_missing?(method)
          xml.respond_to?(method) || super
        end

        def method_missing(method, *, &)
          if xml.respond_to?(method)
            xml.send(method, *, &)
          else
            super
          end
        end

        private

        def load
          raise DMT7error, "Invalid path #{path}" unless File.directory?(path) && File.readable?(path)

          Dir.chdir(path) do
            Dir["**/**.xml"].each do |config_file|
              @xml.at(ROOT_NODE).add_child(File.read(config_file))
            end
          end
        end
      end
    end
  end
end
