# frozen_string_literal: true

class Pagy
  module Backend
    module Loader
      private

      def pagy_load_backend(...)
        method_sym = __callee__
        require BACKEND_METHODS[method_sym]
        send(method_sym, ...)
      end

      path = ROOT.join('lib/pagy/backend').freeze
      BACKEND_METHODS = { pagy_arel:                path.join('constructors/arel'),
                          pagy_array:               path.join('constructors/array'),
                          pagy_calendar:            path.join('constructors/calendar'),
                          pagy_countless:           path.join('constructors/countless'),
                          pagy_keynav_js:           path.join('constructors/keynav'),
                          pagy_keyset:              path.join('constructors/keyset'),
                          pagy_keyset_first_url:    path.join('constructors/keyset'),
                          pagy_keyset_next_url:     path.join('constructors/keyset'),
                          pagy_offset:              path.join('constructors/offset'),
                          pagy_headers:             path.join('helpers/headers'),
                          pagy_headers_merge:       path.join('helpers/headers'),
                          pagy_links:               path.join('helpers/links'),
                          pagy_metadata:            path.join('helpers/metadata'),
                          pagy_elasticsearch_rails: path.join('searches/elasticsearch_rails'),
                          pagy_meilisearch:         path.join('searches/meilisearch'),
                          pagy_searchkick:          path.join('searches/searchkick') }.freeze

      BACKEND_METHODS.each_key do |method|
        class_eval "alias #{method} pagy_load_backend", __FILE__, __LINE__  # alias pagy_* pagy_load_backend
      end
    end
  end
end
