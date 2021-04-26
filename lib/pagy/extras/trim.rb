# See the Pagy documentation: https://ddnexus.github.io/pagy/extras/trim
# frozen_string_literal: true

class Pagy

  VARS[:trim] = true

  module UseTrimExtra

    def pagy_link_proc(pagy, deprecated_link_extra=nil, link_extra: '')
      link_extra = Pagy.deprecated_arg(:link_extra, deprecated_link_extra, :link_extra, link_extra) if deprecated_link_extra
      link_proc = super(pagy, link_extra: link_extra)
      return link_proc unless pagy.vars[:trim]
      lambda do |num, text=num, extra=''|
        link = link_proc.call(num, text, extra)
        return link unless num == 1
        link.sub!(/[?&]#{pagy.vars[:page_param]}=1\b(?!&)|\b#{pagy.vars[:page_param]}=1&/, '')
      end
    end

  end
  Frontend.prepend UseTrimExtra

end
