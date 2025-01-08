# frozen_string_literal: true

require_relative '../active_record_adapter'

class Pagy
  class Keyset
    class Augmented
      class ActiveRecord < Augmented
        include ActiveRecordAdapter
      end
    end
  end
end
