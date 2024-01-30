# See the Pagy documentation: https://ddnexus.github.io/pagy/docs/extras/bulma
# frozen_string_literal: true

require 'pagy/extras/frontend_helpers'

class Pagy # :nodoc:
  DEFAULT[:bulma_nav_classes] = 'is-centered'

  # Frontend modules are specially optimized for performance.
  # The resulting code may not look very elegant, but produces the best benchmarks
  module BulmaExtra
    # Pagination for bulma: it returns the html with the series of links to the pages
    def pagy_bulma_nav(pagy, pagy_id: nil, link_extra: '',
                       nav_aria_label: nil, nav_i18n_key: nil, **vars)
      p_id = %( id="#{pagy_id}") if pagy_id
      link = pagy_link_proc(pagy, link_extra:)

      html = +%(<nav#{p_id} class="pagy-bulma-nav pagination #{DEFAULT[:bulma_nav_classes]}" #{
                  nav_aria_label(pagy, nav_aria_label, nav_i18n_key)}>)
      html << bulma_prev_next_html(pagy, link)
      html << %(<ul class="pagination-list">)
      pagy.series(**vars).each do |item| # series example: [1, :gap, 7, 8, "9", 10, 11, :gap, 36]
        html << case item
                when Integer
                  %(<li>#{link.call(item, pagy.label_for(item), %(class="pagination-link"))}</li>)
                when String
                  %(<li>#{link.call(item, pagy.label_for(item), %(class="pagination-link is-current"))}</li>)
                when :gap
                  %(<li><span class="pagination-ellipsis">#{pagy_t 'pagy.gap'}</span></li>)
                else raise InternalError, "expected item types in series to be Integer, String or :gap; got #{item.inspect}"
                end
      end
      html << %(</ul></nav>)
    end

    # Javascript pagination for bulma: it returns a nav and a JSON tag used by the Pagy.nav javascript
    def pagy_bulma_nav_js(pagy, pagy_id: nil, link_extra: '',
                          nav_aria_label: nil, nav_i18n_key: nil, **vars)
      sequels = pagy.sequels(**vars)
      p_id = %( id="#{pagy_id}") if pagy_id
      link = pagy_link_proc(pagy, link_extra:)
      tags = { 'before' => %(#{bulma_prev_next_html(pagy, link)}<ul class="pagination-list">),
               'link'   => %(<li>#{link.call(PAGE_PLACEHOLDER, LABEL_PLACEHOLDER, %(class="pagination-link"))}</li>),
               'active' => %(<li>#{link.call(PAGE_PLACEHOLDER, LABEL_PLACEHOLDER, %(class="pagination-link is-current"))}</li>),
               'gap'    => %(<li><span class="pagination-ellipsis">#{pagy_t 'pagy.gap'}</span></li>),
               'after'  => '</ul>' }

      %(<nav#{p_id} class="#{'pagy-rjs ' if sequels.size > 1}pagy-bulma-nav-js pagination #{DEFAULT[:bulma_nav_classes]}" #{
        nav_aria_label(pagy, nav_aria_label, nav_i18n_key)}#{
        pagy_data(pagy, :nav, tags, sequels, pagy.label_sequels(sequels))}></nav>)
    end

    # Javascript combo pagination for bulma: it returns a nav and a JSON tag used by the pagy.js file
    def pagy_bulma_combo_nav_js(pagy, pagy_id: nil, link_extra: '',
                                nav_aria_label: nil, nav_i18n_key: nil)
      p_id    = %( id="#{pagy_id}") if pagy_id
      link    = pagy_link_proc(pagy, link_extra:)
      p_page  = pagy.page
      p_pages = pagy.pages
      input   = %(<input class="input" type="number" min="1" max="#{p_pages}" value="#{
                    p_page}" style="padding: 0; text-align: center; width: #{
                    p_pages.to_s.length + 1}rem; margin:0 0.3rem;" aria-current="page">)

      html = %(<nav#{p_id} class="pagy-bulma-combo-nav-js #{DEFAULT[:bulma_nav_classes]}" #{
                nav_aria_label(pagy, nav_aria_label, nav_i18n_key)}>)
      %(#{html}<div class="field is-grouped is-grouped-centered" role="group" #{
          pagy_data(pagy, :combo, pagy_marked_link(link))}>#{
          if (p_prev  = pagy.prev)
            %(<p class="control">#{link.call(p_prev, pagy_t('pagy.prev'), %(class="button" #{prev_aria_label}))}</p>)
          else
            %(<p class="control"><a class="button" disabled aria-disabled="true" #{
                prev_aria_label}>#{pagy_t 'pagy.prev'}</a></p>)
          end
        }<div class="pagy-combo-input control level is-mobile">#{
          pagy_t 'pagy.combo_nav_js', page_input: input, count: p_page, pages: p_pages}</div>#{
          if (p_next  = pagy.next)
            %(<p class="control">#{link.call(p_next, pagy_t('pagy.next'), %(class="button" #{next_aria_label}))}</p>)
          else
            %(<p class="control"><a class="button" disabled aria-disabled="true"#{
                next_aria_label}>#{pagy_t 'pagy.next'}</a></p>)
          end
        }</div></nav>)
    end

    private

    def bulma_prev_next_html(pagy, link)
      html = +if (p_prev = pagy.prev)
                link.call(p_prev, pagy_t('pagy.prev'), %(#{prev_aria_label} class="pagination-previous"))
              else
                %(<a class="pagination-previous" disabled aria-disabled="true" #{
                    prev_aria_label}>#{pagy_t 'pagy.prev'}</a>)
              end
      html << if (p_next = pagy.next)
                link.call(p_next, pagy_t('pagy.next'), %(#{next_aria_label} class="pagination-next"))
              else
                %(<a class="pagination-next" disabled aria-disabled="true" #{
                    next_aria_label}>#{pagy_t('pagy.next')}</a>)
              end
    end
  end
  Frontend.prepend BulmaExtra
end
