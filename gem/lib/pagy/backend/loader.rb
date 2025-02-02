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
                          pagy_arel:                'pagynators/arel',
                          pagy_array:               'pagynators/array',
                          pagy_calendar:            'pagynators/calendar',
                          pagy_countless:           'pagynators/countless',
                          pagy_keynav_js:           'pagynators/keynav',
                          pagy_keyset:              'pagynators/keyset',
                          pagy_keyset_first_url:    'pagynators/keyset',
                          pagy_keyset_next_url:     'pagynators/keyset',
                          pagy_offset:              'pagynators/offset',
                          pagy_elasticsearch_rails: 'pagynators/searches/elasticsearch_rails',
                          pagy_meilisearch:         'pagynators/searches/meilisearch',
                          pagy_searchkick:          'pagynators/searches/searchkick' }.freeze

      BACKEND_METHODS.each_key do |method|
        class_eval "alias #{method} pagy_load_backend", __FILE__, __LINE__  # alias pagy_* pagy_load_backend
      end
    end
  end
end
