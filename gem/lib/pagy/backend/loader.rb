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
      BACKEND_METHODS = { pagy_arel:                path.join('arel'),
                          pagy_array:               path.join('array'),
                          pagy_calendar:            path.join('calendar'),
                          pagy_countless:           path.join('countless'),
                          pagy_headers:             path.join('headers'),
                          pagy_headers_merge:       path.join('headers'),
                          pagy_keynav_js:           path.join('keynav'),
                          pagy_keyset:              path.join('keyset'),
                          pagy_keyset_first_url:    path.join('keyset'),
                          pagy_keyset_next_url:     path.join('keyset'),
                          pagy_links:               path.join('links'),
                          pagy_metadata:            path.join('metadata'),
                          pagy_offset:              path.join('offset'),
                          pagy_elasticsearch_rails: path.join('search/elasticsearch_rails'),
                          pagy_meilisearch:         path.join('search/meilisearch'),
                          pagy_searchkick:          path.join('search/searchkick') }.freeze

      BACKEND_METHODS.each_key do |method|
        class_eval "alias #{method} pagy_load_backend", __FILE__, __LINE__  # alias pagy_* pagy_load_backend
      end
    end
  end
end
