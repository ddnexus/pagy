# frozen_string_literal: true

class Pagy

  VARS[:meilisearch_search_method] ||= :pagy_search

  module Meilisearch

    # returns an array used to delay the call of #search
    # after the pagination variables are merged to the options
    def pagy_searchkick(q = nil, **params)
      [self, q, params]
    end
    alias_method VARS[:meilisearch_search_method], :pagy_searchkick
  end
end
