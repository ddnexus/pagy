# frozen_string_literal: true

class Pagy
  Frontend.module_eval do
    # Javascript combo pagination: it returns a nav with a data-pagy attribute used by the pagy.js file
    def pagy_combo_nav_js(pagy, id: nil, aria_label: nil, **vars)
      id    = %( id="#{id}") if id
      a     = pagy_anchor(pagy, **vars)
      pages = pagy.pages

      page_input = %(<input name="page" type="number" min="1" max="#{pages}" value="#{pagy.page}" aria-current="page" ) <<
                   %(style="text-align: center; width: #{pages.to_s.length + 1}rem; padding: 0;">#{A_TAG})

      %(<nav#{id} class="pagy combo-nav-js" #{
          pagy_nav_aria_label(pagy, aria_label:)} #{
          pagy_data(pagy, :cj, pagy_page_url(pagy, PAGE_TOKEN, **vars))}>#{
          pagy_prev_a(pagy, a)
        }<label>#{
          pagy_t('pagy.combo_nav_js', page_input:, pages:)
        }</label>#{
          pagy_next_a(pagy, a)
        }</nav>)
    end
  end
end
