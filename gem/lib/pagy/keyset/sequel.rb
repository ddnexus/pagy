# frozen_string_literal: true

require_relative 'sequel_adapter'

class Pagy
  class Keyset
    class Sequel < Keyset
      include SequelAdapter
    end
  end
end
