# frozen_string_literal: true

class PagyBuggy < Pagy::Offset
  # buggy series
  def series(_size = @options[:slots])
    [1, 2, "3", true, false]
  end
end
