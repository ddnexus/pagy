# frozen_string_literal: true

require 'json'
require_relative '../../b64'

# Relegate internal functions. Make overriding navs easier.
class Pagy
  private

  # Compose the data-pagy attribute, with the base64 encoded JSON-serialized args. Use the faster oj gem if defined.
  def data_pagy_attribute(*args)
    data = defined?(Oj) ? Oj.dump(args, mode: :compat) : JSON.dump(args)
    %(data-pagy="#{B64.encode(data)}")
  end
end
