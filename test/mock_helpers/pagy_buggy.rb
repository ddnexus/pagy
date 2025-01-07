# frozen_string_literal: true

require 'pagy/offset'
class PagyBuggy < Pagy::Offset
  # buggy series
  def series(_size = @vars[:size])
    [1, 2, "3", true, false]
  end
end
