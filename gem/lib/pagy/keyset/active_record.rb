# frozen_string_literal: true

require_relative 'active_record_adapter'

class Pagy
  class Keyset
    class ActiveRecord < Keyset
      include ActiveRecordAdapter
    end
  end
end
