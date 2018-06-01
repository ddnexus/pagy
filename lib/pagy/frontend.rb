# See Pagy::Frontend API documentation: https://ddnexus.github.io/pagy/api/frontend

require 'yaml'

class Pagy

  # All the code here has been optimized for performance: it may not look very pretty
  # (as most code dealing with many long strings), but its performance makes it very sexy! ;)
  module Frontend

    # Generic pagination: it returns the html with the series of links to the pages
    def pagy_nav(pagy)
      tags = ''; link = pagy_link_proc(pagy)

      tags << (pagy.prev ? %(<span class="page prev">#{link.call pagy.prev, pagy_t('pagy.nav.prev'.freeze), 'aria-label="previous"'.freeze}</span> )
                         : %(<span class="page prev disabled">#{pagy_t('pagy.nav.prev'.freeze)}</span> ))
      pagy.series.each do |item|  # series example: [1, :gap, 7, 8, "9", 10, 11, :gap, 36]
        tags << if    item.is_a?(Integer); %(<span class="page">#{link.call item}</span> )                    # page link
                elsif item.is_a?(String) ; %(<span class="page active">#{item}</span> )                       # current page
                elsif item == :gap       ; %(<span class="page gap">#{pagy_t('pagy.nav.gap'.freeze)}</span> ) # page gap
                end
      end
      tags << (pagy.next ? %(<span class="page next">#{link.call pagy.next, pagy_t('pagy.nav.next'.freeze), 'aria-label="next"'.freeze}</span>)
                         : %(<span class="page next disabled">#{pagy_t('pagy.nav.next'.freeze)}</span>))
      %(<nav class="pagy-nav pagination" role="navigation" aria-label="pager">#{tags}</nav>)
    end


    # return examples: "Displaying items 41-60 of 324 in total"  or "Displaying Products 41-60 of 324 in total"
    def pagy_info(pagy)
      name = pagy_t(pagy.vars[:item_path] || 'pagy.info.item_name'.freeze, count: pagy.count)
      key  = pagy.pages == 1 ? 'single_page'.freeze : 'multiple_pages'.freeze
      pagy_t("pagy.info.#{key}", item_name: name, count: pagy.count, from: pagy.from, to: pagy.to)
    end


    # this works with all Rack-based frameworks (Sinatra, Padrino, Rails, ...)
    def pagy_url_for(page, pagy)
      params = request.GET.merge(pagy.vars[:page_param] => page).merge!(pagy.vars[:params])
      "#{request.path}?#{Rack::Utils.build_nested_query(pagy_get_params(params))}#{pagy.vars[:anchor]}"
    end


    # sub-method called only by #pagy_url_for: here for easy customization of params by overriding
    def pagy_get_params(params) params end


    MARKER = "-pagy-#{'pagy'.hash}-".freeze

    # returns a specialized proc to generate the HTML links
    def pagy_link_proc(pagy, lx=''.freeze)  # "lx" means "link extra"
      p_prev, p_next, p_lx = pagy.prev, pagy.next, pagy.vars[:link_extra]
      a, b = %(<a href="#{pagy_url_for(MARKER, pagy)}"#{p_lx ? %( #{p_lx}) : ''.freeze}#{lx.empty? ? lx : %( #{lx})}).split(MARKER)
      -> (n, text=n, x=''.freeze) { "#{a}#{n}#{b}#{ if    n == p_prev ; ' rel="prev"'.freeze
                                                    elsif n == p_next ; ' rel="next"'.freeze
                                                    else                           ''.freeze end }#{x.empty? ? x : %( #{x})}>#{text}</a>" }
    end


    # Pagy::Frontend::I18N constant
    zero_one = [:zero, :one]; I18N = { plurals: -> (c) {(zero_one[c] || :other).to_s.freeze}, data: {}}
    def I18N.load_file(file) I18N[:data].replace(YAML.load_file(file).first[1]) end
    I18N[:data] = I18N.load_file(Pagy.root.join('locales', 'pagy.yml'))

    # Similar to I18n.t for interpolation and pluralization but without translation
    # Use only for single-language apps: it is specialized for pagy and 5x faster than I18n.t
    # See also https://ddnexus.github.io/pagy/extras/i18n to use the standard I18n gem instead
    def pagy_t(path, vars={})
      value = I18N[:data].dig(*path.to_s.split('.'.freeze)) or return %(translation missing: "#{path}")
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
