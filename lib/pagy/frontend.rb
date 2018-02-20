require 'yaml'
class Pagy

  # This module supplies a few methods to deal with the navigation aspect of the pagination.
  # You will usually include it in some helper module, eventually overriding the #pagy_url_for
  # in order to fit its behavior with your app needs (e.g.: removing and adding some param or
  # allowing fancy routes, etc.)
  #
  # All the code here has been optimized for performance: it may not look very pretty
  # (as most code dealing with many long strings), but its performance makes it very sexy! ;)
  module Frontend

    # Generic pagination: it returns the html with the series of links to the pages
    def pagy_nav(pagy, opts=nil)
      opts = opts ? pagy.opts.merge(opts) : pagy.opts
      link = pagy_link_proc(pagy)
      tags = []

      tags << (pagy.prev ? %(<span class="page prev">#{link.call pagy.prev, pagy_t('pagy.nav.prev'.freeze), 'aria-label="previous"'.freeze}</span>)
                         : %(<span class="page prev disabled">#{pagy_t('pagy.nav.prev'.freeze)}</span>))
      pagy.series.each do |item|  # series example: [1, :gap, 7, 8, "9", 10, 11, :gap, 36]
        tags << case item
                  when Integer; %(<span class="page">#{link.call item}</span>)                    # page link
                  when String ; %(<span class="page active">#{item}</span>)                       # current page
                  when :gap   ; %(<span class="page gap">#{pagy_t('pagy.nav.gap'.freeze)}</span>) # page gap
                end
      end
      tags << (pagy.next ? %(<span class="page next">#{link.call pagy.next, pagy_t('pagy.nav.next'.freeze), 'aria-label="next"'.freeze}</span>)
                         : %(<span class="page next disabled">#{pagy_t('pagy.nav.next'.freeze)}</span>))
      %(<nav class="#{opts[:class]||'pagination'.freeze}" role="navigation" aria-label="pager">#{tags.join(opts[:separator]||' '.freeze)}</nav>)
    end


    # Pagination for bootstrap: it returns the html with the series of links to the pages
    def pagy_nav_bootstrap(pagy, opts=nil)
      opts = opts ? pagy.opts.merge(opts) : pagy.opts
      link = pagy_link_proc(pagy, 'class="page-link"'.freeze)
      tags = []

      tags << (pagy.prev ? %(<li class="page-item prev">#{link.call pagy.prev, pagy_t('pagy.nav.prev'.freeze), 'aria-label="previous"'.freeze}</li>)
                         : %(<li class="page-item prev disabled"><a href="#" class="page-link">#{pagy_t('pagy.nav.prev'.freeze)}</a></li>))
      pagy.series.each do |item| # series example: [1, :gap, 7, 8, "9", 10, 11, :gap, 36]
        tags << case item
                  when Integer; %(<li class="page-item">#{link.call item}</li>)                                                               # page link
                  when String ; %(<li class="page-item active">#{link.call item}</li>)                                                        # active page
                  when :gap   ; %(<li class="page-item gap disabled"><a href="#" class="page-link">#{pagy_t('pagy.nav.gap'.freeze)}</a></li>) # page gap
                end
      end
      tags << (pagy.next ? %(<li class="page-item next">#{link.call pagy.next, pagy_t('pagy.nav.next'.freeze), 'aria-label="next"'.freeze}</li>)
                         : %(<li class="page-item next disabled"><a href="#" class="page-link">#{pagy_t('pagy.nav.next'.freeze)}</a></li>))
      %(<nav class="#{opts[:class]||'pagination'.freeze}" role="navigation" aria-label="pager"><ul class="pagination">#{tags.join}</ul></nav>)
    end


    # return examples: "Displaying items 41-60 of 324 in total"  or "Displaying Products 41-60 of 324 in total"
    def pagy_info(pagy, vars=nil)
      name = vars && vars[:item_name] || pagy_t(pagy.opts[:i18n_key] || 'pagy.info.item'.freeze, count: pagy.count)
      name = pagy_t('pagy.info.item'.freeze, count: pagy.count) if name.start_with?('translation missing:'.freeze)
      key  = pagy.pages == 1 ? 'single_page'.freeze : 'multiple_pages'.freeze
      pagy_t "pagy.info.#{key}", item_name: name, count: pagy.count, from: pagy.from, to: pagy.to
    end


    # this works with all Rack-based frameworks (Sinatra, Padrino, Rails, ...)
    def pagy_url_for(n)
      url    = File.join(request.script_name.to_s, request.path_info)
      params = request.GET.merge('page' => n.to_s)
      url << '?' << Rack::Utils.build_nested_query(params)
    end


    # The :pagy_t method is the internal implementation of I18n.t, used when I18n is missing or
    # not needed (for example when your application is a single-locale app, e.g. only 'en', or only 'fr'...).
    #
    # It implements only the very basic functionality of the I18n.t method
    # but it's still good enough for the limited Pagy's needs and it is faster.
    #
    # You can still use this method with a pluralization different than English
    # (i.e. not 'zero', 'one', 'other' plurals). In that case you should define the
    # Pagy::Opts.i18n_plurals proc to return the plural key based on the passed count.
    #
    # If you need full I18n functionality, you should override this method with something like:
    #    def pagy_t(*a); I18n.t(*a) end
    # and add your translations to the I18n usual locales files

    hash = YAML.load_file Opts.i18n_file || Pagy.root.join('locales', 'pagy.yml')
    I18N = hash[hash.keys.first].freeze

    # Similar to I18n.t for interpolation and pluralization, with the following constraints:
    # - the path/keys option is supported only in dot-separated string or symbol format
    # - the :scope and :default options are not supported
    # - no exception are raised: the errors are returned as translated strings
    def pagy_t(path, vars={})
      value = I18N.dig(*path.to_s.split('.'.freeze))
      if value.is_a?(Hash)
        vars.has_key?(:count) or return value
        plural = (Opts.i18n_plurals ||= -> (c) {c==0 && 'zero' || c==1 && 'one' || 'other'}).call(vars[:count])
        value.has_key?(plural) or return %(invalid pluralization data: "#{path}" cannot be used with count: #{vars[:count]}; key "#{plural}" is missing.)
        value = value[plural]
      end
      value or return %(translation missing: "#{path}")
      sprintf value, Hash.new{|h,k| "%{#{k}}"}.merge!(vars)    # interpolation
    end


    # NOTICE: This method is used internally, so you need to know about it only if you
    # are going to override a *_nav helper or a template AND change the link tags.
    #
    # This is a specialized method that works only for page links, it is not intended to be used
    # for any other generic links to any urls different than a page link.
    #
    # You call this method in order to get a proc that you will call to produce the page links.
    # The reasaon it is a 2 step process instead of a single method call is performance.
    #
    # Call the method to get the proc (once):
    #    link = pagy_link_proc( pagy [, extra_attributes_string ])
    #
    # Call the proc to get the links (multiple times):
    #    link.call( page_number [, text [, extra_attributes_string ]])
    #
    # You can pass extra attribute strings to get inserted in the link tags at many different levels.
    # Depending by the scope you want your attributes to be added, (from wide to narrow) you can:
    #
    # 1. For all pagy objects: set the global option :link_extra:
    #
    #    Pagy::Opts.extra_link = 'data-remote="true"'
    #    link.call(page_number=2)
    #    #=> <a href="...?page=2" data-remote="true">2</a>
    #
    # 2. For one pagy object: pass a :link_extra option to a pagy constructor (Pagy.new or pagy controller method):
    #
    #    @pagy, @records = pagy(my_scope, extra_link: 'data-remote="true"')
    #    link.call(page_number)
    #    #=> <a href="...?page=2" data-remote="true">2</a>
    #
    # 3. For one pagy_nav render: pass a :link_extra option to a *_nav method:
    #
    #    pagy_nav(@pagy,  extra_link: 'data-remote="true"')   #
    #    link.call(page_number)
    #    #=> <a href="...?page=2" data-remote="true">2</a>
    #
    # 4. For all the calls to the returned pagy_link_proc: pass an extra attributes string when you get the proc:
    #
    #    link = pagy_link_proc(pagy, 'class="page-link"')
    #    link.call(page_number)
    #    #=> <a href="...?page=2" data-remote="true" class="page-link">2</a>
    #
    # 5. For a single link.call: pass an extra attributes string  when you call the proc:
    #
    #    link.call(page_number, 'aria-label="my-label"')
    #    #=> <a href="...?page=2" data-remote="true" class="page-link" aria-label="my-label">2</a>
    #
    # WARNING: since we use only strings for performance, the attribute strings get concatenated, not merged!
    # Be careful not to pass the same attribute at different levels multiple times. That would generate a duplicated
    # attribute which is illegal html (although handled by all mayor browsers by ignoring all the duplicates but the first)

    MARKER = "-pagy-#{'pagy'.hash}-".freeze

    def pagy_link_proc(pagy, lx=''.freeze)  # link extra
      p_prev, p_next, p_lx = pagy.prev, pagy.next, pagy.opts[:link_extra]
      a, b = %(<a href="#{pagy_url_for(MARKER)}"#{p_lx ? %( #{p_lx}) : ''.freeze}#{lx.empty? ? lx : %( #{lx})}).split(MARKER)
      -> (n, text=n, x=''.freeze) { "#{a}#{n}#{b}#{ if    n == p_prev ; ' rel="prev"'.freeze
                                                    elsif n == p_next ; ' rel="next"'.freeze
                                                    else                           ''.freeze
                                                    end }#{x.empty? ? x : %( #{x})}>#{text}</a>" }
    end

  end
end
