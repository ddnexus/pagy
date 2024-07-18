# See the Pagy documentation: https://ddnexus.github.io/pagy/docs/extras/bootstrap
# frozen_string_literal: true

require_relative 'js_tools'

class Pagy # :nodoc:
  # Frontend modules are specially optimized for performance.
  # The resulting code may not look very elegant, but produces the best benchmarks
  module BootstrapExtra
    # Pagination for bootstrap: it returns the html with the series of links to the pages
    def pagy_bootstrap_nav(pagy, id: nil, classes: 'pagination', aria_label: nil, **vars)
      id = %( id="#{id}") if id
      a  = pagy_anchor(pagy, **vars)

      html = %(<nav#{id} class="pagy-bootstrap nav" #{nav_aria_label(pagy, aria_label:)}><ul class="#{classes}">#{
                 bootstrap_prev_html(pagy, a)})
      pagy.series(**vars).each do |item| # series example: [1, :gap, 7, 8, "9", 10, 11, :gap, 36]
        html << case item
                when Integer
                  %(<li class="page-item">#{a.(item, classes: 'page-link')}</li>)
                when String
                  %(<li class="page-item active"><a role="link" class="page-link" aria-current="page" aria-disabled="true">#{
                      pagy.label_for(item)}</a></li>)
                when :gap
                  %(<li class="page-item gap disabled"><a role="link" class="page-link" aria-disabled="true">#{
                      pagy_t('pagy.gap')}</a></li>)
                else raise InternalError, "expected item types in series to be Integer, String or :gap; got #{item.inspect}"
                end
      end
      html << %(#{bootstrap_next_html(pagy, a)}</ul></nav>)
    end

    # Javascript pagination for bootstrap: it returns a nav with a data-pagy attribute used by the pagy.js file
    def pagy_bootstrap_nav_js(pagy, id: nil, classes: 'pagination', aria_label: nil, **vars)
      sequels = pagy.sequels(**vars)
      id      = %( id="#{id}") if id
      a       = pagy_anchor(pagy, **vars)
      tokens  = { 'before'  => %(<ul class="#{classes}">#{bootstrap_prev_html(pagy, a)}),
                  'a'       => %(<li class="page-item">#{a.(PAGE_TOKEN, LABEL_TOKEN, classes: 'page-link')}</li>),
                  'current' => %(<li class="page-item active"><a role="link" class="page-link" ) +
                               %(aria-current="page" aria-disabled="true">#{LABEL_TOKEN}</a></li>),
                  'gap'     => %(<li class="page-item gap disabled"><a role="link" class="page-link" aria-disabled="true">#{
                                   pagy_t('pagy.gap')}</a></li>),
                  'after'   => %(#{bootstrap_next_html pagy, a}</ul>) }

      %(<nav#{id} class="#{'pagy-rjs ' if sequels.size > 1}pagy-bootstrap nav-js" #{
          nav_aria_label(pagy, aria_label:)} #{
          pagy_data(pagy, :nav, tokens, sequels, pagy.label_sequels(sequels))
        }></nav>)
    end

    # Javascript combo pagination for bootstrap: it returns a nav with a data-pagy attribute used by the pagy.js file
    def pagy_bootstrap_combo_nav_js(pagy, id: nil, classes: 'pagination', aria_label: nil, **vars)
      id    = %( id="#{id}") if id
      a     = pagy_anchor(pagy, **vars)
      pages = pagy.pages

      page_input = %(<input name="page" type="number" min="1" max="#{pages}" value="#{pagy.page}" aria-current="page" ) <<
                   %(style="text-align: center; width: #{pages.to_s.length + 1}rem; padding: 0; ) <<
                   %(border: none; display: inline-block;" class="page-link active">#{JSTools::A_TAG})

      %(<nav#{id} class="pagy-bootstrap combo-nav-js" #{
          nav_aria_label(pagy, aria_label:)} #{
          pagy_data(pagy, :combo, pagy_url_for(pagy, PAGE_TOKEN, **vars))
        }><ul class="#{classes}">#{
          bootstrap_prev_html(pagy, a)
        }<li class="page-item pagy-bootstrap"><label class="page-link">#{
          pagy_t('pagy.combo_nav_js', page_input:, pages:)
        }</label></li>#{
          bootstrap_next_html(pagy, a)
        }</ul></nav>)
    end

    private

    def bootstrap_prev_html(pagy, a)
      if (p_prev = pagy.prev)
        %(<li class="page-item prev">#{
            a.(p_prev, pagy_t('pagy.prev'), classes: 'page-link', aria_label: pagy_t('pagy.aria_label.prev'))}</li>)
      else
        %(<li class="page-item prev disabled"><a role="link" class="page-link" aria-disabled="true" aria-label="#{
            pagy_t('pagy.aria_label.prev')}">#{pagy_t('pagy.prev')}</a></li>)
      end
    end

    def bootstrap_next_html(pagy, a)
      if (p_next = pagy.next)
        %(<li class="page-item next">#{
            a.(p_next, pagy_t('pagy.next'), classes: 'page-link', aria_label: pagy_t('pagy.aria_label.next'))}</li>)
      else
        %(<li class="page-item next disabled"><a role="link" class="page-link" aria-disabled="true" aria-label="#{
            pagy_t('pagy.aria_label.next')}">#{pagy_t('pagy.next')}</a></li>)
      end
    end
  end
  Frontend.prepend BootstrapExtra
end
