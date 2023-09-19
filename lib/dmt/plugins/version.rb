# typed: true
# frozen_string_literal: true

require "english"

module DMT
  module Plugins
    class Version
      attr_reader :major, :minor, :patch, :version, :modinfo_data, :modinfo_file

      def initialize(modlet_path, options)
        @options = options.transform_keys(&:to_sym)

        @modinfo_file = File.join(modlet_path, "ModInfo.xml")
        raise "ModInfo.xml not found in #{@modinfo_file}" unless File.exist?(@modinfo_file)

        @modinfo_data = File.read(@modinfo_file)
        read_version
      end

      def bump
        bump_major if @options[:major]
        bump_minor if @options[:minor]
        bump_patch if @options[:patch] || @options.values.compact.empty?

        @modinfo_data.gsub!(/version value=".*"/i, "Version value=\"#{self}\"")

        self
      end

      def to_a
        [major, minor, patch]
      end

      def to_s
        to_a.join(".")
      end

      def save
        return if @options[:dry_run]

        File.write(@modinfo_file, @modinfo_data)
      end

      private

      def read_version
        @modinfo_data.match(/<version value="(.*)"\s+/i)
        raise "Version not found in ModInfo.xml" unless $LAST_MATCH_INFO

        @major, @minor, @patch = $LAST_MATCH_INFO[1].split(".").map(&:to_i)
      end

      def bump_major
        @major = (@options[:major] || (@major + 1))
        @minor = (@options[:minor] || 0)
        @patch = (@options[:patch] || 0)
      end

      def bump_minor
        @minor = (@options[:minor] || (@minor + 1))
        @patch = (@options[:patch] || 0)
      end

      def bump_patch
        @patch = (@options[:patch] || (@patch + 1))
      end
    end
  end
end
