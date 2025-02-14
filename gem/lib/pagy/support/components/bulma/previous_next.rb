# frozen_string_literal: true

class Pagy
  class_eval do
    private

    # Return the enabled/disabled previous/next page anchor tag
    def bulma_previous_next_html(anchor_lambda)
      %w[previous next].inject(+'') do |html, which|
        html << if send(which)
                  anchor_lambda.(send(which), I18n.translate("pagy.#{which}"),
                                 classes: "pagination-#{which}",
                                 aria_label: I18n.translate("pagy.aria_label.#{which}"))
                else
                  %(<a role="link" class="pagination-#{which}" disabled aria-disabled="true" aria-label="#{
                  I18n.translate("pagy.aria_label.#{which}")}">#{I18n.translate("pagy.#{which}")}</a>)
                end
      end
    end
  end
end
