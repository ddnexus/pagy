# See the Pagy documentation: https://ddnexus.github.io/pagy/extras/trim
# frozen_string_literal: true

class Pagy
  DEFAULT[:trim_extra] = true   # extra enabled by default

  module TrimExtra
    # Override the original using the pagy_trim method
    def pagy_link_proc(pagy, link_extra: '')
      link_proc = super(pagy, link_extra: link_extra)
      return link_proc unless pagy.vars[:trim_extra]

      lambda do |num, text = num, extra = ''|
        link = +link_proc.call(num, text, extra)
        return link unless num == 1

        pagy_trim(pagy, link)
      end
    end

    # Remove the the :page_param param from the first page link
    def pagy_trim(pagy, link)
      link.sub!(/[?&]#{pagy.vars[:page_param]}=1\b(?!&)|\b#{pagy.vars[:page_param]}=1&/, '')
    end
  end
  Frontend.prepend TrimExtra
end
