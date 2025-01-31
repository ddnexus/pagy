# frozen_string_literal: true

class Pagy
  Frontend.module_eval do
    private

    # Return the enabled/disabled previous/next page anchor tag
    def bulma_previous_next_html(pagy, a)
      %w[previous next].inject(+'') do |html, which|
        html << if pagy.send(which)
                  a.(pagy.send(which), pagy_t("pagy.#{which}"), classes:    "pagination-#{which}",
                                                                aria_label: pagy_t("pagy.aria_label.#{which}"))
                else
                  %(<a role="link" class="pagination-#{which}" disabled aria-disabled="true" aria-label="#{
                  pagy_t("pagy.aria_label.#{which}")}">#{pagy_t("pagy.#{which}")}</a>)
                end
      end
    end
  end
end
