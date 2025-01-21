# frozen_string_literal: true

require_relative 'b64'

class Pagy
  # Relegate frontend utilities methods that should not be used directly. Make overriding navs easier
  module Front
    module_function

    # Return a data tag with the base64 encoded JSON-serialized args generated with the faster oj gem
    def data_pagy(*args)
      data = defined?(::Oj) ? Oj.dump(args, mode: :compat) : JSON.dump(args)
      %(data-pagy="#{B64.encode(data)}")
    end

    # Compose the aria label attribute for the nav
    def nav_aria_label(frontend, pagy, aria_label: nil)
      aria_label ||= frontend.pagy_t('pagy.aria_label.nav', count: pagy.pages)
      %(aria-label="#{aria_label}")
    end

    # Wrap the specific html for the style
    def build_nav(frontend, pagy, html, nav_classes, id: nil, aria_label: nil, **_vars)
      id     &&= %( id="#{id}")
      data     = %( #{data_pagy(:n, [pagy.vars[:page_sym], pagy.update])}) if pagy.keynav?
      %(<nav#{id} class="#{nav_classes}" #{nav_aria_label(frontend, pagy, aria_label:)}#{data}>#{html}</nav>)
    end

    # Finalize the specific tokens for the style
    def build_nav_js(frontend, pagy, tokens, nav_classes, id: nil, aria_label: nil, **vars)
      sequels = pagy.sequels(**vars)
      id    &&= %( id="#{id}")
      %(<nav#{id} class="#{'pagy-rjs ' if sequels[0].size > 1}#{nav_classes}" #{
      nav_aria_label(frontend, pagy, aria_label:)} #{
      data = [:nj, tokens.values, *sequels]
      data.push([pagy.vars[:page_sym], pagy.update]) if pagy.keynav?
      data_pagy(*data)
      }></nav>)
    end
  end
end
