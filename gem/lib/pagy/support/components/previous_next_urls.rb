# frozen_string_literal: true

class Pagy
  # Return the previous page URL string or nil
  def previous_url(**)
    page_url(@previous, **) if @previous
  end

  # Return the next page URL string or nil
  def next_url(**)
    page_url(@next, **) if @next
  end
end
