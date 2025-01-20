# frozen_string_literal: true

class Pagy
  class Offset
    module Search  # Model extension
      class Arguments < Array
        def respond_to_missing? = true

        def method_missing(*) = push(*)
      end

      # Collect the search arguments to pass to the actual search
      def pagy_search(term = nil, **options, &block)
        Arguments.new([self, term, options, block])
      end

      class ElasticsearchRails < Offset
        DEFAULT = { search_method: :search }.freeze

        # Get the count from different version of ElasticsearchRails
        def self.total_count(results)
          total = results.instance_eval { respond_to?(:raw_response) ? raw_response['hits']['total'] : response['hits']['total'] }
          total.is_a?(Hash) ? total['value'] : total
        end
      end

      class Meilisearch < Offset
        DEFAULT = { search_method: :ms_search }.freeze
      end

      class Searchkick < Offset
        DEFAULT = { search_method: :search }.freeze
      end
    end
  end
end
