# frozen_string_literal: true

class Pagy
  class Loaders
    module Offset
      def pagy_load_offset(...)
        method_sym = __callee__
        require_relative OFFSET_METHOD_MIXINS[method_sym]
        send(method_sym, ...)
      end

      OFFSET_METHOD_MIXINS = { new_from_elasticsearch_rails: '../mixins/elasticsearch_rails',
                               new_from_meilisearch:         '../mixins/meilisearch',
                               new_from_searchkick:          '../mixins/searchkick' }.freeze

      OFFSET_METHOD_MIXINS.each_key do |method|
        class_eval "alias #{method} pagy_load_offset", __FILE__, __LINE__ # alias pagy_* pagy_load_offset
      end
    end
  end
end
