# frozen_string_literal: true

require_relative '../../modules/searcher'

class Pagy
  module ElasticsearchRailsPaginator
    module_function

    def paginate(search, options)
      options[:search_method]     ||= ElasticsearchRails::DEFAULT[:search_method]
      options[:max_result_window] ||= ElasticsearchRails::DEFAULT[:max_result_window]

      if search.is_a?(Search::Arguments)  # Active mode

        Searcher.wrap(search, options) do
          model, arguments, search_options = search

          search_options[:size] = options[:limit]
          search_options[:from] = options[:limit] * ((options[:page] || 1) - 1)

          response_object = model.send(options[:search_method], *arguments, **search_options)
          options[:count] = total_count_from(response_object, options)

          [ElasticsearchRails.new(**options), response_object]
        end

      else # Passive mode
        from, size      = pagination_params_from(search)
        options[:limit] = size
        options[:page]  = ((from || 0) / options[:limit]) + 1
        options[:count] = total_count_from(search, options)

        ElasticsearchRails.new(**options)
      end
    end

    # Support different versions of ElasticsearchRails
    def pagination_params_from(response_object)
      definition = response_object.search.definition
      definition = definition.to_hash if definition.respond_to?(:to_hash)
      container  = (definition.is_a?(Hash) && (definition[:body] || definition)) || response_object.search.options
      from       = (container[:from] || container['from']).to_i
      size       = (container[:size] || container['size']).to_i
      size       = 10 if size.zero?

      [from, size]
    end

    # Support different versions of ElasticsearchRails
    def total_count_from(response_object, options)
      total = response_object.instance_eval do
                respond_to?(:response) ? response['hits']['total'] : raw_response['hits']['total']
              end

      value = total.is_a?(Hash) ? total['value'] : total
      [options[:max_result_window], value].min
    end
  end
end
