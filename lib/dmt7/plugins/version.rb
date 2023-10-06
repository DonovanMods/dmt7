# typed: true
# frozen_string_literal: true

require "english"

module DMT7
  module Plugins
    class Version
      include Logging

      attr_reader :major, :minor, :patch, :modinfo_data, :modinfo_file, :modlet_name, :modlet_path

      def self.call(...)
        new(...).bump.save
      end

      def initialize(modlet)
        @modlet_path = Pathname.new(modlet)
        @modlet_name = @modlet_path.basename
        @modinfo_file = File.join(@modlet_path, "ModInfo.xml")

        raise DMT7error, "#{@modinfo_file} does not exist, or we can't read it" unless File.readable?(@modinfo_file)

        @modinfo_data = File.read(@modinfo_file)
        read_version
      end

      def bump
        bump_major if key_set?(:major)
        bump_minor if key_set?(:minor)
        bump_patch if key_set?(:patch) || Opt.to_h.values_at(:major, :minor, :patch).compact.empty?

        @modinfo_data.gsub!(/version value=".*"/i, "Version value=\"#{self}\"") if version_changed?

        self
      end

      def to_a
        [major, minor, patch]
      end

      def to_s
        to_a.join(".")
      end

      def save
        if Opt.dry_run
          logger.info "Dry run, not saving #{@modlet_name}"
          return
        end

        unless version_changed?
          logger.info "No version change for #{@modlet_name}"
          return
        end

        Logger.info "Bumping #{@modlet_name} #{@original_version} -> #{self}"

        File.write(@modinfo_file, @modinfo_data)
      end

      private

      def key_set?(key)
        Opt.key?(key) && !Opt[key].nil?
      end

      def read_version
        @modinfo_data.match(/<version value="(.*)"\s+/i)
        raise DMT7error, "Version not found in ModInfo.xml" unless $LAST_MATCH_INFO

        @original_version = $LAST_MATCH_INFO[1]
        @major, @minor, @patch = $LAST_MATCH_INFO[1].split(".").map(&:to_i)
      end

      def bump_major
        @major = (Opt.major || (@major + 1))
        @minor = (Opt.minor || 0)
        @patch = (Opt.patch || 0)
      end

      def bump_minor
        @minor = (Opt.minor || (@minor + 1))
        @patch = (Opt.patch || 0)
      end

      def bump_patch
        @patch = (Opt.patch || (@patch + 1))
      end

      def version_changed?
        to_s != @original_version
      end
    end
  end
end
