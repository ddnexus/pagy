# frozen_string_literal: true

class Pagy
  module Core
    # Add method supporting range checking
    module Rangeable
      # Check if in range
      def in_range?
        return @in_range if defined?(@in_range) || (@in_range = yield)
        raise RangeError.new(self, :page, "in 1..#{@last}", @page) if @opts[:raise_range_error]

        assign_empty_page_vars
        false
      end
    end
  end
end
