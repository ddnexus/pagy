# frozen_string_literal: true

class Pagy
  class Offset
    # Paginate Meilisearch results
    class ElasticsearchRails < Offset
      DEFAULT[:elasticsearch_rails_search]      ||= :search
      DEFAULT[:elasticsearch_rails_pagy_search] ||= :pagy_search

      def self.new_from_elasticsearch_rails(response, **vars)
        vars[:limit] = response.search.options[:size] || 10
        vars[:page]  = ((response.search.options[:from] || 0) / vars[:limit]) + 1
        vars[:count] = total_count(response)
        Offset.new(**vars)
      end

      # Get the count from different version of ElasticsearchRails
      def self.total_count(response)
        total = if response.respond_to?(:raw_response)
                  response.raw_response['hits']['total']
                else
                  response.response['hits']['total']
                end
        total.is_a?(Hash) ? total['value'] : total
      end
    end
  end
end
