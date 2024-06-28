# See the Pagy documentation: https://ddnexus.github.io/pagy/docs/extras/size
# frozen_string_literal: true

class Pagy # :nodoc:
  # Implement the legacy bar using the array size.
  # Unless you have very specific requirements, use the faster and better looking default bar.
  module SizeExtra
    # Setup @items based on the :gearbox_items variable
    def series(size: @vars[:size], **_)
      return super unless size.is_a?(Array)
      return [] if size == []
      raise VariableError.new(self, :size, 'to be an Array of 4 Integers or []', size) \
            unless size.is_a?(Array) && size.size == 4 && size.all? { |num| !num.negative? rescue false } # rubocop:disable Style/RescueModifier

      [].tap do |series|
        # This algorithm is up to ~5x faster and ~2.3x lighter than the previous one (pagy < 4.3)
        # However the behavior of the legacy nav bar was taken straight from WillPaginate and Kaminari:
        # it's ill-concieved and complicates the experience of devs and users.
        left_gap_start  = 1 + size[0]
        left_gap_end    = @page - size[1] - 1
        right_gap_start = @page + size[2] + 1
        right_gap_end   = @last - size[3]
        left_gap_end    = right_gap_end  if left_gap_end   > right_gap_end
        right_gap_start = left_gap_start if left_gap_start > right_gap_start
        start           = 1
        if (left_gap_end - left_gap_start).positive?
          series.push(*start...left_gap_start, :gap)
          start = left_gap_end + 1
        end
        if (right_gap_end - right_gap_start).positive?
          series.push(*start...right_gap_start, :gap)
          start = right_gap_end + 1
        end
        series.push(*start..@last)
        series[series.index(@page)] = @page.to_s
      end
    end
  end
  prepend SizeExtra
end
