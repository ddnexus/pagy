# See the Pagy documentation: https://ddnexus.github.io/pagy/extras/trim
# frozen_string_literal: true

class Pagy

  module UseTrimExtra

    def pagy_link_proc(pagy, link_extra='')
      link_proc = super(pagy, link_extra)
      lambda do |num, text=num, extra=''|
        link = link_proc.call(num, text, extra)
        if num == 1
         link.sub!(/[?&]#{pagy.vars[:page_param]}=1\b(?!&)|\b#{pagy.vars[:page_param]}=1&/, '')
        else
          link
        end
      end
    end

  end
  Frontend.prepend UseTrimExtra

end
