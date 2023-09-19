# frozen_string_literal: true

module DMT
  module Plugins
    class Version
      attr_accessor :major, :minor, :patch

      def initialize(versions, options = {})
        @major, @minor, @patch = versions.split(".").map(&:to_i)
        @options = options
      end

      def bump
        return [@options.major, @options.minor || 0, @options.patch || 0] if @options.major
        return [@major, @options.minor, @options.patch || 0] if @options.minor
        return [@major, @minor, @options.patch] if @options.patch

        [@major, @minor, @patch + 1]
      end

      def to_s
        bump.join(".")
      end
    end
  end
end
