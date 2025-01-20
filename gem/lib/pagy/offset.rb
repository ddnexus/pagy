# frozen_string_literal: true

require_relative 'modules/ui_support'

class Pagy
  # Implements Offset Pagination
  class Offset < Pagy
    path = ROOT.join('lib/pagy/offset').freeze
    autoload :Calendar,  path.join('calendar')
    autoload :Countless, path.join('countless')
    autoload :Search,    path.join('search')

    # Core default: constant for easy access, but mutable for customizable defaults
    DEFAULT = { count_args: [:all],  # AR friendly
                ends:       true,
                outset:     0,
                page:       1,
                size:       7 }.freeze

    attr_reader :from, :offset, :to

    # Merge and validate the options, do some simple arithmetic and set the instance variables
    def initialize(**vars) # rubocop:disable Lint/MissingSuper
      assign_vars(vars)
      assign_and_check(count: 0, page: 1, outset: 0)
      assign_limit
      assign_offset
      assign_last
      return unless check_overflow

      @from = [@offset - @outset + 1, @count].min
      @to   = [@offset - @outset + @limit, @count].min
      @in   = [@to - @from + 1, @count].min
      assign_prev_and_next
    end

    # Setup @last (overridden by the gearbox extra)
    def assign_last
      @last = [(@count.to_f / @limit).ceil, 1].max
      @last = @vars[:max_pages] if @vars[:max_pages] && @last > vars[:max_pages]
    end

    # Assign @offset (overridden by the gearbox extra)
    def assign_offset
      @offset = (@limit * (@page - 1)) + @outset  # may be already set from gear_box
    end

    # Assign @prev and @next
    def assign_prev_and_next
      @prev = (@page - 1 unless @page == 1)
      @next = @page == @last ? (1 if @vars[:cycle]) : @page + 1
    end

    # Checks the @page <= @last
    def check_overflow
      return true unless @page > @last

      @overflow = true
      case @vars[:overflow]
      when :last_page
        requested_page = @vars[:page]                # save the requested page (even after re-run)
        initialize(**vars, page: @last)              # re-run with the last page
        @vars[:page] = requested_page                # restore the requested page
        true
      when :empty_page
        @in = @from = @to = 0                        # vars relative to the actual page
        @prev = @last                                # @prev relative to the actual page
        false
      else
        raise OverflowError.new(self, :page, "in 1..#{@last}", @page)
      end
    end

    def overflow? = @overflow

    include UISupport
  end
end
