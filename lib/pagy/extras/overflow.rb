# See the Pagy documentation: https://ddnexus.github.io/pagy/docs/extras/overflow
# frozen_string_literal: true

class Pagy # :nodoc:
  DEFAULT[:overflow] = :empty_page

  # Handles OverflowError exceptions for different classes with different options
  module OverflowExtra
    # Support for Pagy class
    module Pagy
      # Is the requested page overflowing?
      def overflow?
        @overflow
      end

      # Add rescue clause for different behaviors
      def initialize(vars)
        @overflow ||= false                            # still true if :last_page re-run the method after an overflow
        super
      rescue OverflowError
        @overflow = true                               # add the overflow flag
        case @vars[:overflow]
        when :exception
          raise                                        # same as without the extra
        when :last_page
          requested_page = @vars[:page]                # save the requested page (even after re-run)
          initialize vars.merge!(page: @last)          # re-run with the last page
          @vars[:page] = requested_page                # restore the requested page
        when :empty_page
          @offset = @items = @from = @to = 0           # vars relative to the actual page
          if defined?(Calendar) && is_a?(Calendar)     # only for Calendar instances
            edge = @order == :asc ? @final : @initial  # get the edge of the overflow side (neat, but any time would do)
            @from = @to = edge                         # set both to the edge utc time (a >=&&< query will get no records)
          end
          @prev = @last                                # prev relative to the actual page
          extend Series                                # special series for :empty_page
        else
          raise VariableError.new(self, :overflow, 'to be in [:last_page, :empty_page, :exception]', @vars[:overflow])
        end
      end

      # Special series for empty page
      module Series
        def series(*, **)
          @page = @last                                # series for last page
          super.tap do |s|                             # call original series
            s[s.index(@page.to_s)] = @page             # string to integer (i.e. no current page)
            @page = @vars[:page]                       # restore the actual page
          end
        end
      end
    end

    # Support for Pagy::Countless class
    module Countless
      # Add rescue clause for different behaviors
      def finalize(items)
        @overflow = false
        super
      rescue OverflowError
        @overflow = true                               # add the overflow flag
        case @vars[:overflow]
        when :exception
          raise                                        # same as without the extra
        when :empty_page
          @offset = @items = @from = @to = 0           # vars relative to the actual page
          @vars[:size] = []                            # no page in the series
          self
        else
          raise VariableError.new(self, :overflow, 'to be in [:empty_page, :exception]', @vars[:overflow])
        end
      end
    end
  end
  prepend OverflowExtra::Pagy
  Calendar.prepend OverflowExtra::Pagy if defined?(Calendar)
  Countless.prepend OverflowExtra::Countless if defined?(Countless)
end
