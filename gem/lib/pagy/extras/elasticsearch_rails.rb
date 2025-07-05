# See the Pagy documentation: https://ddnexus.github.io/pagy/docs/extras/elasticsearch_rails
# frozen_string_literal: true

class Pagy # :nodoc:
  DEFAULT[:elasticsearch_rails_search]      ||= :search
  DEFAULT[:elasticsearch_rails_pagy_search] ||= :pagy_search

  # Paginate ElasticsearchRails response objects
  module ElasticsearchRailsExtra
    module_function

    # Get the count from different version of ElasticsearchRails
    def total_count(response)
      total = if response.respond_to?(:raw_response)
                response.raw_response['hits']['total']
              else
                response.response['hits']['total']
              end
      total.is_a?(Hash) ? total['value'] : total
    end

    module ModelExtension # :nodoc:
      # Return an array used to delay the call of #search
      # after the pagination variables are merged to the options.
      # It also pushes to the same array an optional method call.
      def pagy_elasticsearch_rails(query_or_payload, **options)
        [self, query_or_payload, options].tap do |args|
          args.define_singleton_method(:method_missing) { |*a| args += a }
        end
      end
      alias_method DEFAULT[:elasticsearch_rails_pagy_search], :pagy_elasticsearch_rails
    end
    Pagy::ElasticsearchRails = ModelExtension

    # Additions for the Pagy class
    module PagyAddOn
      # Create a Pagy object from an Elasticsearch::Model::Response::Response object
      def new_from_elasticsearch_rails(response, **vars)
        vars[:limit] = response.search.options[:size] || 10
        vars[:page]  = ((response.search.options[:from] || 0) / vars[:limit]) + 1
        vars[:count] = ElasticsearchRailsExtra.total_count(response)
        Pagy.new(**vars)
      end
    end
    Pagy.extend PagyAddOn

    # Add specialized backend methods to paginate ElasticsearchRails searches
    module BackendAddOn
      private

      # Return Pagy object and records
      def pagy_elasticsearch_rails(pagy_search_args, **vars)
        vars[:page]  ||= pagy_get_page(vars)
        vars[:limit] ||= pagy_get_limit(vars)
        model, query_or_payload, options, *called = pagy_search_args
        options[:size] = vars[:limit]
        options[:from] = vars[:limit] * ((vars[:page] || 1) - 1)
        response       = model.send(DEFAULT[:elasticsearch_rails_search], query_or_payload, **options)
        vars[:count]   = ElasticsearchRailsExtra.total_count(response)

        pagy = ::Pagy.new(**vars)
        # with :last_page overflow we need to re-run the method in order to get the hits
        return pagy_elasticsearch_rails(pagy_search_args, **vars, page: pagy.page) \
               if defined?(::Pagy::OverflowExtra) && pagy.overflow? && pagy.vars[:overflow] == :last_page

        [pagy, called.empty? ? response : response.send(*called)]
      end
    end
    Backend.prepend BackendAddOn
  end
end
