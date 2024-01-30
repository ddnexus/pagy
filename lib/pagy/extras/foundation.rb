# See the Pagy documentation: https://ddnexus.github.io/pagy/docs/extras/foundation
# frozen_string_literal: true

require 'pagy/extras/frontend_helpers'

class Pagy # :nodoc:
  # Frontend modules are specially optimized for performance.
  # The resulting code may not look very elegant, but produces the best benchmarks
  module FoundationExtra
    # Pagination for Foundation: it returns the html with the series of links to the pages
    def pagy_foundation_nav(pagy, pagy_id: nil, link_extra: '',
                            nav_aria_label: nil, nav_i18n_key: nil, **vars)
      p_id = %( id="#{pagy_id}") if pagy_id
      link = pagy_link_proc(pagy, link_extra:)

      html = +%(<nav#{p_id} class="pagy-foundation-nav" #{
                 nav_aria_label(pagy, nav_aria_label, nav_i18n_key)}><ul class="pagination">)
      html << foundation_prev_html(pagy, link)
      pagy.series(**vars).each do |item| # series example: [1, :gap, 7, 8, "9", 10, 11, :gap, 36]
        html << case item
                when Integer
                  %(<li>#{link.call item}</li>)
                when String
                  %(<li class="current" role="link" aria-current="page" aria-disabled="true">#{pagy.label_for(item)}</li>)
                when :gap
                  %(<li class="ellipsis gap"></li>)
                else
                  raise InternalError, "expected item types in series to be Integer, String or :gap; got #{item.inspect}"
                end
      end
      html << pagy_foundation_next_html(pagy, link)
      html << %(</ul></nav>)
    end

    # Javascript pagination for foundation: it returns a nav and a JSON tag used by the pagy.js file
    def pagy_foundation_nav_js(pagy, pagy_id: nil, link_extra: '',
                               nav_aria_label: nil, nav_i18n_key: nil, **vars)
      sequels = pagy.sequels(**vars)
      p_id = %( id="#{pagy_id}") if pagy_id
      link = pagy_link_proc(pagy, link_extra:)
      tags = { 'before' => %(<ul class="pagination">#{foundation_prev_html pagy, link}),
               'link'   => %(<li>#{link.call(PAGE_PLACEHOLDER, LABEL_PLACEHOLDER)}</li>),
               'active' => %(<li class="current" role="link" aria-current="page" aria-disabled="true">#{LABEL_PLACEHOLDER}</li>),
               'gap'    => %(<li class="ellipsis gap"></li>),
               'after'  => %(#{pagy_foundation_next_html pagy, link}</ul>) }

      %(<nav#{p_id} class="#{'pagy-rjs ' if sequels.size > 1}pagy-foundation-nav-js" #{
          nav_aria_label(pagy, nav_aria_label, nav_i18n_key)} #{
          pagy_data(pagy, :nav, tags, sequels, pagy.label_sequels(sequels))}></nav>)
    end

    # Javascript combo pagination for Foundation: it returns a nav and a JSON tag used by the pagy.js file
    def pagy_foundation_combo_nav_js(pagy, pagy_id: nil, link_extra: '',
                                     nav_aria_label: nil, nav_i18n_key: nil)
      p_id    = %( id="#{pagy_id}") if pagy_id
      link    = pagy_link_proc(pagy, link_extra:)
      p_page  = pagy.page
      p_pages = pagy.pages
      input   = %(<input class="input-group-field cell shrink" type="number" min="1" max="#{
                    p_pages}" value="#{p_page}" style="width: #{
                    p_pages.to_s.length + 1}rem; padding: 0 0.3rem; margin: 0 0.3rem;" aria-current="page">)

      %(<nav#{p_id} class="pagy-foundation-combo-nav-js" #{
          nav_aria_label(pagy, nav_aria_label, nav_i18n_key)}><div class="input-group" #{
          pagy_data(pagy, :combo, pagy_marked_link(link))}>#{
          if (p_prev = pagy.prev)
            link.call(p_prev, pagy_t('pagy.prev'),
                      %(style="margin-bottom: 0" class="prev button primary" #{prev_aria_label}))
          else
            %(<a style="margin-bottom: 0" class="prev button primary disabled" role="link" aria-disabled="true" #{
                prev_aria_label}>#{pagy_t('pagy.prev')}</a>)
          end
        }#{
          pagy_t('pagy.combo_nav_js', page_input: input, count: p_page, pages: p_pages)
          .sub!('<label>', '<label class="input-group-label">')}#{ # add the class to the official dictionary string
          if (p_next = pagy.next)
            link.call(p_next, pagy_t('pagy.next'),
                      %(style="margin-bottom: 0" class="next button primary" #{next_aria_label}))
          else
            %(<a style="margin-bottom: 0" class="next button primary disabled" role="link" aria-disabled="true" #{
                next_aria_label}>#{pagy_t 'pagy.next'}</a>)
          end
        }</div></nav>)
    end

    private

    def foundation_prev_html(pagy, link)
      if (p_prev = pagy.prev)
        %(<li class="prev">#{link.call(p_prev, pagy_t('pagy.prev'), prev_aria_label)}</li>)
      else
        %(<li class="prev disabled" role="link" aria-disabled="true" #{prev_aria_label}>#{pagy_t('pagy.prev')}</li>)
      end
    end

    def pagy_foundation_next_html(pagy, link)
      if (p_next = pagy.next)
        %(<li class="next">#{link.call(p_next, pagy_t('pagy.next'), next_aria_label)}</li>)
      else
        %(<li class="next disabled" role="link" aria-disabled="true" #{next_aria_label}>#{pagy_t('pagy.next')}</li>)
      end
    end
  end
  Frontend.prepend FoundationExtra
end
