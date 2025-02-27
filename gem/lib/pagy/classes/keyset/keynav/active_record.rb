# frozen_string_literal: true

require_relative '../adapters/active_record'

class Pagy
  class Keyset
    class Keynav
      class ActiveRecord < Keynav
        include Adapters::ActiveRecord
      end
    end
  end
end
