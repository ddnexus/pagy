# frozen_string_literal: true

class Pagy
  # Additions for the Frontend
  module DataHelpers
    if defined?(::Oj)
      # Return a data tag with the base64 encoded JSON-serialized args generated with the faster oj gem
      def pagy_data(_pagy, kind, *args)
        %(data-pagy="#{B64.encode(Oj.dump([kind] + args, mode: :strict))}") unless args.empty?
      end
    else
      require 'json'
      # Return a data tag with the base64 encoded JSON-serialized args generated with the slower to_json
      def pagy_data(_pagy, kind, *args)
        %(data-pagy="#{B64.encode(([kind] + args).to_json)}") unless args.empty?
      end
    end
  end
end
