# frozen_string_literal: true

class Pagy
  Frontend.module_eval do
    private

    # Return the enabled/disabled prev/next page anchor tag
    def bulma_prev_next_html(pagy, a)
      { prev: 'previous', next: 'next' }.inject(+'') do |html, (k, v)|
        html << if (p_prev = pagy.send(k))
                  a.(p_prev, pagy_t("pagy.#{k}"), classes: "pagination-#{v}", aria_label: pagy_t("pagy.aria_label.#{k}"))
                else
                  %(<a role="link" class="pagination-#{v}" disabled aria-disabled="true" aria-label="#{
                  pagy_t("pagy.aria_label.#{k}")}">#{pagy_t("pagy.#{k}")}</a>)
                end
      end
    end
  end
end
