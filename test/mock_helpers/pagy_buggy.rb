# frozen_string_literal: true
class PagyBuggy < Pagy

  # buggy series
  def series(_size = @vars[:size])
    [1,2,"3",true,false]
  end

end
