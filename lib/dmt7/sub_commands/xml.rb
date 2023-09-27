# frozen_string_literal: true

require "thor"
require_relative "../plugins/xml/validate"

module DMT7
  module SubCommands
    class Xml < ThorBase
      desc "validate MODLET_PATH", "Validates the XMLs in MODLET_PATH"
      long_desc <<-LONGDESC
        xml validate MODLET_PATH` will attempt to validate the XMLs in MODLET_PATH.\n
      LONGDESC
      option :major, type: :numeric, aliases: "-M", desc: "Specify the major version"
      option :minor, type: :numeric, aliases: "-m", desc: "Specify the minor version"
      option :patch, type: :numeric, aliases: "-p", desc: "Specify the patch version"
      def validate(modlet_path)
        xml = Plugins::XML::Validate.new(modlet_path, options)
        exit 1 unless xml.valid?

        puts "Game:\n#{xml.game.xpath("//items/item[@name='resourceWood']")}"
        puts "Modlet:\n#{xml.modlet.xpath("//items/item[@name='resourceWood']")}"

        exit 0
      end
    end
  end
end
