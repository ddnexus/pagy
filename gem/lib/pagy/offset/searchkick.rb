# frozen_string_literal: true

class Pagy
  class Offset
    # Paginate Meilisearch results
    class Searchkick < Offset
      DEFAULT = { search_method: :search }  # rubocop:disable Style/MutableConstant
    end
  end
end
