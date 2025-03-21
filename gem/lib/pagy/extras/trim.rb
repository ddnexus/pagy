# See the Pagy documentation: https://ddnexus.github.io/pagy/docs/extras/trim
# frozen_string_literal: true

class Pagy # :nodoc:
  DEFAULT[:trim_extra] = true # extra enabled by default

  # Remove the page=1 param from the first page link
  module TrimExtra
    # Override the original pagy_anchor.
    # Call the pagy_trim method for page 1 if the trim_extra is enabled
    def pagy_anchor(pagy, **_)
      a_proc = super
      return a_proc unless pagy.vars[:trim_extra]

      lambda do |page, text = pagy.label_for(page), **opts|
        a = +a_proc.(page, text, **opts)
        return a unless page.to_s == '1'

        pagy_trim(pagy, a) # in method for isolated testing
      end
    end

    # Remove the :page_param param from the first page anchor
    def pagy_trim(pagy, a)
      page_param = pagy.vars[:page_param]
      pattern = if pagy.vars[:jsonapi]
                  # Handle both URL-encoded (%5B, %5D) and non-encoded formats for robustness
                  # Match both page[param]=1 and page%5Bparam%5D=1 formats
                  /[?&]page(?:%5B|\[)#{page_param}(?:%5D|\])=1\b(?!&)|\bpage(?:%5B|\[)#{page_param}(?:%5D|\])=1&/
                else
                  /[?&]#{page_param}=1\b(?!&)|\b#{page_param}=1&/
                end
      a.sub!(pattern, '')
    end
  end
  Frontend.prepend TrimExtra
end
