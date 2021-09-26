# See the Pagy documentation: https://ddnexus.github.io/pagy/extras/elasticsearch_rails
# frozen_string_literal: true

class Pagy
  DEFAULT[:elasticsearch_rails_search_method] ||= :pagy_search

  module ElasticsearchRailsExtra
    module ElasticsearchRails
      # Return an array used to delay the call of #search
      # after the pagination variables are merged to the options
      # it also pushes to the same array an eventually called method
      def pagy_elasticsearch_rails(query_or_payload, **options)
        [self, query_or_payload, options].tap do |args|
          args.define_singleton_method(:method_missing) { |*a| args += a }
        end
      end
      alias_method Pagy::DEFAULT[:elasticsearch_rails_search_method], :pagy_elasticsearch_rails
    end

    # Additions for the Pagy class
    module Pagy
      # Create a Pagy object from an Elasticsearch::Model::Response::Response object
      def new_from_elasticsearch_rails(response, vars = {})
        vars[:items] = response.search.options[:size] || 10
        vars[:page]  = ((response.search.options[:from] || 0) / vars[:items]) + 1
        total        = response.respond_to?(:raw_response) ? response.raw_response['hits']['total'] : response.response['hits']['total']
        vars[:count] = total.is_a?(Hash) ? total['value'] : total
        new(vars)
      end
    end

    # Add specialized backend methods to paginate ElasticsearchRails searches
    module Backend
      private

      # Return Pagy object and items
      def pagy_elasticsearch_rails(pagy_search_args, vars = {})
        model, query_or_payload,
        options, *called = pagy_search_args
        vars             = pagy_elasticsearch_rails_get_vars(nil, vars)
        options[:size]   = vars[:items]
        options[:from]   = vars[:items] * (vars[:page] - 1)
        response         = model.search(query_or_payload, **options)
        total            = response.respond_to?(:raw_response) ? response.raw_response['hits']['total'] : response.response['hits']['total']
        vars[:count]     = total.is_a?(Hash) ? total['value'] : total

        pagy = ::Pagy.new(vars)
        # with :last_page overflow we need to re-run the method in order to get the hits
        return pagy_elasticsearch_rails(pagy_search_args, vars.merge(page: pagy.page)) \
              if defined?(::Pagy::OverflowExtra) && pagy.overflow? && pagy.vars[:overflow] == :last_page

        [pagy, called.empty? ? response : response.send(*called)]
      end

      # Sub-method called only by #pagy_elasticsearch_rails: here for easy customization of variables by overriding
      # the _collection argument is not available when the method is called
      def pagy_elasticsearch_rails_get_vars(_collection, vars)
        pagy_set_items_from_params(vars) if defined?(ItemsExtra)
        vars[:items] ||= DEFAULT[:items]
        vars[:page]  ||= (params[vars[:page_param] || DEFAULT[:page_param]] || 1).to_i
        vars
      end
    end
  end
  ElasticsearchRails = ElasticsearchRailsExtra::ElasticsearchRails
  extend ElasticsearchRailsExtra::Pagy
  Backend.prepend ElasticsearchRailsExtra::Backend
end
