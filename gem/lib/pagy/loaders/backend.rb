# frozen_string_literal: true

class Pagy
  module Loaders
    module Backend
      def pagy_load_backend(...)
        method_sym = __callee__
        require BACKEND_METHOD_MIXINS[method_sym]
        send(method_sym, ...)
      end

      BACKEND_METHOD_MIXINS = { pagy_arel:                PAGY_PATH.join('mixins/arel').to_s,
                                pagy_array:               PAGY_PATH.join('mixins/array').to_s,
                                pagy_calendar:            PAGY_PATH.join('mixins/calendar').to_s,
                                pagy_countless:           PAGY_PATH.join('mixins/countless').to_s,
                                pagy_elasticsearch_rails: PAGY_PATH.join('mixins/elasticsearch_rails').to_s,
                                pagy_headers:             PAGY_PATH.join('mixins/headers').to_s,
                                pagy_headers_merge:       PAGY_PATH.join('mixins/headers').to_s,
                                pagy_keyset:              PAGY_PATH.join('mixins/keyset').to_s,
                                pagy_keyset_first_url:    PAGY_PATH.join('mixins/keyset').to_s,
                                pagy_keyset_next_url:     PAGY_PATH.join('mixins/keyset').to_s,
                                pagy_keyset_augmented_js: PAGY_PATH.join('mixins/keyset_augmented').to_s,
                                pagy_meilisearch:         PAGY_PATH.join('mixins/meilisearch').to_s,
                                pagy_metadata:            PAGY_PATH.join('mixins/metadata').to_s,
                                pagy_offset:              PAGY_PATH.join('mixins/offset').to_s,
                                pagy_searchkick:          PAGY_PATH.join('mixins/searchkick').to_s }.freeze

      BACKEND_METHOD_MIXINS.each_key do |method|
        class_eval "alias #{method} pagy_load_backend", __FILE__, __LINE__  # alias pagy_* pagy_load_backend
      end
    end
  end
end
