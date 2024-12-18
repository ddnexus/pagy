# frozen_string_literal: true

require_relative '../b64'

class Pagy # :nodoc:
  DEFAULT[:steps] = false # default false will use {0 => @vars[:size]}

  # Private module documented in the main classes
  module JSTools
    # Dummy tag for input helpers: needed because Turbo does not intercept window.location changes
    A_TAG = '<a href="#" style="display: none;">#</a>'

    # Additions for the Pagy class
    module PagyAddOn
      # `Pagy` instance method used by the `pagy*_nav_js` helpers.
      # It returns the sequels of width/series generated from the :steps hash
      # Example:
      # >> pagy = Pagy.new(count:1000, page: 20, steps: {0 => 5, 350 => 7, 550 => 9})
      # >> pagy.sequels
      # #=> { "0"   => [18, 19, "20", 21, 22],
      #       "350" => [1, :gap, 19, "20", 21, :gap, 50],
      #       "550" => [1 :gap, 18, 19, "20", 21, 22, :gap, 50] }
      # Notice: if :steps is false it will use the single {0 => @vars[:size]} size
      def sequels(steps: @vars[:steps] || { 0 => @vars[:size] }, **_)
        raise VariableError.new(self, :steps, 'to define the 0 width', steps) unless steps.key?(0)

        {}.tap do |sequels|
          steps.each { |width, step_size| sequels[width.to_s] = series(size: step_size) }
        end
      end

      # Support for the Calendar API
      def label_sequels(*); end
    end
    Pagy.prepend PagyAddOn

    # Additions for Calendar class
    module CalendarOverride
      def label_sequels(sequels = self.sequels)
        {}.tap do |label_sequels|
          sequels.each do |width, series|
            label_sequels[width] = series.map { |item| item == :gap ? :gap : label_for(item) }
          end
        end
      end
    end
    Calendar::Unit.prepend CalendarOverride if defined?(::Pagy::Calendar::Unit)

    # Additions for the Frontend
    module FrontendAddOn
      if defined?(::Oj)
        # Return a data tag with the base64 encoded JSON-serialized args generated with the faster oj gem
        def pagy_data(_pagy, kind, *args)
          %(data-pagy="#{B64.encode(Oj.dump([kind] + args, mode: :strict))}") unless args.empty?
        end
      else
        require 'json'
        # Return a data tag with the base64 encoded JSON-serialized args generated with the slower to_json
        def pagy_data(_pagy, kind, *args)
          %(data-pagy="#{B64.encode(([kind + args]).to_json)}") unless args.empty?
        end
      end
    end
    Frontend.prepend FrontendAddOn
  end
end
