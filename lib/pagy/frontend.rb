# See Pagy::Frontend API documentation: https://ddnexus.github.io/pagy/api/frontend
# frozen_string_literal: true

require 'yaml'

class Pagy

  # All the code here has been optimized for performance: it may not look very pretty
  # (as most code dealing with many long strings), but its performance makes it very sexy! ;)
  module Frontend

    # Generic pagination: it returns the html with the series of links to the pages
    def pagy_nav(pagy)
      link, p_prev, p_next = pagy_link_proc(pagy), pagy.prev, pagy.next

      html = +(p_prev ? %(<span class="page prev">#{link.call p_prev, pagy_t('pagy.nav.prev'), 'aria-label="previous"'}</span> )
                      : %(<span class="page prev disabled">#{pagy_t('pagy.nav.prev')}</span> ))
      pagy.series.each do |item|  # series example: [1, :gap, 7, 8, "9", 10, 11, :gap, 36]
        html << if    item.is_a?(Integer); %(<span class="page">#{link.call item}</span> )               # page link
                elsif item.is_a?(String) ; %(<span class="page active">#{item}</span> )                  # current page
                elsif item == :gap       ; %(<span class="page gap">#{pagy_t('pagy.nav.gap')}</span> )   # page gap
                end
      end
      html << (p_next ? %(<span class="page next">#{link.call p_next, pagy_t('pagy.nav.next'), 'aria-label="next"'}</span>)
                      : %(<span class="page next disabled">#{pagy_t('pagy.nav.next')}</span>))
      %(<nav class="pagy-nav pagination" role="navigation" aria-label="pager">#{html}</nav>)
    end

    # Return examples: "Displaying items 41-60 of 324 in total"  or "Displaying Products 41-60 of 324 in total"
    def pagy_info(pagy)
      name = pagy_t(pagy.vars[:item_path], count: pagy.count)
      path = pagy.pages == 1 ? 'pagy.info.single_page' : 'pagy.info.multiple_pages'
      pagy_t(path, item_name: name, count: pagy.count, from: pagy.from, to: pagy.to)
    end

    # This works with all Rack-based frameworks (Sinatra, Padrino, Rails, ...)
    def pagy_url_for(page, pagy)
      p_vars = pagy.vars; params = request.GET.merge(p_vars[:page_param].to_s => page).merge!(p_vars[:params])
      "#{request.path}?#{Rack::Utils.build_nested_query(pagy_get_params(params))}#{p_vars[:anchor]}"
    end

    # Sub-method called only by #pagy_url_for: here for easy customization of params by overriding
    def pagy_get_params(params) params end

    MARKER = "-pagy-#{'pagy'.hash}-"

    # Returns a performance optimized proc to generate the HTML links
    # Benchmarked on a 20 link nav: it is ~27x faster and uses ~13x less memory than rails' link_to
    def pagy_link_proc(pagy, link_extra='')
      p_prev, p_next = pagy.prev, pagy.next
      a, b = %(<a href="#{pagy_url_for(MARKER, pagy)}" #{pagy.vars[:link_extra]} #{link_extra}).split(MARKER, 2)
      -> (n, text=n, extra='') { "#{a}#{n}#{b}#{ if    n == p_prev ; ' rel="prev"'
                                                 elsif n == p_next ; ' rel="next"'
                                                 else                           '' end } #{extra}>#{text}</a>" }
    end

    # Pagy::Frontend::I18N
    def (I18N = {data:{}}).load(file:Pagy.root.join('locales', 'en.yml'), language: 'en')
      self[:data]   = YAML.load_file(file)[language]
      self[:plural] = eval(Pagy.root.join('locales', 'plurals.rb').read)[language] #rubocop:disable Security/Eval
    end; I18N.load

    # Similar to I18n.t for streamlined interpolation and pluralization but without dynamic translation.
    # It is specialized for Pagy and 5x faster than I18n.t (see https://ddnexus.github.io/pagy/api/frontend#i18n)
    # See also https://ddnexus.github.io/pagy/extras/i18n if you need to use the standard I18n gem instead
    def pagy_t(path, vars={})
      value = I18N[:data].dig(*path.split('.')) or return %(translation missing: "#{path}")
      if value.is_a?(Hash)
        vars.key?(:count) or return value
        plural = I18N[:plural].call(vars[:count])
        value.key?(plural) or return %(invalid pluralization data: "#{path}" cannot be used with count: #{vars[:count]}; key "#{plural}" is missing.)
        value = value[plural] or return %(translation missing: "#{path}")
      end
      sprintf value, Hash.new{|_,k| "%{#{k}}"}.merge!(vars)    # interpolation
    end

  end
end
