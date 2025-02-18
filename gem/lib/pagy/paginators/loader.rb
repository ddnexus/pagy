# frozen_string_literal: true

class Pagy
  module Paginators
    module Loader
      paginators = { pagy_array:               'array',
                     pagy_calendar:            'calendar',
                     pagy_countless:           'countless',
                     pagy_keynav_js:           'keynav',
                     pagy_keyset:              'keyset',
                     pagy_offset:              'offset',
                     pagy_elasticsearch_rails: 'searches/elasticsearch_rails',
                     pagy_meilisearch:         'searches/meilisearch',
                     pagy_searchkick:          'searches/searchkick' }.freeze

      private

      define_method :pagy_load_paginators do |*args, **kwargs|
        method_sym = __callee__
        require_relative paginators[method_sym]
        self.class.send(:protected, method_sym)
        send(method_sym, *args, **kwargs)
      end

      paginators.each_key do |method|
        class_eval "alias #{method} pagy_load_paginators", __FILE__, __LINE__  # alias pagy_* pagy_load_paginators
      end
    end
  end
end
