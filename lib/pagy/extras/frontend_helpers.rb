# frozen_string_literal: true

class Pagy # :nodoc:
  DEFAULT[:steps] = false # default false will use {0 => @vars[:size]}

  # Private module documented in the main classes
  module FrontendHelpers
    # Additions for the Pagy class
    module Pagy
      # `Pagy` instance method used by the `pagy*_nav_js` helpers.
      # It returns the sequels of width/series generated from the :steps hash
      # Example:
      # >> pagy = Pagy.new(count:1000, page: 20, steps: {0 => [1,2,2,1], 350 => [2,3,3,2], 550 => [3,4,4,3]})
      # >> pagy.sequels
      # #=> { "0"   => [1, :gap, 18, 19, "20", 21, 22, :gap, 50],
      #       "350" => [1, 2, :gap, 17, 18, 19, "20", 21, 22, 23, :gap, 49, 50],
      #       "550" => [1, 2, 3, :gap, 16, 17, 18, 19, "20", 21, 22, 23, 24, :gap, 48, 49, 50] }
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

    # Additions for Calendar class
    module Calendar
      def label_sequels(sequels = self.sequels)
        {}.tap do |label_sequels|
          sequels.each do |width, series|
            label_sequels[width] = series.map { |item| item == :gap ? :gap : label_for(item) }
          end
        end
      end
    end

    # Additions for the Frontend
    module Frontend
      if defined?(Oj)
        # Return a data tag with the base64 encoded JSON-serialized args generated with the faster oj gem
        # Base64 encoded JSON is smaller than HTML escaped JSON
        def pagy_data(pagy, *args)
          args << pagy.vars[:page_param] if pagy.vars[:trim_extra]
          strict_base64_encoded = [Oj.dump(args, mode: :strict)].pack('m0')
          %(data-pagy="#{strict_base64_encoded}")
        end
      else
        require 'json'
        # Return a data tag with the base64 encoded JSON-serialized args generated with the slower to_json
        # Base64 encoded JSON is smaller than HTML escaped JSON
        def pagy_data(pagy, *args)
          args << pagy.vars[:page_param] if pagy.vars[:trim_extra]
          strict_base64_encoded = [args.to_json].pack('m0')
          %(data-pagy="#{strict_base64_encoded}")
        end
      end

      # Return the marked link to used by pagy.js
      def pagy_marked_link(link)
        link.call PAGE_PLACEHOLDER, '', 'style="display: none;"'
      end
    end
  end
  prepend FrontendHelpers::Pagy
  Calendar.prepend FrontendHelpers::Calendar if defined?(Calendar)
  Frontend.prepend FrontendHelpers::Frontend
end
