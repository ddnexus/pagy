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

      BACKEND_METHODS = { pagy_headers:             PAGY_PATH.join('backend/helpers/headers'),
                          pagy_headers_merge:       PAGY_PATH.join('backend/helpers/headers'),
                          pagy_data:                PAGY_PATH.join('backend/helpers/data'),
                          pagy_links:               PAGY_PATH.join('backend/helpers/links'),
                          pagy_arel:                PAGY_PATH.join('backend/pagynators/arel'),
                          pagy_array:               PAGY_PATH.join('backend/pagynators/array'),
                          pagy_calendar:            PAGY_PATH.join('backend/pagynators/calendar'),
                          pagy_countless:           PAGY_PATH.join('backend/pagynators/countless'),
                          pagy_keynav_js:           PAGY_PATH.join('backend/pagynators/keynav'),
                          pagy_keyset:              PAGY_PATH.join('backend/pagynators/keyset'),
                          pagy_keyset_first_url:    PAGY_PATH.join('backend/pagynators/keyset'),
                          pagy_keyset_next_url:     PAGY_PATH.join('backend/pagynators/keyset'),
                          pagy_offset:              PAGY_PATH.join('backend/pagynators/offset'),
                          pagy_elasticsearch_rails: PAGY_PATH.join('backend/pagynators/searches/elasticsearch_rails'),
                          pagy_meilisearch:         PAGY_PATH.join('backend/pagynators/searches/meilisearch'),
                          pagy_searchkick:          PAGY_PATH.join('backend/pagynators/searches/searchkick') }.freeze

      BACKEND_METHODS.each_key do |method|
        class_eval "alias #{method} pagy_load_backend", __FILE__, __LINE__  # alias pagy_* pagy_load_backend
      end
    end
  end
end
