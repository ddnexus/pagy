# frozen_string_literal: true

require_relative 'prev_next'
require_relative '../utils/nav_aria_label'
require_relative '../utils/data_pagy'

class Pagy
  Frontend.module_eval do
    # Javascript combo pagination for bootstrap: it returns a nav with a data-pagy attribute used by the pagy.js file
    def pagy_bootstrap_combo_nav_js(pagy, id: nil, classes: 'pagination', aria_label: nil, **vars)
      id  &&= %( id="#{id}")
      a     = pagy_anchor(pagy, **vars)
      pages = pagy.pages

      page_input = %(<input name="page" type="number" min="1" max="#{pages}" value="#{pagy.page}" aria-current="page" ) <<
                   %(style="text-align: center; width: #{pages.to_s.length + 1}rem; padding: 0; ) <<
                   %(border: none; display: inline-block;" class="page-link active">#{A_TAG})

      %(<nav#{id} class="pagy-bootstrap combo-nav-js" #{
          NavAriaLabel.attr(self, pagy, aria_label:)} #{
          DataPagy.attr(:cj, pagy_page_url(pagy, PAGE_TOKEN, **vars))
        }><ul class="#{classes}">#{
          bootstrap_prev_html(pagy, a)
        }<li class="page-item pagy-bootstrap"><label class="page-link">#{
          pagy_t('pagy.combo_nav_js', page_input:, pages:)
        }</label></li>#{
          bootstrap_next_html(pagy, a)
        }</ul></nav>)
    end
  end
end
