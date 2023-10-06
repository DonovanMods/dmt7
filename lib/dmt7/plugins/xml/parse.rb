# frozen_string_literal: true

require "tmpdir"

module DMT7
  module Plugins
    module XML
      class Parse
        include Logging

        attr_reader :errors, :files, :path, :xml

        ROOT_NODE = "root"

        def initialize(path)
          @errors = []
          @files = {}
          @path = path

          @xml = Nokogiri::XML("<#{ROOT_NODE}/>", &:noblanks)
          @xml.encoding = "UTF-8"
          @xml.remove_namespaces!

          load
        end

        def success?
          @errors.empty?
        end

        def failure?
          !success?
        end

        def apply(modlet)
          raise DMT7error, "Invalid modlet #{modlet}" unless modlet.is_a?(DMT7::Plugins::XML::Parse)

          modlet.element_children.children.each do |node|
            next unless node.type == Nokogiri::XML::Node::ELEMENT_NODE

            result = invoke_command(node)
            @errors += result.errors if result&.failure?
          end

          self
        end

        def element_names(node = nil)
          node = xml.at(ROOT_NODE) if node.nil?
          node.element_children.map(&:name).uniq.sort
        end

        def write_xmls(keys = element_names)
          logger.info "Dry Run enabled -- no files will be created." if Opt.dry_run

          tmp_dir = Opt.dry_run ? "tmp/dry-run" : Dir.mktmpdir(nil, "tmp")

          files.each do |filename, elements|
            elements.each do |element|
              write(File.join(tmp_dir, filename), xml.at(element)) if keys.include?(element)
            end
          end
        end

        def respond_to_missing?(method, respond_to_private = false)
          xml.at(ROOT_NODE).respond_to?(method) || super
        end

        def method_missing(method, *, &)
          if xml.at(ROOT_NODE).respond_to?(method)
            xml.at(ROOT_NODE).send(method, *, &)
          else
            @errors << "Invalid method #{method}"
            super
          end
        end

        private

        def load
          Dir.chdir(ck_path(path)) do
            Dir["**/**.xml"].each do |config_file|
              node = mknode(config_file)
              @files[config_file] = element_names(node)
              @xml.at(ROOT_NODE) << node.children
            end
          end
        rescue StandardError => e
          @errors << e.message
        end

        def invoke_command(node)
          case node.name
          when "append"
            Commands::Append.call(node, @xml)
          when /(csv|set)/
            ApplicationService.new
          else
            @errors << "COMMAND_NOT_IMPLEMENTED: #{node.name}"
            nil
          end
        end

        def ck_path(path)
          path = File.join(path, "Config") unless File.basename(path) =~ /config/i
          raise DMT7error, "Invalid directory #{path}" unless File.directory?(path) && File.readable?(path)

          path
        end

        def mknode(file)
          raise DMT7error, "Invalid file #{file}" unless File.file?(file) && File.readable?(file)

          Nokogiri::XML.parse(File.read(file))
        end

        def write(file, node)
          puts.debug "writing #{file}"
          File.open(file, "w") { |f| node&.write_xml_to(f, encoding: "UTF-8", indent: 4) } unless Opt.dry_run
        end
      end
    end
  end
end
