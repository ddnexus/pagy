# frozen_string_literal: true

class Pagy
  Frontend.module_eval do
    # Generic pagination: it returns the html with the series of links to the pages
    def pagy_nav(pagy, id: nil, aria_label: nil, **vars)
      id   = %( id="#{id}") if id
      a    = pagy_anchor(pagy, **vars)
      data = %( #{pagy_data(pagy, :n)}) if /^Pagy::Keyset::Keynav/.match?(pagy.class.name)

      html = %(<nav#{id} class="pagy nav" #{pagy_nav_aria_label(pagy, aria_label:)}#{data}>#{pagy_prev_a(pagy, a)})
      pagy.series(**vars).each do |item|
        # series example: [1, :gap, 7, 8, "9", 10, 11, :gap, 36]
        html << case item
                when Integer
                  a.(item)
                when String
                  %(<a role="link" aria-disabled="true" aria-current="page" class="current">#{pagy.label_for(item)}</a>)
                when :gap
                  %(<a role="link" aria-disabled="true" class="gap">#{pagy_t('pagy.gap')}</a>)
                else
                  raise InternalError, "expected item types in series to be Integer, String or :gap; got #{item.inspect}"
                end
      end
      html << %(#{pagy_next_a(pagy, a)}</nav>)
    end
  end
end
