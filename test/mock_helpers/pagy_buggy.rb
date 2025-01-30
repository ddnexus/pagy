# frozen_string_literal: true

class PagyBuggy < Pagy::Offset
  # buggy series
  def series(_size = @opts[:size])
    [1, 2, "3", true, false]
  end
end
