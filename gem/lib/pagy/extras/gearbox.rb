# See the Pagy documentation: https://ddnexus.github.io/pagy/docs/extras/gearbox
# frozen_string_literal: true

class Pagy # :nodoc:
  DEFAULT[:gearbox_extra] = true # extra enabled by default
  DEFAULT[:gearbox_limit] = [15, 30, 60, 100]

  # Automatically change the limit depending on the page number
  # accepts an array as the :gearbox_limit variable, that will determine the limit for the first pages
  module GearboxExtra
    # Assign @limit based on the :gearbox_limit variable
    def assign_limit
      return super if !@vars[:gearbox_extra] || @vars[:limit_extra]

      gears = @vars[:gearbox_limit]
      raise VariableError.new(self, :gearbox_limit, 'to be an Array of positives', gears) \
            unless gears.is_a?(Array) && gears.all? { |num| num.positive? rescue false } # rubocop:disable Style/RescueModifier

      @limit = gears[@page - 1] || gears.last
    end

    # Asgnsi @offset based on the :gearbox_limit variable
    def assign_offset
      return super if !@vars[:gearbox_extra] || @vars[:limit_extra]

      gears   = @vars[:gearbox_limit]
      @offset = if @page <= gears.count
                  gears[0, @page - 1].sum
                else
                  gears.sum + (gears.last * (@page - gears.count - 1))
                end + @outset
    end

    # Assign @last based on the :gearbox_limit variable and @count
    def assign_last
      return super if !@vars[:gearbox_extra] || @vars[:limit_extra]

      gears = @vars[:gearbox_limit]
      # This algorithm is thousands of times faster than the one in the geared_pagination gem
      @last = (if count > (sum = gears.sum)
                 [((count - sum).to_f / gears.last).ceil, 1].max + gears.count
               else
                 pages     = 0
                 remainder = count
                 while remainder.positive?
                   pages     += 1
                   remainder -= gears[pages - 1]
                 end
                 [pages, 1].max
               end)
      @last = @vars[:max_pages] if @vars[:max_pages] && @last > @vars[:max_pages]
    end
  end
  prepend GearboxExtra
end
