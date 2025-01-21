# frozen_string_literal: true

require_relative 'prev_next'

class Pagy
  Frontend.module_eval do
    # Javascript combo pagination for bulma: it returns a nav with a data-pagy attribute used by the pagy.js file
    def pagy_bulma_combo_nav_js(pagy, id: nil, classes: 'pagy-bulma combo-nav-js pagination is-centered',
                                aria_label: nil, **vars)
      id  &&= %( id="#{id}")
      a     = pagy_anchor(pagy, **vars)
      pages = pagy.pages

      page_input = %(<input name="page" type="number" min="1" max="#{pages}" value="#{pagy.page}" aria-current="page") <<
                   %(style="text-align: center; width: #{pages.to_s.length + 1}rem; height: 1.7rem; margin:0 0.3rem; ) <<
                   %(border: none; border-radius: 4px; padding: 0; font-size: 1.1rem; color: white; ) <<
                   %(background-color: #485fc7;">#{A_TAG})

      %(<nav#{id} class="#{classes}" #{
          Front.nav_aria_label(self, pagy, aria_label:)} #{
          Front.data_pagy(:cj, pagy_page_url(pagy, PAGE_TOKEN, **vars))
        }>#{
          bulma_prev_next_html(pagy, a)
        }<ul class="pagination-list"><li class="pagination-link"><label>#{
           pagy_t('pagy.combo_nav_js', page_input:, pages:)
        }</label></li></ul></nav>)
    end
  end
end
