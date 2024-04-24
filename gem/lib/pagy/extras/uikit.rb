# frozen_string_literal: true

warn '[PAGY WARNING] The uikit extra has been discontinued and it will be removed in v9 ' \
     '(https://github.com/ddnexus/pagy/discussions/672#discussioncomment-9212328)'

require_relative 'js_tools'

class Pagy # :nodoc:
  # Frontend modules are specially optimized for performance.
  # The resulting code may not look very elegant, but produces the best benchmarks
  module UikitExtra
    # Pagination for uikit: it returns the html with the series of links to the pages
    def pagy_uikit_nav(pagy, id: nil, aria_label: nil, **vars)
      id = %( id="#{id}") if id
      a  = pagy_anchor(pagy)

      html = %(<ul#{id} class="pagy-uikit nav uk-pagination uk-flex-center" role="navigation" #{
                nav_aria_label(pagy, aria_label:)}>#{
                uikit_prev_html(pagy, a)})
      pagy.series(**vars).each do |item| # series example: [1, :gap, 7, 8, "9", 10, 11, :gap, 36]
        html << case item
                when Integer
                  %(<li>#{a.(item)}</li>)
                when String
                  %(<li class="uk-active"><span role="link" aria-current="page" aria-disabled="true">#{
                      pagy.label_for(item)}</span></li>)
                when :gap
                  %(<li class="uk-disabled"><span>#{pagy_t 'pagy.gap'}</span></li>)
                else
                  raise InternalError, "expected item types in series to be Integer, String or :gap; got #{item.inspect}"
                end
      end
      html << %(#{uikit_next_html(pagy, a)}</ul>)
    end

    # Javascript pagination for uikit: it returns a nav with a data-pagy attribute used by the pagy.js file
    def pagy_uikit_nav_js(pagy, id: nil, aria_label: nil, **vars)
      sequels = pagy.sequels(**vars)
      id      = %( id="#{id}") if id
      a       = pagy_anchor(pagy)
      tokens  = { 'before'  => uikit_prev_html(pagy, a),
                  'a'       => %(<li>#{a.(PAGE_TOKEN, LABEL_TOKEN)}</li>),
                  'current' => %(<li class="uk-active"><span role="link" aria-current="page" aria-disabled="true">#{
                                   LABEL_TOKEN}</span></li>),
                  'gap'     => %(<li class="uk-disabled"><span>#{pagy_t 'pagy.gap'}</span></li>),
                  'after'   => uikit_next_html(pagy, a) }

      %(<ul#{id} class="#{'pagy-rjs ' if sequels.size > 1}pagy-uikit nav-js uk-pagination uk-flex-center" role="navigation" #{
          nav_aria_label(pagy, aria_label:)} #{
          pagy_data(pagy, :nav, tokens, sequels, pagy.label_sequels(sequels))
        }></ul>)
    end

    # Javascript combo pagination for uikit: it returns a nav with a data-pagy attribute used by the pagy.js file
    def pagy_uikit_combo_nav_js(pagy, id: nil, aria_label: nil)
      id    = %( id="#{id}") if id
      a     = pagy_anchor(pagy)
      pages = pagy.pages

      page_input = %(<input name="page" type="number" min="1" max="#{pages}" value="#{pagy.page}" aria-current="page" ) <<
                   %(style="text-align: center; width: #{pages.to_s.length + 1}rem;">#{JSTools::A_TAG})

      %(<ul#{id} class="pagy-uikit combo-nav-js uk-button-group uk-pagination uk-flex-center" role="navigation" #{
          nav_aria_label(pagy, aria_label:)} #{
          pagy_data(pagy, :combo, pagy_url_for(pagy, PAGE_TOKEN))
        }>#{
          uikit_prev_html(pagy, a)
        }<li><label>#{
          pagy_t('pagy.combo_nav_js', page_input:, pages:)
        }</label></li>#{
          uikit_next_html(pagy, a)
        }</ul>)
    end

    private

    def uikit_prev_html(pagy, a)
      span = %(<span uk-pagination-previous></span>)
      if (p_prev = pagy.prev)
        %(<li>#{a.(p_prev, span, aria_label: pagy_t('pagy.aria_label.prev'))}</li>)
      else
        %(<li class="uk-disabled"><a role="link" aria-disabled="true" aria-label="#{
            pagy_t('pagy.aria_label.prev')}">#{span}</a></li>)
      end
    end

    def uikit_next_html(pagy, a)
      span = %(<span uk-pagination-next></span>)
      if (p_next = pagy.next)
        %(<li>#{a.(p_next, span, aria_label: pagy_t('pagy.aria_label.prev'))}</li>)
      else
        %(<li class="uk-disabled"><a role="link" aria-disabled="true" aria-label="#{
            pagy_t('pagy.aria_label.next')}">#{span}</a></li>)
      end
    end
  end
  Frontend.include UikitExtra
end
