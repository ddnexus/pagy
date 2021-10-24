# frozen_string_literal: true

require 'digest'

class Pagy
  DEFAULT[:steps] = false # default false will use {0 => @vars[:size]}

  module SharedExtra
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
      def sequels(steps = nil)
        steps ||= @vars[:steps] || { 0 => @vars[:size] }
        raise VariableError.new(self, :steps, 'to define the 0 width', steps) unless steps.key?(0)

        {}.tap do |sequels|
          steps.each { |width, size| sequels[width.to_s] = series(size) }
        end
      end
    end

    # Additions for the Frontend
    module Frontend
      if defined?(Oj)
        # Return a script tag with the JSON-serialized args generated with the faster oj gem
        def pagy_json_attr(pagy, *args)
          args << pagy.vars[:page_param] if pagy.vars[:trim_extra]
          %(data-pagy-json="#{Oj.dump(args, mode: :strict).gsub('"', '&quot;')}")
        end
      else
        require 'json'
        # Return a script tag with the JSON-serialized args generated with the slower to_json
        def pagy_json_attr(pagy, *args)
          args << pagy.vars[:page_param] if pagy.vars[:trim_extra]
          %(data-pagy-json="#{args.to_json.gsub('"', '&quot;')}")
        end
      end

      # Return the marked link to used by pagy.js
      def pagy_marked_link(link)
        link.call PAGE_PLACEHOLDER, '', 'style="display: none;"'
      end
    end
  end
  prepend SharedExtra::Pagy
  Frontend.prepend SharedExtra::Frontend
end
