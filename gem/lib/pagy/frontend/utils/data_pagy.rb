# frozen_string_literal: true

require_relative '../../modules/b64'

class Pagy
  # Relegate internal functions. Make overriding navs easier.
  module DataPagy
    module_function

    # Compose the data-pagy attribute, with the base64 encoded JSON-serialized args. Use the faster oj gem if defined.
    def attr(*args)
      data = defined?(::Oj) ? Oj.dump(args, mode: :compat) : JSON.dump(args)
      %(data-pagy="#{B64.encode(data)}")
    end
  end
end
