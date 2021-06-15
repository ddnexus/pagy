# frozen_string_literal: true

require 'pagy/extras/meilisearch'

module MockMeilisearch

  class Model
    extend Pagy::Meilisearch
  end
end
