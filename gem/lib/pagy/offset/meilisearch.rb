# frozen_string_literal: true

class Pagy
  class Offset
    # Paginate Meilisearch results
    class Meilisearch < Offset
      DEFAULT[:meilisearch_search]      ||= :ms_search
      DEFAULT[:meilisearch_pagy_search] ||= :pagy_search

      def self.new_from_meilisearch(results, **vars)
        vars[:limit] = results.raw_answer['hitsPerPage']
        vars[:page]  = results.raw_answer['page']
        vars[:count] = results.raw_answer['totalHits']
        new(**vars)
      end
    end
  end
end
