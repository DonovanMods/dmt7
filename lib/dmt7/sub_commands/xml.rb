# frozen_string_literal: true

require "thor"
require_relative "../plugins/xml/validate"

module DMT7
  module SubCommands
    class Xml < ThorBase
      desc "dump MODLET_PATH", "Dumps the modified XMLs from MODLET_PATH"
      long_desc <<-LONGDESC
        `xml dump MODLET_PATH` will attempt to dump the modified XMLs from MODLET_PATH.\n
      LONGDESC
      option :files,
             type: :array,
             repeatable: true,
             desc: "The specific files to dump -- default is all files in the modlet"
      def dump(modlet_path)
        # TODO: This should apply the modlet and print the modified game_configs
        # puts game_configs.element_names
        if game_configs.failure?
          print_errors
          exit 1
        end
        # game_configs.files.map { |k, v| puts "#{k} -> #{v}" }
        game_configs.write_xmls(%w[items recipes])
      end

      desc "validate MODLET_PATH", "Validates the XMLs in MODLET_PATH"
      long_desc <<-LONGDESC
        `xml validate MODLET_PATH` will attempt to validate the XMLs in MODLET_PATH.\n
      LONGDESC
      def validate(modlet_path)
        validate = Plugins::XML::Validate.call(modlet_path:, game_configs:, options:)

        # puts "Items:\n#{game_configs.xpath("//items/item[@name='resourceWood']")}"
        # puts "Modlet XML:\n#{validate.modlet_configs.to_xml(indent: 4)}"

        print_errors validate.errors unless validate.valid?
        exit validate.valid? ? 0 : 1
      end

      no_commands do
        def game_configs
          @game_configs ||= Plugins::XML::Parse.new(options.fetch(:game_config_path), **options)
        end
      end
    end
  end
end
