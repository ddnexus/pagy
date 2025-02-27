# frozen_string_literal: true

require_relative '../adapters/sequel'

class Pagy
  class Keyset
    class Keynav
      class Sequel < Keynav
        include Adapters::Sequel
      end
    end
  end
end
