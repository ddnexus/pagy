# frozen_string_literal: true

class Pagy
  module Search
    # Collect the search arguments and record the chained calls, applied later by the paginators.
    # It is not an Array, so methods like filter, reject, sort, etc. get recorded as well
    class Arguments
      def initialize(*arguments)
        @arguments = arguments
        @calls     = []
      end

      # Destructure as [model, arguments, options, block, calls]
      def to_ary = [*@arguments, @calls]

      # Conversion methods are not recorded
      def respond_to_missing?(name, *) = !name.start_with?('to_')

      def method_missing(name, *args, **kwargs, &block)
        return super if name.start_with?('to_')

        @calls << [name, args, kwargs, block]
        self
      end
    end

    # Collect the search arguments to pass to the actual search
    def pagy_search(*arguments, **options, &block)
      Arguments.new(self, arguments, options, block)
    end
  end

  # Search classes do not use OFFSET for querying a DB;
  # however, they use the same positional technique used by Offset.
  class SearchBase < Offset
    def search? = true
  end

  class RailsActiveSearch < SearchBase
    DEFAULT = { search_method: :search }.freeze
  end

  class ElasticsearchRails < SearchBase
    DEFAULT = { search_method:     :search,
                max_result_window: 10_000 }.freeze
  end

  class Meilisearch < SearchBase
    DEFAULT = { search_method: :ms_search }.freeze
  end

  class Searchkick < SearchBase
    DEFAULT = { search_method:     :search,
                max_result_window: 10_000 }.freeze
  end

  class TypesenseRails < SearchBase
    DEFAULT = { search_method: :search }.freeze
  end
end
