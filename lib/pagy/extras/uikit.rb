# See the Pagy documentation: https://ddnexus.github.io/pagy/extras/uikit
# frozen_string_literal: true

require 'pagy/extras/shared'

class Pagy
  module Frontend

    # Pagination for uikit: it returns the html with the series of links to the pages
    def pagy_uikit_nav(pagy, pagy_id: nil, link_extra: '')
      p_id = %( id="#{pagy_id}") if pagy_id
      link = pagy_link_proc(pagy, link_extra)

      html = %(<ul#{p_id} class="pagy-uikit-nav uk-pagination uk-flex-center">#{pagy_uikit_prev_html pagy, link})
      pagy.series.each do |item|
        html << case    item
                when Integer then %(<li>#{link.call item}</li>)
                when String  then %(<li class="uk-active"><span>#{item}</span></li>)
                when :gap    then %(<li class="uk-disabled"><span>#{pagy_t 'pagy.nav.gap'}</span></li>)
                end
      end
      html << pagy_uikit_next_html(pagy, link)
      html << %(</ul>)
    end

    # Javascript pagination for uikit: it returns a nav and a JSON tag used by the Pagy.nav javascript
    def pagy_uikit_nav_js(pagy, deprecated_id=nil, pagy_id: nil, link_extra: '', steps: nil)
      pagy_id = pagy_deprecated_arg(:id, deprecated_id, :pagy_id, pagy_id) if deprecated_id
      p_id = %( id="#{pagy_id}") if pagy_id
      link = pagy_link_proc(pagy, link_extra)
      tags = { 'before' => pagy_uikit_prev_html(pagy, link),
               'link'   => %(<li>#{link.call(PAGE_PLACEHOLDER)}</li>),
               'active' => %(<li class="uk-active"><span>#{PAGE_PLACEHOLDER}</span></li>),
               'gap'    => %(<li class="uk-disabled"><span>#{pagy_t('pagy.nav.gap')}</span></li>),
               'after'  => pagy_uikit_next_html(pagy, link) }

      html = %(<ul#{p_id} class="pagy-uikit-nav-js uk-pagination uk-flex-center"></ul>)
      html << pagy_json_tag(pagy, :nav, tags, pagy.sequels(steps))
    end

    # Javascript combo pagination for uikit: it returns a nav and a JSON tag used by the Pagy.combo_nav javascript
    def pagy_uikit_combo_nav_js(pagy, deprecated_id=nil, pagy_id: nil, link_extra: '')
      pagy_id = pagy_deprecated_arg(:id, deprecated_id, :pagy_id, pagy_id) if deprecated_id
      p_id    = %( id="#{pagy_id}") if pagy_id
      link    = pagy_link_proc(pagy, link_extra)
      p_page  = pagy.page
      p_pages = pagy.pages
      input   = %(<input type="number" min="1" max="#{p_pages}" value="#{p_page}" class="uk-input" style="padding: 0; text-align: center; width: #{p_pages.to_s.length+1}rem;">)

      %(<div#{p_id} class="pagy-uikit-combo-nav-js uk-button-group">#{
          if (p_prev = pagy.prev)
            link.call p_prev, pagy_t('pagy.nav.prev'), 'class="uk-button uk-button-default"'
          else
            %(<button class="uk-button uk-button-default" disabled>#{pagy_t 'pagy.nav.prev'}</button>)
          end
      }<div class="uk-text-middle uk-margin-left uk-margin-right">#{
          pagy_t 'pagy.combo_nav_js', page_input: input, count: p_page, pages: p_pages
      }</div>#{
          if (p_next = pagy.next)
            link.call p_next, pagy_t('pagy.nav.next'), 'class="uk-button uk-button-default"'
          else
            %(<button class="uk-button uk-button-default" disabled>#{pagy_t 'pagy.nav.next'}</button>)
          end
      }</div>#{
          pagy_json_tag pagy, :combo_nav, p_page, pagy_marked_link(link)
      })
    end



    private

      def pagy_uikit_prev_html(pagy, link)
        previous_span = %(<span uk-pagination-previous>#{pagy_t 'pagy.nav.prev'}</span>)
        if (p_prev = pagy.prev)
          %(<li>#{link.call p_prev, previous_span}</li>)
        else
          %(<li class="uk-disabled"><a href="#">#{previous_span}</a></li>)
        end
      end

      def pagy_uikit_next_html(pagy, link)
        next_span = %(<span uk-pagination-next>#{pagy_t 'pagy.nav.next'}</span>)
        if (p_next = pagy.next)
          %(<li>#{link.call p_next, next_span}</li>)
        else
          %(<li class="uk-disabled"><a href="#">#{next_span}</a></li>)
        end
      end

  end
end
