# frozen_string_literal: true

class Pagy
  module Shiftable
    def assign_previous_and_next
      @previous = @page - 1 unless @page == 1
      @next     = @page + 1 unless @page == @last
    end

    def self.included(including)
      including.send(:protected, :assign_previous_and_next)
    end
  end
end
