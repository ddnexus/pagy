# frozen_string_literal: true

class Pagy
  class Offset
    # Paginate Meilisearch results
    class ElasticsearchRails < Offset
      DEFAULT = { search_method: :search } # rubocop:disable Style/MutableConstant

      def self.new_from_search(results, **vars)
        vars[:limit] = results.search.options[:size] || 10
        vars[:page]  = ((results.search.options[:from] || 0) / vars[:limit]) + 1
        vars[:count] = total_count(results)
        new(**vars)
      end

      # Get the count from different version of ElasticsearchRails
      def self.total_count(results)
        total = results.instance_eval { respond_to?(:raw_response) ? raw_response['hits']['total'] : response['hits']['total'] }
        total.is_a?(Hash) ? total['value'] : total
      end
    end
  end
end
