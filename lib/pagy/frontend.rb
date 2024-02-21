# See Pagy::Frontend API documentation: https://ddnexus.github.io/pagy/docs/api/frontend
# frozen_string_literal: true

require 'pagy/url_helpers'
require 'pagy/i18n'

class Pagy
  # Used for search and replace, hardcoded also in the pagy.js file
  PAGE_PLACEHOLDER  = '__pagy_page__'
  LABEL_PLACEHOLDER = '__pagy_label__'

  # Frontend modules are specially optimized for performance.
  # The resulting code may not look very elegant, but produces the best benchmarks
  module Frontend
    include UrlHelpers

    # Generic pagination: it returns the html with the series of links to the pages
    def pagy_nav(pagy, pagy_id: nil, link_extra: '',
                 nav_aria_label: nil, nav_i18n_key: nil, **vars)
      p_id = %( id="#{pagy_id}") if pagy_id
      link = pagy_link_proc(pagy, link_extra:)

      html = +%(<nav#{p_id} class="pagy pagy-nav pagination" #{nav_aria_label_attr(pagy, nav_aria_label, nav_i18n_key)}>)
      html << prev_html(pagy, link)
      pagy.series(**vars).each do |item| # series example: [1, :gap, 7, 8, "9", 10, 11, :gap, 36]
        html << case item
                when Integer
                  %(<span class="page">#{link.call(item)}</span>)
                when String
                  %(<span class="page active">) +
                  %(<a role="link" aria-disabled="true" aria-current="page">#{pagy.label_for(item)}</a></span>)
                when :gap
                  %(<span class="page gap">#{pagy_t('pagy.gap')}</span>)
                else
                  raise InternalError, "expected item types in series to be Integer, String or :gap; got #{item.inspect}"
                end
      end
      html << %(#{next_html(pagy, link)}</nav>)
    end

    # Return examples: "Displaying items 41-60 of 324 in total" or "Displaying Products 41-60 of 324 in total"
    def pagy_info(pagy, pagy_id: nil, item_name: nil, item_i18n_key: nil)
      p_id    = %( id="#{pagy_id}") if pagy_id
      p_count = pagy.count
      key     = if    p_count.zero?   then 'pagy.info.no_items'
                elsif pagy.pages == 1 then 'pagy.info.single_page'
                else                       'pagy.info.multiple_pages' # rubocop:disable Lint/ElseLayout
                end

      %(<span#{p_id} class="pagy-info">#{
          pagy_t key, item_name: item_name || pagy_t(item_i18n_key || pagy.vars[:item_i18n_key], count: p_count),
                      count: p_count, from: pagy.from, to: pagy.to
        }</span>)
    end

    # Return a performance optimized lambda to generate the HTML links
    # Benchmarked on a 20 link nav: it is ~22x faster and uses ~18x less memory than rails' link_to
    def pagy_link_proc(pagy, link_extra: '')
      p_prev      = pagy.prev
      p_next      = pagy.next
      p_page      = pagy.page.to_s
      left, right = %(<a href="#{pagy_url_for(pagy, PAGE_PLACEHOLDER)}" #{
                        pagy.vars[:link_extra]} #{link_extra}).split(PAGE_PLACEHOLDER, 2)
      # lambda used by all the helpers
      lambda do |page, text = pagy.label_for(page), extra_attrs = ''|
        %(#{left}#{page}#{right}#{ case page
                                   when p_prev then ' rel="prev"'
                                   when p_next then ' rel="next"'
                                   when p_page then ' aria-disabled="true" aria-current="page"'
                                   else             ''
                                   end } #{extra_attrs}>#{text}</a>)
      end
    end

    # Similar to I18n.t: just ~18x faster using ~10x less memory
    # (@pagy_locale explicitly initialized in order to avoid warning)
    def pagy_t(key, opts = {})
      Pagy::I18n.translate(@pagy_locale ||= nil, key, opts)
    end

    private

    def nav_aria_label_attr(pagy, nav_aria_label, nav_i18n_key, count: pagy.pages)
      nav_aria_label ||= pagy_t(nav_i18n_key || pagy.vars[:nav_i18n_key], count:)
      %(aria-label="#{nav_aria_label}")
    end

    def prev_aria_label_attr
      %(aria-label="#{pagy_t('pagy.aria_label.prev')}")
    end

    def next_aria_label_attr
      %(aria-label="#{pagy_t('pagy.aria_label.next')}")
    end

    def prev_html(pagy, link, text: pagy_t('pagy.prev'))
      if (p_prev = pagy.prev)
        %(<span class="page prev">#{link.call(p_prev, text, prev_aria_label_attr)}</span>)
      else
        %(<span class="page prev disabled"><a role="link" aria-disabled="true" #{
             prev_aria_label_attr}>#{text}</a></span>)
      end
    end

    def next_html(pagy, link, text: pagy_t('pagy.next'))
      if (p_next = pagy.next)
        %(<span class="page next">#{link.call(p_next, text, next_aria_label_attr)}</span>)
      else
        %(<span class="page next disabled"><a role="link" aria-disabled="true" #{
            next_aria_label_attr}>#{text}</a></span>)
      end
    end
  end
end
