# See the Pagy documentation: https://ddnexus.github.io/pagy/docs/extras/materialize
# frozen_string_literal: true

require 'pagy/extras/js_tools'

class Pagy # :nodoc:
  # Frontend modules are specially optimized for performance.
  # The resulting code may not look very elegant, but produces the best benchmarks
  module MaterializeExtra
    # Pagination for materialize: it returns the html with the series of links to the pages
    def pagy_materialize_nav(pagy, id: nil, aria_label: nil, **vars)
      id = %( id="#{id}") if id
      a  = pagy_anchor(pagy)

      html = +%(<div#{id} class="pagy-materialize nav pagination" role="navigation" #{
                  nav_aria_label(pagy, aria_label:)}><ul class="pagination">#{
                  materialize_prev_html(pagy, a)})
      pagy.series(**vars).each do |item| # series example: [1, :gap, 7, 8, "9", 10, 11, :gap, 36]
        html << case item
                when Integer
                  %(<li class="waves-effect">#{a.(item)}</li>)
                when String
                  %(<li class="active"><a role="link" aria-current="page" aria-disabled="true">#{pagy.label_for(item)}</a></li>)
                when :gap
                  %(<li class="gap disabled"><a role="link" aria-disabled="true">#{pagy_t 'pagy.gap'}</a></li>)
                else
                  raise InternalError, "expected item types in series to be Integer, String or :gap; got #{item.inspect}"
                end
      end
      html << %(#{materialize_next_html(pagy, a)}</ul></div>)
    end

    # Javascript pagination for materialize: it returns a nav with a data-pagy attribute used by the pagy.js file
    def pagy_materialize_nav_js(pagy, id: nil, aria_label: nil, **vars)
      sequels = pagy.sequels(**vars)
      id      = %( id="#{id}") if id
      a = pagy_anchor(pagy)

      tokens = { 'before' => %(<ul class="pagination">#{materialize_prev_html pagy, a}),
                 'a'      => %(<li class="waves-effect">#{a.(PAGE_TOKEN, LABEL_TOKEN)}</li>),
                 'current' => %(<li class="active"><a role="link" aria-current="page" aria-disabled="true">#{
                                  LABEL_TOKEN}</a></li>),
                 'gap'    => %(<li class="gap disabled"><a role="link" aria-disabled="true">#{pagy_t 'pagy.gap'}</a></li>),
                 'after'  => %(#{materialize_next_html pagy, a}</ul>) }

      %(<div#{id} class="#{'pagy-rjs ' if sequels.size > 1}pagy-materialize nav-js" role="navigation" #{
          nav_aria_label(pagy, aria_label:)} #{
          pagy_data(pagy, :nav, tokens, sequels, pagy.label_sequels(sequels))
        }></div>)
    end

    # Javascript combo pagination for materialize: it returns a nav with a data-pagy attribute used by the pagy.js file
    def pagy_materialize_combo_nav_js(pagy, id: nil, aria_label: nil)
      id    = %( id="#{id}") if id
      a     = pagy_anchor(pagy)
      pages = pagy.pages

      page_input = %(<input name="page" type="number" min="1" max="#{pages}" value="#{pagy.page}" aria-current="page" ) <<
                   %(style="text-align: center; width: #{pages.to_s.length + 1}rem; height: 1.5rem; font-size: 1.2rem; ) <<
                   %(border: none; border-radius: 2px; color: white; background-color: #ee6e73;" class="browser-default">)

      %(<ul#{id} class="pagy-materialize combo-nav-js pagination" role="navigation" style="padding-right: 0;" #{
          nav_aria_label(pagy, aria_label:)} #{
          pagy_data(pagy, :combo, pagy_url_for(pagy, PAGE_TOKEN))
        }>#{
          materialize_prev_html(pagy, a)
        }<li style="vertical-align: -webkit-baseline-middle;"><label style="font-size: 1.2rem;">#{
          pagy_t('pagy.combo_nav_js', page_input:, pages:)
        }</label></li>#{
          materialize_next_html(pagy, a)
        }</ul>)
    end

    private

    def materialize_prev_html(pagy, a)
      if (p_prev = pagy.prev)
        %(<li class="waves-effect prev">#{
        a.(p_prev, '<i class="material-icons">chevron_left</i>', aria_label: pagy_t('pagy.aria_label.prev'))}</li>)
      else
        %(<li class="prev disabled"><a role="link" aria-disabled="true" aria-label="#{
            pagy_t('pagy.aria_label.prev')}"><i class="material-icons">chevron_left</i></a></li>)
      end
    end

    def materialize_next_html(pagy, a)
      if (p_next = pagy.next)
        %(<li class="waves-effect next">#{
            a.(p_next, '<i class="material-icons">chevron_right</i>', aria_label: pagy_t('pagy.aria_label.next'))}</li>)
      else
        %(<li class="next disabled"#><a role="link" aria-disabled="true" aria-label="#{
            pagy_t('pagy.aria_label.next')}><i class="material-icons">chevron_right</i></a></li>)
      end
    end
  end
  Frontend.prepend MaterializeExtra
end
