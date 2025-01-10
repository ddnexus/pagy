# frozen_string_literal: true

class Pagy
  class Loaders
    module Backend
      def pagy_load_backend(...)
        method_sym = __callee__
        require_relative BACKEND_METHOD_MIXINS[method_sym]
        send(method_sym, ...)
      end

      BACKEND_METHOD_MIXINS = { pagy_arel:                '../mixins/arel',
                                pagy_array:               '../mixins/array',
                                pagy_calendar:            '../mixins/calendar',
                                pagy_countless:           '../mixins/countless',
                                pagy_elasticsearch_rails: '../mixins/elasticsearch_rails',
                                pagy_headers:             '../mixins/headers',
                                pagy_headers_merge:       '../mixins/headers',
                                pagy_keyset:              '../mixins/keyset',
                                pagy_keyset_first_url:    '../mixins/keyset',
                                pagy_keyset_next_url:     '../mixins/keyset',
                                pagy_keyset_augmented_js: '../mixins/keyset_augmented',
                                pagy_limit_selector_js:   '../mixins/limit_selector',
                                pagy_meilisearch:         '../mixins/meilisearch',
                                pagy_metadata:            '../mixins/metadata',
                                pagy_offset:              '../mixins/offset',
                                pagy_searchkick:          '../mixins/searchkick' }.freeze

      BACKEND_METHOD_MIXINS.each_key do |method|
        class_eval "alias #{method} pagy_load_backend", __FILE__, __LINE__  # alias pagy_* pagy_load_backend
      end
    end
  end
end
