require 'yaml'
class Pagy
  # This module supplies a few methods to deal with the navigation aspect of the pagination.
  # You will usually include it in some helper module, eventually overriding the #pagy_url_for
  # in order to fit its behavior with your app needs (e.g.: removing and adding some param or
  # allowing fancy routes, etc.)
  #
  # All the code has been optimized for speed and low memory usage.
  # In particular there are a couple of very specialized methods (pagy_t and pagy_link_proc)
  # that can be used in place of the equivalent (but general-purpose) framework helpers,
  # in order to dramatically boost speed and reduce memory usage.
  #
  # For example if you use the rails link_to in order to link each page in the pagination bar,
  # you will call 10 or 20 times the same method that has to do a lot of things again and again
  # just to get you (almost) the same string repeated with just the page number replaced.
  # Since pagination is a very specialized process, it is possible to do the same by using
  # a one-line proc that uses just one single string interpolation. Compared to the general-purpose
  # link_to method, the pagy_link_proc benchmark gives a 20 times faster score and 12 times less memory.
  #
  # Notice: The code in this module may not look very pretty (as most code dealing with many long strings),
  # but its performance makes it very sexy! ;)

  module Frontend

    # Notice: Each long tag-string of the nav methods is written on one single line with a long
    # interpolation in the middle for performance and... (hard to believe) readability reasons.
    #
    # Performance:
    # using the '%' method like in the following example:
    #
    # case item
    #   when Integer; '<span class="page">%s</span>'        % link.call(item)
    #   when String ; '<span class="page active">%s</span>' % item
    #   when :gap   ; '<span class="page gap">%s</span>'    % pagy_t('pagy.nav.gap')
    # end
    #
    # would look a lot better but the benchmark really sucks! :/
    #
    # Readability:
    # If you disable soft-wrapping in your editor, you can focus on the very simple ruby logic
    # unfolding at the beginning of the lines, without any string-distraction.
    # For the strings: each tag-string has only one interpolation, so at the end they are
    # simple to deal with, even if they look a bit ugly.

    # Generic pagination: it returns the html with the series of links to the pages
    def pagy_nav(pagy, opts=nil)
      pagy.opts.merge!(opts) if opts ; link = pagy_link_proc(pagy) ; tags = []  # init all vars

      tags << (pagy.prev ? %(<span class="page prev">#{link.call pagy.prev, pagy_t('pagy.nav.prev'.freeze), 'aria-label="previous"'.freeze}</span>)
                         : %(<span class="page prev disabled">#{pagy_t('pagy.nav.prev'.freeze)}</span>))
      pagy.series.each do |item|  # series example: [1, :gap, 7, 8, "9", 10, 11, :gap, 36]
        tags << case item
                  when Integer; %(<span class="page">#{link.call item}</span>)                  # page link
                  when String ; %(<span class="page active">#{item}</span>)                       # current page
                  when :gap   ; %(<span class="page gap">#{pagy_t('pagy.nav.gap'.freeze)}</span>) # page gap
                end
      end
      tags << (pagy.next ? %(<span class="page next">#{link.call pagy.next, pagy_t('pagy.nav.next'.freeze), 'aria-label="next"'.freeze}</span>)
                         : %(<span class="page next disabled">#{pagy_t('pagy.nav.next'.freeze)}</span>))
      %(<nav class="#{pagy.opts[:class]||'pagination'.freeze}" role="navigation" aria-label="pager">#{tags.join(pagy.opts[:separator]||' '.freeze)}</nav>)
    end


    # Pagination for bootstrap: it returns the html with the series of links to the pages
    def pagy_nav_bootstrap(pagy, opts=nil)
      pagy.opts.merge!(opts) if opts ; link = pagy_link_proc(pagy) ; tags = []  # init all vars

      tags << (pagy.prev ? %(<li class="page-item prev">#{link.call pagy.prev, pagy_t('pagy.nav.prev'.freeze), 'class="page-link" aria-label="previous"'.freeze}</li>)
                         : %(<li class="page-item prev disabled"><a href="#" class="page-link">#{pagy_t('pagy.nav.prev'.freeze)}</a></li>))
      pagy.series.each do |item| # series example: [1, :gap, 7, 8, "9", 10, 11, :gap, 36]
        tags << case item
                  when Integer; %(<li class="page-item">#{link.call item, item, 'class="page-link"'.freeze}</li>)                           # page link
                  when String ; %(<li class="page-item active">#{link.call item, item, 'class="page-link"'.freeze}</li>)                    # active page
                  when :gap   ; %(<li class="page-item gap disabled"><a href="#" class="page-link">#{pagy_t('pagy.nav.gap'.freeze)}</a></li>) # page gap
                end
      end
      tags << (pagy.next ? %(<li class="page-item next">#{link.call pagy.next, pagy_t('pagy.nav.next'.freeze), 'class="page-link" aria-label="next"'.freeze}</li>)
                         : %(<li class="page-item next disabled"><a href="#" class="page-link">#{pagy_t('pagy.nav.next'.freeze)}</a></li>))
      %(<nav class="#{pagy.opts[:class]||'pagination'.freeze}" role="navigation" aria-label="pager"><ul class="pagination">#{tags.join}</ul></nav>)
    end


    # return examples: "Displaying items 41-60 of 324"  or "Displaying Products 41-60 of 324"
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
    # but it is a lot faster, it uses less memory and it's still good enough for the limited Pagy's needs.
    #
    # You can still use this method with a pluralization different than English
    # (i.e. not 'zero', 'one', 'other' plurals). In that case you should define the
    # Pagy::Opts.i18n_plurals proc to return the plural key based on the passed count.
    #
    # If you need full I18n functionality, you should override this method with something like:
    #    def pagy_t(*a); I18n.t(*a) end
    # and add your translations to the I18n usual locales files

    hash = YAML.load_file Opts.i18n_file || Pagy.root.join('locales', 'pagy.yml')
    DATA = hash[hash.keys.first].freeze

    # Similar to I18n.t for interpolation and pluralization, with the following constraints:
    # - the path/keys option is supported only in dot-separated string or symbol format
    # - the :scope and :default options are not supported
    # - no exception are raised: the errors are returned as translated strings
    def pagy_t(path, vars={})
      value = DATA.dig(*path.to_s.split('.'.freeze))
      if value.is_a?(Hash)
        vars.has_key?(:count) or return value
        plural = (Opts.i18n_plurals ||= -> (c) {c==0 && 'zero' || c==1 && 'one' || 'other'}).call(vars[:count])
        value.has_key?(plural) or return %(invalid pluralization data: "#{path}" cannot be used with count: #{vars[:count]}; key "#{plural}" is missing.)
        value = value[plural]
      end
      value or return %(translation missing: "#{path}")
      sprintf value, Hash.new{|h,k| "%{#{k}}"}.merge!(vars)    # interpolation
    end

    # This method returns a very efficient proc to produce the page links.
    # The proc is somewhat similar to link_to, but it works a lot faster
    # with a simple one-string-only interpolation.
    # The proc also adds the eventual :link_extra string option to the link tag
    #
    # Notice: all the rendering methods in this module use only strings for fast performance,
    # so use the :link_extra option to add string-formatted attributes like for example:
    # :link_extra => 'data-remote="true" class="special"'
    #
    # This method calls the (possibly overridden and slow) pagy_url_for only once to get the url
    # with the MARKER in place of the page number, then it splits the beginning tag-string at the MARKER
    # and defines a proc that interpolates the two fragments around the real page number with the rest of the tag.
    # Tricky but very fast!

    MARKER = "-pagy-#{'pagy'.hash}-".freeze

    def pagy_link_proc(pagy)
      rel  = { pagy.prev=>' rel="prev"'.freeze, pagy.next=>' rel="next"'.freeze }
      a, b = %(<a href="#{pagy_url_for(MARKER)}" #{pagy.opts[:link_extra]}).split(MARKER)
      -> (n, name=n.to_s, extra=''.freeze) { "#{a}#{n}#{b}#{rel[n]||''.freeze} #{extra}>#{name}</a>"}
    end

  end
end
