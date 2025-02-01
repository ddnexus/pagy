# frozen_string_literal: true

class Pagy
  Frontend.module_eval do
    private

    # Return the enabled/disabled previous/next page anchor tag, embedded in the li tag
    def pagy_bootstrap_html_for(which, pagy, a)
      if pagy.send(which)
        %(<li class="page-item #{which}">#{
        a.(pagy.send(which), pagy_translate("pagy.#{which}"),
           classes:    'page-link',
           aria_label: pagy_translate("pagy.aria_label.#{which}"))}</li>)
      else
        %(<li class="page-item #{which} disabled"><a role="link" class="page-link" aria-disabled="true" aria-label="#{
        pagy_translate("pagy.aria_label.#{which}")}">#{pagy_translate("pagy.#{which}")}</a></li>)
      end
    end
  end
end
