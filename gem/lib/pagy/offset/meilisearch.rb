# frozen_string_literal: true

class Pagy
  class Offset
    # Paginate Meilisearch results
    class Meilisearch < Offset
      DEFAULT = { search_method: :ms_search } # rubocop:disable Style/MutableConstant

      def self.new_from_search(results, **vars)
        vars[:limit] = results.raw_answer['hitsPerPage']
        vars[:page]  = results.raw_answer['page']
        vars[:count] = results.raw_answer['totalHits']
        new(**vars)
      end
    end
  end
end
