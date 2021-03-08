# See the Pagy documentation: https://ddnexus.github.io/pagy/extras/trim
# encoding: utf-8
# frozen_string_literal: true

class Pagy

  module Trim
    def pagy_link_proc(pagy, link_extra='')
      link_proc = super(pagy, link_extra)
      re = /[?&]#{pagy.vars[:page_param]}=1\b(?!&)|\b#{pagy.vars[:page_param]}=1&/
      lambda do |n, text=n, extra=''|
        link = link_proc.call(n, text, extra)
        n == 1 ? link.sub(re, '') : link
      end
    end
  end
  Frontend.prepend Trim

end
