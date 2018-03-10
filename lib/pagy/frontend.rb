# See Pagy::Frontend API documentation: https://ddnexus.github.io/pagy/api/frontend

require 'yaml'
class Pagy

  # All the code here has been optimized for performance: it may not look very pretty
  # (as most code dealing with many long strings), but its performance makes it very sexy! ;)
  module Frontend

    # Generic pagination: it returns the html with the series of links to the pages
    def pagy_nav(pagy)
      tags = []; link = pagy_link_proc(pagy)

      tags << (pagy.prev ? %(<span class="page prev">#{link.call pagy.prev, pagy_t('pagy.nav.prev'.freeze), 'aria-label="previous"'.freeze}</span>)
                         : %(<span class="page prev disabled">#{pagy_t('pagy.nav.prev'.freeze)}</span>))
      pagy.series.each do |item|  # series example: [1, :gap, 7, 8, "9", 10, 11, :gap, 36]
        tags << if    item.is_a?(Integer); %(<span class="page">#{link.call item}</span>)                    # page link
                elsif item.is_a?(String) ; %(<span class="page active">#{item}</span>)                       # current page
                elsif item == :gap       ; %(<span class="page gap">#{pagy_t('pagy.nav.gap'.freeze)}</span>) # page gap
                end
      end
      tags << (pagy.next ? %(<span class="page next">#{link.call pagy.next, pagy_t('pagy.nav.next'.freeze), 'aria-label="next"'.freeze}</span>)
                         : %(<span class="page next disabled">#{pagy_t('pagy.nav.next'.freeze)}</span>))
      %(<nav class="pagination" role="navigation" aria-label="pager">#{tags.join(' '.freeze)}</nav>)
    end


    # Pagination for bootstrap: it returns the html with the series of links to the pages
    def pagy_nav_bootstrap(pagy)
      tags = []; link = pagy_link_proc(pagy, 'class="page-link"'.freeze)

      tags << (pagy.prev ? %(<li class="page-item prev">#{link.call pagy.prev, pagy_t('pagy.nav.prev'.freeze), 'aria-label="previous"'.freeze}</li>)
                         : %(<li class="page-item prev disabled"><a href="#" class="page-link">#{pagy_t('pagy.nav.prev'.freeze)}</a></li>))
      pagy.series.each do |item| # series example: [1, :gap, 7, 8, "9", 10, 11, :gap, 36]
        tags << if    item.is_a?(Integer); %(<li class="page-item">#{link.call item}</li>)                                                               # page link
                elsif item.is_a?(String) ; %(<li class="page-item active">#{link.call item}</li>)                                                        # active page
                elsif item == :gap       ; %(<li class="page-item gap disabled"><a href="#" class="page-link">#{pagy_t('pagy.nav.gap'.freeze)}</a></li>) # page gap
                end
      end
      tags << (pagy.next ? %(<li class="page-item next">#{link.call pagy.next, pagy_t('pagy.nav.next'.freeze), 'aria-label="next"'.freeze}</li>)
                         : %(<li class="page-item next disabled"><a href="#" class="page-link">#{pagy_t('pagy.nav.next'.freeze)}</a></li>))
      %(<nav class="pagination" role="navigation" aria-label="pager"><ul class="pagination">#{tags.join}</ul></nav>)
    end


    # return examples: "Displaying items 41-60 of 324 in total"  or "Displaying Products 41-60 of 324 in total"
    def pagy_info(pagy, vars=nil)
      name = vars && vars[:item_name] || pagy_t(pagy.vars[:i18n_key] || 'pagy.info.item'.freeze, count: pagy.count)
      name = pagy_t('pagy.info.item'.freeze, count: pagy.count) if name.start_with?('translation missing:'.freeze)
      key  = pagy.pages == 1 ? 'single_page'.freeze : 'multiple_pages'.freeze
      pagy_t "pagy.info.#{key}", item_name: name, count: pagy.count, from: pagy.from, to: pagy.to
    end


    # this works with all Rack-based frameworks (Sinatra, Padrino, Rails, ...)
    def pagy_url_for(n)
      url    = File.join(request.script_name.to_s, request.path_info)
      params = request.GET.merge('page'.freeze => n.to_s)
      url << '?' << Rack::Utils.build_nested_query(pagy_get_params(params))
    end


    # sub-method called only by #pagy_url_for: here for easy customization of params by overriding
    def pagy_get_params(p) p end


    MARKER = "-pagy-#{'pagy'.hash}-".freeze

    # returns a specialized proc to generate the HTML links
    def pagy_link_proc(pagy, lx=''.freeze)  # "lx" means "link extra"
      p_prev, p_next, p_lx = pagy.prev, pagy.next, pagy.vars[:link_extra]
      a, b = %(<a href="#{pagy_url_for(MARKER)}"#{p_lx ? %( #{p_lx}) : ''.freeze}#{lx.empty? ? lx : %( #{lx})}).split(MARKER)
      -> (n, text=n, x=''.freeze) { "#{a}#{n}#{b}#{ if    n == p_prev ; ' rel="prev"'.freeze
                                                    elsif n == p_next ; ' rel="next"'.freeze
                                                    else                           ''.freeze end }#{x.empty? ? x : %( #{x})}>#{text}</a>" }
    end


    hash = YAML.load_file Vars[:i18n_file] || Pagy.root.join('locales', 'pagy.yml')
    I18N = hash[hash.keys.first].freeze

    # Similar to I18n.t for interpolation and pluralization, with the following constraints:
    # - the path/keys option is supported only in dot-separated string or symbol format
    # - the :scope and :default options are not supported
    # - no exception are raised: the errors are returned as translated strings
    def pagy_t(path, vars={})
      value = I18N.dig(*path.to_s.split('.'.freeze))
      if value.is_a?(Hash)
        vars.has_key?(:count) or return value
        plural = (Vars[:i18n_plurals] ||= -> (c) {c==0 && 'zero' || c==1 && 'one' || 'other'}).call(vars[:count])
        value.has_key?(plural) or return %(invalid pluralization data: "#{path}" cannot be used with count: #{vars[:count]}; key "#{plural}" is missing.)
        value = value[plural]
      end
      value or return %(translation missing: "#{path}")
      sprintf value, Hash.new{|h,k| "%{#{k}}"}.merge!(vars)    # interpolation
    end

  end
end
