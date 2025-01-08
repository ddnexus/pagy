# frozen_string_literal: true

require_relative '../sequel_adapter'

class Pagy
  class Keyset
    class Augmented
      class Sequel < Augmented
        include SequelAdapter
      end
    end
  end
end
