# frozen_string_literal: true

class Pagy
  module Core
    # Add a few assign_* methods
    module Assignable
      # Assign @prev and @next
      def assign_prev_and_next
        @prev = (@page - 1 unless @page == 1)
        @next = (@page + 1 unless @page == @last)
      end
    end
  end
end
