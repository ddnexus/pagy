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
      BACKEND_METHODS = { pagy_headers:             path.join('helpers/headers'),
                          pagy_headers_merge:       path.join('helpers/headers'),
                          pagy_metadata:            path.join('helpers/metadata'),
                          pagy_links:               path.join('helpers/links'),
                          pagy_arel:                path.join('paginators/arel'),
                          pagy_array:               path.join('paginators/array'),
                          pagy_calendar:            path.join('paginators/calendar'),
                          pagy_countless:           path.join('paginators/countless'),
                          pagy_keynav_js:           path.join('paginators/keynav'),
                          pagy_keyset:              path.join('paginators/keyset'),
                          pagy_keyset_first_url:    path.join('paginators/keyset'),
                          pagy_keyset_next_url:     path.join('paginators/keyset'),
                          pagy_offset:              path.join('paginators/offset'),
                          pagy_elasticsearch_rails: path.join('paginators/searches/elasticsearch_rails'),
                          pagy_meilisearch:         path.join('paginators/searches/meilisearch'),
                          pagy_searchkick:          path.join('paginators/searches/searchkick') }.freeze

      BACKEND_METHODS.each_key do |method|
        class_eval "alias #{method} pagy_load_backend", __FILE__, __LINE__  # alias pagy_* pagy_load_backend
      end
    end
  end
end
