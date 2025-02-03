# frozen_string_literal: true

class Pagy
  module Backend
    module Loader
      private

      def pagy_load_backend(...)
        method_sym = __callee__
        require_relative BACKEND_METHODS[method_sym]
        send(method_sym, ...)
      end

      BACKEND_METHODS = { pagy_headers:             'helpers/headers',
                          pagy_headers_merge:       'helpers/headers',
                          pagy_data:                'helpers/data',
                          pagy_links:               'helpers/links',
                          pagy_arel:                'paginators/arel',
                          pagy_array:               'paginators/array',
                          pagy_calendar:            'paginators/calendar',
                          pagy_countless:           'paginators/countless',
                          pagy_keynav_js:           'paginators/keynav',
                          pagy_keyset:              'paginators/keyset',
                          pagy_keyset_first_url:    'paginators/keyset',
                          pagy_keyset_next_url:     'paginators/keyset',
                          pagy_offset:              'paginators/offset',
                          pagy_elasticsearch_rails: 'paginators/searches/elasticsearch_rails',
                          pagy_meilisearch:         'paginators/searches/meilisearch',
                          pagy_searchkick:          'paginators/searches/searchkick' }.freeze

      BACKEND_METHODS.each_key do |method|
        class_eval "alias #{method} pagy_load_backend", __FILE__, __LINE__  # alias pagy_* pagy_load_backend
      end
    end
  end
end
