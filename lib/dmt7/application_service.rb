# frozen_string_literal: true

# Purpose: Base class for all services. Provides a few convenience methods
module DMT7
  class ApplicationService
    include Logging

    class ServiceFailure < StandardError; end

    attr_reader :data, :errors

    # Initialize the service with any arguments
    def initialize
      @data = nil
      @errors = []
    end

    # Convenience method for calling the service
    def self.call(...)
      new(...).call
    end

    def call
      raise NotImplementedError
    end

    # Returns true if the service was successful
    def success?
      @errors.empty?
    end

    # Inverse of success?
    def failure?
      !success?
    end

    private

    def result(message = nil, data: nil, errors: [], level: :warn)
      logger.send(level, message) unless message.nil?

      @data = data unless data.nil?
      @errors = errors unless errors.empty?

      self
    end

    # Convenience method for returning a success object
    def success(message = nil, **)
      result(message, **)
    end

    # Convenience method for returning a failure object
    def failure(message, errors: [], **)
      @errors << message unless errors.any?

      result(message, errors:, level: :error, **)
    end
  end
end
