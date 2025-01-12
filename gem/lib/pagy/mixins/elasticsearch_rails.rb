# See the Pagy documentation: https://ddnexus.github.io/pagy/docs/extras/elasticsearch_rails
# frozen_string_literal: true

require_relative '../offset/elasticsearch_rails'
require_relative '../helpers/search'

class Pagy
  # Add specialized backend methods to paginate ElasticsearchRails searches
  Backend.module_eval do
    private

    # Return Pagy object and records
    def pagy_elasticsearch_rails(pagy_search_args, **vars)
      pagy_wrap_search(pagy_search_args, vars) do
        model, query_or_payload, options, _block, *called = pagy_search_args
        options[:size] = vars[:limit]
        options[:from] = vars[:limit] * ((vars[:page] || 1) - 1)
        Offset::ElasticsearchRails.class_eval do
          response     = model.send(self::DEFAULT[:search_method], query_or_payload, **options)
          vars[:count] = total_count(response)
          [new(**vars), response, called]
        end
      end
    end
  end
end
