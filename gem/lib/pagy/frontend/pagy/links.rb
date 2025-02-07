# frozen_string_literal: true

class Pagy
  Frontend.module_eval do
    # Conditionally return the previous page link tag
    def pagy_previous_link(pagy, **)
      %(<link href="#{pagy_page_url(pagy, pagy.previous, **)}"/>) if pagy.previous
    end

    # Conditionally return the next page link tag
    def pagy_next_link(pagy, **)
      %(<link href="#{pagy_page_url(pagy, pagy.next, **)}"/>) if pagy.next
    end
  end
end
