# See the Pagy documentation: https://ddnexus.github.io/pagy/docs/extras/trim
# frozen_string_literal: true

class Pagy # :nodoc:
  DEFAULT[:trim_extra] = true   # extra enabled by default

  # Remove the page=1 param from the first page link
  module TrimExtra
    # Override the original pagy_link_proc.
    # Call the pagy_trim method if the trim_extra is enabled.
    def pagy_link_proc(pagy, link_extra: '')
      link_proc = super(pagy, link_extra: link_extra)
      return link_proc unless pagy.vars[:trim_extra]

      lambda do |page, text = pagy.label_for(page), extra = ''|
        link = +link_proc.call(page, text, extra)
        return link unless page.to_s == '1'

        pagy_trim(pagy, link)
      end
    end

    # Remove the the :page_param param from the first page link
    def pagy_trim(pagy, link)
      link.sub!(/(\?|&amp;)#{pagy.vars[:page_param]}=1\b(?!&amp;)|\b#{pagy.vars[:page_param]}=1&amp;/, '')
    end
  end
  Frontend.prepend TrimExtra
end
