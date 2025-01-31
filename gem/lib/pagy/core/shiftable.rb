# frozen_string_literal: true

class Pagy
  module Core
    # Add a few assign_* methods
    module Shiftable
      # Assign @previous and @next
      def assign_previous_and_next
        @previous = (@page - 1 unless @page == 1)
        @next     = (@page + 1 unless @page == @last)
      end
    end
  end
end
