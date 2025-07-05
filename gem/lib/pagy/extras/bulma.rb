# See the Pagy documentation: https://ddnexus.github.io/pagy/docs/extras/bulma
# frozen_string_literal: true

require_relative 'js_tools'

class Pagy # :nodoc:
  # Frontend modules are specially optimized for performance.
  # The resulting code may not look very elegant, but produces the best benchmarks
  module BulmaExtra
    # Pagination for bulma: it returns the html with the series of links to the pages
    def pagy_bulma_nav(pagy, id: nil, classes: 'pagy-bulma nav pagination is-centered',
                       aria_label: nil, **vars)
      id = %( id="#{id}") if id
      a  = pagy_anchor(pagy, **vars)

      html = %(<nav#{id} class="#{classes}" #{nav_aria_label(pagy, aria_label:)}>)
      html << bulma_prev_next_html(pagy, a)
      html << %(<ul class="pagination-list">)
      pagy.series(**vars).each do |item| # series example: [1, :gap, 7, 8, "9", 10, 11, :gap, 36]
        html << case item
                when Integer
                  %(<li>#{a.(item, pagy.label_for(item), classes: 'pagination-link')}</li>)
                when String
                  %(<li><a role="link" class="pagination-link is-current" aria-current="page" aria-disabled="true">#{
                      pagy.label_for(item)}</a></li>)
                when :gap
                  %(<li><span class="pagination-ellipsis">#{pagy_t 'pagy.gap'}</span></li>)
                else raise InternalError, "expected item types in series to be Integer, String or :gap; got #{item.inspect}"
                end
      end
      html << %(</ul></nav>)
    end

    # Javascript pagination for bulma: it returns a nav with a data-pagy attribute used by the Pagy.nav javascript
    def pagy_bulma_nav_js(pagy, id: nil, classes: 'pagy-bulma nav-js pagination is-centered',
                          aria_label: nil, **vars)
      sequels = pagy.sequels(**vars)
      id      = %( id="#{id}") if id
      a       = pagy_anchor(pagy, **vars)
      tokens = { 'before'  => %(#{bulma_prev_next_html(pagy, a)}<ul class="pagination-list">),
                 'a'       => %(<li>#{a.(PAGE_TOKEN, LABEL_TOKEN, classes: 'pagination-link')}</li>),
                 'current' => %(<li><a role="link" class="pagination-link is-current" aria-current="page" aria-disabled="true">#{
                                  LABEL_TOKEN}</a></li>),
                 'gap'     => %(<li><span class="pagination-ellipsis">#{pagy_t 'pagy.gap'}</span></li>),
                 'after'   => '</ul>' }

      %(<nav#{id} class="#{'pagy-rjs ' if sequels.size > 1}#{classes}" #{
          nav_aria_label(pagy, aria_label:)} #{
          pagy_data(pagy, :nav, tokens, sequels, pagy.label_sequels(sequels))
        }></nav>)
    end

    # Javascript combo pagination for bulma: it returns a nav with a data-pagy attribute used by the pagy.js file
    def pagy_bulma_combo_nav_js(pagy, id: nil, classes: 'pagy-bulma combo-nav-js pagination is-centered',
                                aria_label: nil, **vars)
      id    = %( id="#{id}") if id
      a     = pagy_anchor(pagy, **vars)
      pages = pagy.pages

      page_input = %(<input name="page" type="number" min="1" max="#{pages}" value="#{pagy.page}" aria-current="page") <<
                   %(style="text-align: center; width: #{pages.to_s.length + 1}rem; height: 1.7rem; margin:0 0.3rem; ) <<
                   %(border: none; border-radius: 4px; padding: 0; font-size: 1.1rem; color: white; ) <<
                   %(background-color: #485fc7;">#{JSTools::A_TAG})

      %(<nav#{id} class="#{classes}" #{
          nav_aria_label(pagy, aria_label:)} #{
          pagy_data(pagy, :combo, pagy_url_for(pagy, PAGE_TOKEN, **vars))
        }>#{
          bulma_prev_next_html(pagy, a)
        }<ul class="pagination-list"><li class="pagination-link"><label>#{
           pagy_t('pagy.combo_nav_js', page_input:, pages:)
        }</label></li></ul></nav>)
    end

    private

    def bulma_prev_next_html(pagy, a)
      html = if (p_prev = pagy.prev)
               a.(p_prev, pagy_t('pagy.prev'), classes: 'pagination-previous', aria_label: pagy_t('pagy.aria_label.prev'))
             else
               %(<a role="link" class="pagination-previous" disabled aria-disabled="true" aria-label="#{
                   pagy_t('pagy.aria_label.prev')}">#{pagy_t 'pagy.prev'}</a>)
             end
      html << if (p_next = pagy.next)
                a.(p_next, pagy_t('pagy.next'), classes: 'pagination-next', aria_label: pagy_t('pagy.aria_label.next'))
              else
                %(<a role="link" class="pagination-next" disabled aria-disabled="true" aria-label="#{
                    pagy_t('pagy.aria_label.next')}">#{pagy_t('pagy.next')}</a>)
              end
    end
  end
  Frontend.prepend BulmaExtra
end
