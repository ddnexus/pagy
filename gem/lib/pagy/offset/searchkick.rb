# frozen_string_literal: true

class Pagy
  class Offset
    # Paginate Meilisearch results
    class Searchkick < Offset
      DEFAULT[:searchkick_search]      ||= :search
      DEFAULT[:searchkick_pagy_search] ||= :pagy_search

      # Create a pagy object from a Searchkick::Results object
      def self.new_from_searchkick(results, **vars)
        vars[:limit] = results.options[:per_page]
        vars[:page]  = results.options[:page]
        vars[:count] = results.total_count
        new(**vars)
      end
    end
  end
end
