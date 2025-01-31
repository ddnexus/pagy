# frozen_string_literal: true

class Pagy
  Frontend.module_eval do
    # Return the previous page URL string or nil
    def pagy_previous_url(pagy, **)
      pagy_page_url(pagy, pagy.previous, **) if pagy.previous
    end

    # Return the next page URL string or nil
    def pagy_next_url(pagy, **)
      pagy_page_url(pagy, pagy.next, **) if pagy.next
    end

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
