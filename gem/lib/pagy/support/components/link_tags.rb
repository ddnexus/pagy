# frozen_string_literal: true

class Pagy
  # Conditionally return the previous page link tag
  def previous_link_tag(**)
    %(<link href="#{page_url(@previous, **)}"/>) if @previous
  end

  # Conditionally return the next page link tag
  def next_link_tag(**)
    %(<link href="#{page_url(@next, **)}"/>) if @next
  end
end
