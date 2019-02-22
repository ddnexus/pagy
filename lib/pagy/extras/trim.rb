# See the Pagy documentation: https://ddnexus.github.io/pagy/extras/trim
# encoding: utf-8
# frozen_string_literal: true

class Pagy

  module Frontend

    # boolean used by the compact navs
    TRIM = true

    alias_method :pagy_link_proc_without_trim, :pagy_link_proc
    def pagy_link_proc_with_trim(pagy, link_extra='')
      p_prev, p_next, p_vars = pagy.prev, pagy.next, pagy.vars
      marker_url = pagy_url_for(MARKER, pagy)
      page1_url  = pagy_trim_url(marker_url, "#{p_vars[:page_param]}=#{MARKER}")
      page1_link = %(<a href="#{page1_url}" #{p_vars[:link_extra]} #{link_extra})
      a, b = %(<a href="#{marker_url}" #{p_vars[:link_extra]} #{link_extra}).split(MARKER, 2)
      lambda{|n, text=n, extra=''| start = n.to_i == 1 ? page1_link : "#{a}#{n}#{b}"
                                 "#{start}#{ if    n == p_prev ; ' rel="prev"'
                                             elsif n == p_next ; ' rel="next"'
                                             else                           '' end } #{extra}>#{text}</a>" }
    end
    alias_method :pagy_link_proc, :pagy_link_proc_with_trim

    private

      # separate method easier to test
      def pagy_trim_url(url, param_string)
        url.sub(/((?:[?&])#{param_string}\z|\b(?<=[?&])#{param_string}&)/, '')
      end

  end
end
