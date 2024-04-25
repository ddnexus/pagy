# frozen_string_literal: true

warn '[PAGY WARNING] The foundation extra has been discontinued and it will be removed in v9 ' \
     '(https://github.com/ddnexus/pagy/discussions/672#discussioncomment-9212328)'

require_relative 'js_tools'

class Pagy # :nodoc:
  # Frontend modules are specially optimized for performance.
  # The resulting code may not look very elegant, but produces the best benchmarks
  module FoundationExtra
    # Pagination for Foundation: it returns the html with the series of links to the pages
    def pagy_foundation_nav(pagy, id: nil, aria_label: nil, **vars)
      id = %( id="#{id}") if id
      a  = pagy_anchor(pagy)

      html = +%(<nav#{id} class="pagy-foundation-nav" #{
                  nav_aria_label(pagy, aria_label:)}><ul class="pagination"> #{
                  foundation_prev_html(pagy, a)})
      pagy.series(**vars).each do |item| # series example: [1, :gap, 7, 8, "9", 10, 11, :gap, 36]
        html << case item
                when Integer
                  %(<li>#{a.(item)}</li>)
                when String
                  %(<li class="current" role="link" aria-current="page" aria-disabled="true">#{pagy.label_for(item)}</li>)
                when :gap
                  %(<li class="ellipsis gap"></li>)
                else
                  raise InternalError, "expected item types in series to be Integer, String or :gap; got #{item.inspect}"
                end
      end
      html << %(#{foundation_next_html(pagy, a)}</ul></nav>)
    end

    # Javascript pagination for foundation: it returns a nav with a data-pagy attribute used by the pagy.js file
    def pagy_foundation_nav_js(pagy, id: nil, aria_label: nil, **vars)
      sequels = pagy.sequels(**vars)
      id      = %( id="#{id}") if id
      a       = pagy_anchor(pagy)
      tokens  = { 'before'  => %(<ul class="pagination">#{foundation_prev_html pagy, a}),
                  'a'       => %(<li>#{a.(PAGE_TOKEN, LABEL_TOKEN)}</li>),
                  'current' => %(<li class="current" role="link" aria-current="page" aria-disabled="true">#{LABEL_TOKEN}</li>),
                  'gap'     => %(<li class="ellipsis gap"></li>),
                  'after'   => %(#{foundation_next_html pagy, a}</ul>) }

      %(<nav#{id} class="#{'pagy-rjs ' if sequels.size > 1}pagy-foundation-nav-js" #{
          nav_aria_label(pagy, aria_label:)} #{
          pagy_data(pagy, :nav, tokens, sequels, pagy.label_sequels(sequels))
        }></nav>)
    end

    # Javascript combo pagination for Foundation: it returns a nav with a data-pagy attribute used by the pagy.js file
    def pagy_foundation_combo_nav_js(pagy, id: nil, aria_label: nil)
      id    = %( id="#{id}") if id
      a     = pagy_anchor(pagy)
      pages = pagy.pages

      page_input = %(<input name="page" type="number" min="1" max="#{pages}" value="#{pagy.page}" aria-current="page" ) <<
                   %(style="text-align: center; width: #{pages.to_s.length + 1}rem; ) <<
                   %(height: 1.5rem; padding: .5rem; margin: 0 .4rem; font-size: .875rem;" class="current">#{JSTools::A_TAG})

      %(<nav#{id} class="pagy-foundation-combo-nav-js" #{
          nav_aria_label(pagy, aria_label:)} #{
          pagy_data(pagy, :combo, pagy_url_for(pagy, PAGE_TOKEN))
        }><ul class="pagination">#{
          foundation_prev_html(pagy, a)
        }<li style="padding: 0 .3rem"><label style="display: flex; align-items: center; white-space: nowrap">#{
          pagy_t('pagy.combo_nav_js', page_input:, pages:)
        }</label></li>#{
          foundation_next_html(pagy, a)
        }</ul></nav>)
    end

    private

    def foundation_prev_html(pagy, a)
      if (p_prev = pagy.prev)
        %(<li class="prev">#{a.(p_prev, pagy_t('pagy.prev'), aria_label: pagy_t('pagy.aria_label.prev'))}</li>)
      else
        %(<li class="prev disabled" role="link" aria-disabled="true" aria-label="#{
            pagy_t('pagy.aria_label.prev')}">#{pagy_t('pagy.prev')}</li>)
      end
    end

    def foundation_next_html(pagy, a)
      if (p_next = pagy.next)
        %(<li class="next">#{a.(p_next, pagy_t('pagy.next'), aria_label: pagy_t('pagy.aria_label.next'))}</li>)
      else
        %(<li class="next disabled" role="link" aria-disabled="true" aria-label="#{
             pagy_t('pagy.aria_label.next')}">#{pagy_t('pagy.next')}</li>)
      end
    end
  end
  Frontend.prepend FoundationExtra
end
