# See the Pagy documentation: https://ddnexus.github.io/pagy/extras/trim
# frozen_string_literal: true

class Pagy

  module Frontend

    # boolean used by the compact extra
    TRIM = true

    def pagy_trim_url(url, param_string)
      url.sub(/((?:[?&])#{param_string}\z|\b(?<=[?&])#{param_string}&)/, '')
    end

    alias_method :pagy_link_proc_without_trim, :pagy_link_proc
    def pagy_link_proc_with_trim(pagy, link_extra='')
      p_prev, p_next, p_vars = pagy.prev, pagy.next, pagy.vars
      url   = pagy_url_for(MARKER, pagy)
      p1url = pagy_trim_url(url, "#{p_vars[:page_param]}=#{MARKER}")
      p1    = %(<a href="#{p1url}" #{p_vars[:link_extra]} #{link_extra})
      a, b = %(<a href="#{url}" #{p_vars[:link_extra]} #{link_extra}).split(MARKER, 2)
      -> (n, text=n, extra='') { start = n == 1 ? p1 : "#{a}#{n}#{b}"
                                 "#{start}#{ if    n == p_prev ; ' rel="prev"'
                                             elsif n == p_next ; ' rel="next"'
                                             else                           '' end } #{extra}>#{text}</a>" }
    end
    alias_method :pagy_link_proc, :pagy_link_proc_with_trim

  end
end
