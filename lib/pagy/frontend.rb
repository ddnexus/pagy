# See Pagy::Frontend API documentation: https://ddnexus.github.io/pagy/api/frontend

require 'yaml'

class Pagy

  # All the code here has been optimized for performance: it may not look very pretty
  # (as most code dealing with many long strings), but its performance makes it very sexy! ;)
  module Frontend

    # Generic pagination: it returns the html with the series of links to the pages
    def pagy_nav(pagy)
      tags, link, p_prev, p_next = '', pagy_link_proc(pagy), pagy.prev, pagy.next

      tags << (p_prev ? %(<span class="page prev">#{link.call p_prev, pagy_t('pagy.nav.prev'.freeze), 'aria-label="previous"'.freeze}</span> )
                      : %(<span class="page prev disabled">#{pagy_t('pagy.nav.prev'.freeze)}</span> ))
      pagy.series.each do |item|  # series example: [1, :gap, 7, 8, "9", 10, 11, :gap, 36]
        tags << if    item.is_a?(Integer); %(<span class="page">#{link.call item}</span> )                    # page link
                elsif item.is_a?(String) ; %(<span class="page active">#{item}</span> )                       # current page
                elsif item == :gap       ; %(<span class="page gap">#{pagy_t('pagy.nav.gap'.freeze)}</span> ) # page gap
                end
      end
      tags << (p_next ? %(<span class="page next">#{link.call p_next, pagy_t('pagy.nav.next'.freeze), 'aria-label="next"'.freeze}</span>)
                      : %(<span class="page next disabled">#{pagy_t('pagy.nav.next'.freeze)}</span>))
      %(<nav class="pagy-nav pagination" role="navigation" aria-label="pager">#{tags}</nav>)
    end


    # return examples: "Displaying items 41-60 of 324 in total"  or "Displaying Products 41-60 of 324 in total"
    def pagy_info(pagy)
      name = pagy_t(pagy.vars[:item_path], count: pagy.count)
      path = pagy.pages == 1 ? 'pagy.info.single_page'.freeze : 'pagy.info.multiple_pages'.freeze
      pagy_t(path, item_name: name, count: pagy.count, from: pagy.from, to: pagy.to)
    end


    # this works with all Rack-based frameworks (Sinatra, Padrino, Rails, ...)
    def pagy_url_for(page, pagy)
      p_vars = pagy.vars; params = request.GET.merge(p_vars[:page_param] => page, **p_vars[:params])
      "#{request.path}?#{Rack::Utils.build_nested_query(pagy_get_params(params))}#{p_vars[:anchor]}"
    end


    # sub-method called only by #pagy_url_for: here for easy customization of params by overriding
    def pagy_get_params(params) params end


    MARKER = "-pagy-#{'pagy'.hash}-".freeze

    # returns a performance optimized proc to generate the HTML links
    def pagy_link_proc(pagy, link_extra=''.freeze)
      p_prev, p_next = pagy.prev, pagy.next
      a, b = %(<a href="#{pagy_url_for(MARKER, pagy)}" #{pagy.vars[:link_extra]} #{link_extra}).split(MARKER, 2)
      -> (n, text=n, extra=''.freeze) { "#{a}#{n}#{b}#{ if    n == p_prev ; ' rel="prev"'.freeze
                                                        elsif n == p_next ; ' rel="next"'.freeze
                                                        else                           ''.freeze end } #{extra}>#{text}</a>" }
    end

    # Pagy::Frontend::I18N constant
    I18N_DATA = YAML.load_file(Pagy.root.join('locales', 'pagy.yml')).first[1]
    zero_one  = ['zero'.freeze, 'one'.freeze]; I18N = { plurals: -> (c) {zero_one[c] || 'other'.freeze}}
    def I18N.load_file(file) I18N_DATA.replace(YAML.load_file(file).first[1]) end

    # Similar to I18n.t for interpolation and pluralization but without translation
    # Use only for single-language apps: it is specialized for pagy and 5x faster than I18n.t
    # See also https://ddnexus.github.io/pagy/extras/i18n to use the standard I18n gem instead
    def pagy_t(path, vars={})
      value = I18N_DATA.dig(*path.to_s.split('.'.freeze)) or return %(translation missing: "#{path}")
      if value.is_a?(Hash)
        vars.key?(:count) or return value
        plural = I18N[:plurals].call(vars[:count])
        value.key?(plural) or return %(invalid pluralization data: "#{path}" cannot be used with count: #{vars[:count]}; key "#{plural}" is missing.)
        value = value[plural] or return %(translation missing: "#{path}")
      end
      sprintf value, Hash.new{|_,k| "%{#{k}}"}.merge!(vars)    # interpolation
    end

  end
end
