# frozen_string_literal: true

require_relative 'b64'
require 'json'

class Pagy
  # Additions for the Frontend
  module DataHelpers
    # Return a data tag with the base64 encoded JSON-serialized args generated with the faster oj gem
    def pagy_data(_pagy, *args)
      data = defined?(::Oj) ? Oj.dump(args, mode: :strict) : JSON.dump(args)
      %(data-pagy="#{B64.encode(data)}")
    end
  end
end
