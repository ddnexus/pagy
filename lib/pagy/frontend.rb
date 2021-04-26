# See Pagy::Frontend API documentation: https://ddnexus.github.io/pagy/api/frontend
# frozen_string_literal: true

require 'yaml'

class Pagy

  PAGE_PLACEHOLDER = '__pagy_page__'  # string used for search and replace, hardcoded also in the pagy.js file

  # I18n static hash loaded at startup, used as default alternative to the i18n gem.
  # see https://ddnexus.github.io/pagy/api/frontend#i18n
  I18n = eval Pagy.root.join('locales', 'utils', 'i18n.rb').read #rubocop:disable Security/Eval

  module Helpers
    # This works with all Rack-based frameworks (Sinatra, Padrino, Rails, ...)
    def pagy_url_for(pagy, page, url=nil)
      pagy, page = Pagy.deprecated_order(pagy, page) if page.is_a?(Pagy)
      p_vars = pagy.vars
      params = request.GET.merge(p_vars[:params])
      params[p_vars[:page_param].to_s] = page
      query_string = "?#{Rack::Utils.build_nested_query(pagy_get_params(params))}" unless params.empty?
      "#{request.base_url if url}#{request.path}#{query_string}#{p_vars[:anchor]}"
    end

    # Sub-method called only by #pagy_url_for: here for easy customization of params by overriding
    def pagy_get_params(params) = params
  end

  # All the code here has been optimized for performance: it may not look very pretty
  # (as most code dealing with many long strings), but its performance makes it very sexy! ;)
  module Frontend

    include Helpers

    # Generic pagination: it returns the html with the series of links to the pages
    def pagy_nav(pagy, pagy_id: nil, link_extra: '')
      p_id   = %( id="#{pagy_id}") if pagy_id
      link   = pagy_link_proc(pagy, link_extra)
      p_prev = pagy.prev
      p_next = pagy.next

      html  = +%(<nav#{p_id} class="pagy-nav pagination" role="navigation" aria-label="pager">)
      html << if p_prev
                %(<span class="page prev">#{link.call p_prev, pagy_t('pagy.nav.prev'), 'aria-label="previous"'}</span> )
              else
                %(<span class="page prev disabled">#{pagy_t('pagy.nav.prev')}</span> )
              end
      pagy.series.each do |item|  # series example: [1, :gap, 7, 8, "9", 10, 11, :gap, 36]
        html << case item
                when Integer then %(<span class="page">#{link.call item}</span> )               # page link
                when String  then %(<span class="page active">#{item}</span> )                  # current page
                when :gap    then %(<span class="page gap">#{pagy_t('pagy.nav.gap')}</span> )   # page gap
                end
      end
      html << if p_next
                %(<span class="page next">#{link.call p_next, pagy_t('pagy.nav.next'), 'aria-label="next"'}</span>)
              else
                %(<span class="page next disabled">#{pagy_t('pagy.nav.next')}</span>)
              end
      html << %(</nav>)
    end

    # Return examples: "Displaying items 41-60 of 324 in total" of "Displaying Products 41-60 of 324 in total"
    def pagy_info(pagy, deprecated_item_name=nil, pagy_id: nil, item_name: nil, i18n_key: nil)
      p_id      = %( id="#{pagy_id}") if pagy_id
      item_name = Pagy.deprecated_arg(:item_name, deprecated_item_name, :item_name, item_name) if deprecated_item_name
      p_count = pagy.count
      key     = if    p_count.zero?   then 'pagy.info.no_items'
                elsif pagy.pages == 1 then 'pagy.info.single_page'
                else                       'pagy.info.multiple_pages'
                end

      %(<span#{p_id}>#{
      pagy_t key, item_name: item_name || pagy_t(i18n_key || pagy.vars[:i18n_key], count: p_count),
                  count: p_count, from: pagy.from, to: pagy.to
      }</span>)
    end

    # Returns a performance optimized proc to generate the HTML links
    # Benchmarked on a 20 link nav: it is ~22x faster and uses ~18x less memory than rails' link_to
    def pagy_link_proc(pagy, link_extra='')
      p_prev = pagy.prev
      p_next = pagy.next
      left, right = %(<a href="#{pagy_url_for pagy, PAGE_PLACEHOLDER}" #{pagy.vars[:link_extra]} #{link_extra}).split(PAGE_PLACEHOLDER, 2)
      lambda do |num, text=num, extra_attrs=''|
        %(#{left}#{num}#{right}#{ case num
                                  when p_prev then ' rel="prev"'
                                  when p_next then ' rel="next"'
                                  else             ''
                                  end } #{extra_attrs}>#{text}</a>)
      end
    end

    # Similar to I18n.t: just ~18x faster using ~10x less memory
    # (@pagy_locale explicitly initialized in order to avoid warning)
    def pagy_t(key, **opts)
      Pagy::I18n.t @pagy_locale||=nil, key, **opts
    end

  end
end
