# frozen_string_literal: true

# Purpose: Base class for all services. Provides a few convenience methods
module DMT7
  class ApplicationService
    attr_reader :data, :errors

    class ServiceFailure < StandardError; end

    # Initialize the service with any arguments
    def initialize(...)
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

    # Convenience method for returning a success object
    def success(value = nil)
      @errors = []
      @data = value unless value.nil?

      self
    end

    # Convenience method for returning a failure object
    def failure(error = nil)
      @errors << error unless error.nil?
      @data = nil

      self
    end
  end
end
