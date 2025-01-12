# frozen_string_literal: true

class Pagy
  class Offset
    # Paginate Meilisearch results
    class Searchkick < Offset
      DEFAULT = { search_method: :search }  # rubocop:disable Style/MutableConstant

      # Create a pagy object from a Searchkick::Results object
      def self.new_from_search(results, **vars)
        vars[:limit] = results.options[:per_page]
        vars[:page]  = results.options[:page]
        vars[:count] = results.total_count
        new(**vars)
      end
    end
  end
end
