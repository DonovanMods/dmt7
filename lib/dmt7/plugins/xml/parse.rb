# frozen_string_literal: true

require "tmpdir"

module DMT7
  module Plugins
    module XML
      class Parse < ApplicationService
        attr_reader :files, :path, :xml

        ROOT_NODE = "root"

        def initialize(path, **options)
          @files = {}
          @path = path
          @verbosity = options.fetch(:verbosity, 0)
          @dry_run = options.fetch(:dry_run, false)
          @xml = Nokogiri::XML("<#{ROOT_NODE}/>", &:noblanks)

          super
        end

        def write_xmls(keys = element_names)
          puts "Dry Run enabled -- no files will be created." if @dry_run && @verbosity

          tmp_dir = @dry_run ? "tmp/dry-run" : Dir.mktmpdir(nil, "tmp")

          files.each do |filename, elements|
            elements.each do |element|
              write(File.join(tmp_dir, filename), xml.at(element)) if keys.include?(element)
            end
          end
        end

        def element_names(node = nil)
          node = xml.at(ROOT_NODE) if node.nil?
          node.element_children.map(&:name).uniq.sort
        end

        def call
          success(load)
        rescue StandardError => e
          failure(e.message)
        end

        def respond_to_missing?(method)
          xml.at(ROOT_NODE).respond_to?(method) || super
        end

        def method_missing(method, *, &)
          if xml.at(ROOT_NODE).respond_to?(method)
            xml.at(ROOT_NODE).send(method, *, &)
          else
            super
          end
        end

        private

        def load
          Dir.chdir(ckpath(path)) do
            Dir["**/**.xml"].each do |config_file|
              node = mknode(config_file)
              @files[config_file] = element_names(node)
              @xml.at(ROOT_NODE).add_child(node.children)
            end
          end
        end

        def ckpath(path)
          path = File.join(path, "Config") unless File.basename(path) =~ /config/i
          raise DMT7error, "Invalid directory #{path}" unless File.directory?(path) && File.readable?(path)

          path
        end

        def mknode(file)
          raise DMT7error, "Invalid file #{file}" unless File.file?(file) && File.readable?(file)

          Nokogiri::XML(File.read(file))
        end

        def write(file, node)
          puts "writing #{file}" if @verbosity > 1
          File.open(file, "w") { |f| node.write_xml_to(f, encoding: "UTF-8", indent: 4) } unless @dry_run
        end
      end
    end
  end
end
