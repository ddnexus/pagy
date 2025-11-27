# frozen_string_literal: true

require_relative '../../modules/searcher'

class Pagy
  module ElasticsearchRailsPaginator
    module_function

    # Paginate from the search object
    def paginate(search, options)
      if search.is_a?(Search::Arguments)
        # The search is the array of pagy_search arguments
        Searcher.wrap(search, options) do
          model, query_or_payload, search_options = search
          search_options[:size] = options[:limit]
          search_options[:from] = options[:limit] * ((options[:page] || 1) - 1)
          results               = model.send(options[:search_method] || ElasticsearchRails::DEFAULT[:search_method],
                                             query_or_payload, **search_options)
          options[:count]       = get_total_count(results)
          [ElasticsearchRails.new(**options), results]
        end
      else
        size, from      = get_es_params(search)
        options[:limit] = size
        options[:page]  = ((from || 0) / options[:limit]) + 1
        options[:count] = get_total_count(search)
        ElasticsearchRails.new(**options)
      end
    end

    # Get the :size and :from params from different versions of ElasticsearchRails
    def get_es_params(response)
      raw_def    = response.search.definition
      definition = raw_def.respond_to?(:to_hash) ? raw_def.to_hash : raw_def
      container  = (definition.is_a?(Hash) && (definition[:body] || definition)) || response.search.options
      size       = (container[:size] || container['size']).to_i
      from       = (container[:from] || container['from']).to_i
      size       = 10 if size.zero?
      [size, from]
    end

    # Get the count from different versions of ElasticsearchRails
    def get_total_count(response)
      total = response.instance_eval do
                respond_to?(:response) ? response['hits']['total'] : raw_response['hits']['total']
              end
      total.is_a?(Hash) ? total['value'] : total
    end
  end
end
