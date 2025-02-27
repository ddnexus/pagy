# frozen_string_literal: true

require_relative 'adapters/sequel'

class Pagy
  class Keyset
    class Sequel < Keyset
      include Adapters::Sequel
    end
  end
end
