# frozen_string_literal: true

require_relative '../../modules/searcher'

class Pagy
  module SearchkickPaginator
    module_function

    def paginate(search, options)
      options[:search_method]     ||= Searchkick::DEFAULT[:search_method]
      options[:max_result_window] ||= Searchkick::DEFAULT[:max_result_window]

      if search.is_a?(Search::Arguments) # Active mode

        Searcher.wrap(search, options) do
          model, arguments, search_options, block = search

          search_options[:per_page] = options[:limit]
          search_options[:page]     = options[:page]

          results         = model.send(options[:search_method], *arguments || '*', **search_options, &block)
          options[:count] = total_count_from(results, options)

          [Searchkick.new(**options), results]
        end

      else # Passive mode
        options[:limit] = search.respond_to?(:options) ? search.options[:per_page] : search.per_page
        options[:page]  = search.respond_to?(:options) ? search.options[:page]     : search.current_page
        options[:count] = total_count_from(search, options)

        Searchkick.new(**options)
      end
    end

    def total_count_from(response_object, options)
      [options[:max_result_window], response_object.total_count].min
    end
  end
end
