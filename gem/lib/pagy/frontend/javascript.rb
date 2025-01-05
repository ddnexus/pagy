# frozen_string_literal: true

require_relative '../b64'
require 'json'

class Pagy # :nodoc:
  module Frontend
    # Private module documented in the main classes
    module Javascript
      # Dummy tag for input helpers: needed because Turbo does not intercept window.location changes
      A_TAG = '<a href="#" style="display: none;">#</a>'

      # Additions for the Frontend
      module DataHelpers
        # Return a data tag with the base64 encoded JSON-serialized args generated with the faster oj gem
        def pagy_data(_pagy, *args)
          data = defined?(::Oj) ? Oj.dump(args, mode: :compat) : JSON.dump(args)
          %(data-pagy="#{B64.encode(data)}")
        end
      end
      Frontend.prepend DataHelpers

      # Additions for the Pagy class
      module PagyAddOn
        # `Pagy` instance method used by the `pagy*_nav_js` helpers.
        # Return the reverse sorted array of widths, series, and labels generated from the :steps hash
        # Notice: if :steps is false it will use the single {0 => @vars[:size]} size
        def sequels(steps: @vars[:steps] || { 0 => @vars[:size] }, **_)
          raise VariableError.new(self, :steps, 'to define the 0 width', steps) unless steps.key?(0)

          widths, series = steps.sort.reverse.map { |width, size| [width, series(size:)] }.transpose
          [widths, series, label_sequels(series)]
        end

        # Support for the Calendar API
        def label_sequels(*); end
      end
      Pagy.prepend PagyAddOn
      Pagy::KeysetForUI.prepend PagyAddOn if defined?(Pagy::KeysetForUI)

      # Additions for Calendar class
      module CalendarOverride
        def label_sequels(series)
          series.map { |s| s.map { |item| item == :gap ? :gap : label_for(item) } }
        end
      end
      Calendar::Unit.prepend CalendarOverride if defined?(::Pagy::Calendar::Unit)
    end
  end
end
