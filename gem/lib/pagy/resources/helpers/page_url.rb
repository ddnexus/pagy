# frozen_string_literal: true

class Pagy
  # Return the page url for any page
  # :nocov:
  def page_url(page, **)
    case page
    when :first
      compose_page_url(nil, **)
    when :current
      compose_page_url(@page, **) if @page
    when :previous
      compose_page_url(@previous, **) if @previous
    when :next
      compose_page_url(@next, **) if @next
    when :last
      compose_page_url(@last, **) if @last
    when Integer, String
      compose_page_url(page, **)
    end
  end
  # :nocov:
end
