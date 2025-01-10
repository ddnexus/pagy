# frozen_string_literal: true

require_relative '../adapters/sequel'

class Pagy
  class Keyset
    class Augmented
      class Sequel < Augmented
        include Adapters::Sequel
      end
    end
  end
end
