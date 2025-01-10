# frozen_string_literal: true

require_relative '../adapters/active_record'

class Pagy
  class Keyset
    class Augmented
      class ActiveRecord < Augmented
        include Adapters::ActiveRecord
      end
    end
  end
end
