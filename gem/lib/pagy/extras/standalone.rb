# See the Pagy documentation: https://ddnexus.github.io/pagy/docs/extras/standalone
# frozen_string_literal: true

require_relative '../url_helpers'

class Pagy # :nodoc:
  # Use pagy without any request object, nor Rack environment/gem, nor any defined params method,
  # even in the irb/rails console without any app or config.
  # Define a dummy params method if it's not already defined in the including module
  module Backend
    def self.included(controller)
      controller.define_method(:params) { {} } unless controller.method_defined?(:params)
    end
  end
end
