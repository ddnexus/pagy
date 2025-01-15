# frozen_string_literal: true

class Pagy
  class Offset
    # Paginate Meilisearch results
    class Meilisearch < Offset
      DEFAULT = { search_method: :ms_search } # rubocop:disable Style/MutableConstant
    end
  end
end
