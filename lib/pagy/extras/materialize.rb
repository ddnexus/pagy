# See the Pagy documentation: https://ddnexus.github.io/pagy/docs/extras/materialize
# frozen_string_literal: true

require 'pagy/extras/frontend_helpers'

class Pagy # :nodoc:
  # Frontend modules are specially optimized for performance.
  # The resulting code may not look very elegant, but produces the best benchmarks
  module MaterializeExtra
    # Pagination for materialize: it returns the html with the series of links to the pages
    def pagy_materialize_nav(pagy, pagy_id: nil, link_extra: '',
                             nav_aria_label: nil, nav_i18n_key: nil, **vars)
      p_id = %( id="#{pagy_id}") if pagy_id
      link = pagy_link_proc(pagy, link_extra:)

      html = +%(<div#{p_id} class="pagy-materialize-nav pagination" role="navigation" #{
                  nav_aria_label_attr(pagy, nav_aria_label, nav_i18n_key)}><ul class="pagination">)
      html << materialize_prev_html(pagy, link)
      pagy.series(**vars).each do |item| # series example: [1, :gap, 7, 8, "9", 10, 11, :gap, 36]
        html << case item
                when Integer
                  %(<li class="waves-effect">#{link.call(item)}</li>)
                when String
                  %(<li class="active"><a role="link" aria-current="page" aria-disabled="true">#{pagy.label_for(item)}</a></li>)
                when :gap
                  %(<li class="gap disabled"><a role="link" aria-disabled="true">#{pagy_t 'pagy.gap'}</a></li>)
                else
                  raise InternalError, "expected item types in series to be Integer, String or :gap; got #{item.inspect}"
                end
      end
      html << materialize_next_html(pagy, link)
      html << %(</ul></div>)
    end

    # Javascript pagination for materialize: it returns a nav and a JSON tag used by the pagy.js file
    def pagy_materialize_nav_js(pagy, pagy_id: nil, link_extra: '',
                                nav_aria_label: nil, nav_i18n_key: nil, **vars)
      sequels = pagy.sequels(**vars)
      p_id = %( id="#{pagy_id}") if pagy_id
      link = pagy_link_proc(pagy, link_extra:)

      tags = { 'before' => %(<ul class="pagination">#{materialize_prev_html pagy, link}),
               'link'   => %(<li class="waves-effect">#{link.call(PAGE_TOKEN, LABEL_TOKEN)}</li>),
               'active' => %(<li class="active"><a role="link" aria-current="page" aria-disabled="true">#{LABEL_TOKEN}</a></li>),
               'gap'    => %(<li class="gap disabled"><a role="link" aria-disabled="true">#{pagy_t 'pagy.gap'}</a></li>),
               'after'  => %(#{materialize_next_html pagy, link}</ul>) }

      %(<div#{p_id} class="#{'pagy-rjs ' if sequels.size > 1}pagy-materialize-nav-js" role="navigation" #{
          nav_aria_label_attr(pagy, nav_aria_label, nav_i18n_key)} #{
          pagy_data(pagy, :nav, tags, sequels, pagy.label_sequels(sequels))}></div>)
    end

    # Javascript combo pagination for materialize: it returns a nav and a JSON tag used by the pagy.js file
    def pagy_materialize_combo_nav_js(pagy, pagy_id: nil, link_extra: '',
                                      nav_aria_label: nil, nav_i18n_key: nil)
      p_id    = %( id="#{pagy_id}") if pagy_id
      link    = pagy_link_proc(pagy, link_extra:)
      p_page  = pagy.page
      p_pages = pagy.pages
      style   = ' style="vertical-align: middle"'
      input   = %(<input type="number" class="browser-default" min="1" max="#{p_pages}" value="#{
                    p_page}" style="text-align: center; width: #{p_pages.to_s.length + 1}rem;" aria-current="page">)

      html = %(<ul#{p_id} class="pagy-materialize-combo-nav-js pagination chip" role="navigation" #{
                 nav_aria_label_attr(pagy, nav_aria_label, nav_i18n_key)})
      %(#{html} style="padding-right: 0" #{
          pagy_data(pagy, :combo, pagy_marked_link(link))}>#{
          materialize_prev_html pagy, link, style}<li class="pagy-combo-input">#{
          pagy_t 'pagy.combo_nav_js', page_input: input, count: p_page, pages: p_pages}</li>#{
          materialize_next_html pagy, link, style}</ul>)
    end

    private

    def materialize_prev_html(pagy, link, style = '')
      if (p_prev = pagy.prev)
        %(<li class="waves-effect prev"#{style}>#{
            link.call(p_prev, '<i class="material-icons">chevron_left</i>', prev_aria_label_attr)}</li>)
      else
        %(<li class="prev disabled"#{style}><a role="link" aria-disabled="true" #{
            prev_aria_label_attr}><i class="material-icons">chevron_left</i></a></li>)
      end
    end

    def materialize_next_html(pagy, link, style = '')
      if (p_next = pagy.next)
        %(<li class="waves-effect next"#{style}>#{
            link.call(p_next, '<i class="material-icons">chevron_right</i>', next_aria_label_attr)}</li>)
      else
        %(<li class="next disabled"#{style}><a role="link" aria-disabled="true" #{
            next_aria_label_attr}><i class="material-icons">chevron_right</i></a></li>)
      end
    end
  end
  Frontend.prepend MaterializeExtra
end
