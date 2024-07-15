# See the Pagy documentation: https://ddnexus.github.io/pagy/docs/extras/gearbox
# frozen_string_literal: true

class Pagy # :nodoc:
  DEFAULT[:gearbox_extra] = true # extra enabled by default
  DEFAULT[:gearbox_items] = [15, 30, 60, 100]

  # Automatically change the number of items per page depending on the page number
  # accepts an array as the :gearbox_items variable, that will determine the items for the first pages
  module GearboxExtra
    # Setup @items based on the :gearbox_items variable
    def assign_items
      return super if !@vars[:gearbox_extra] || @vars[:items_extra]

      gears = @vars[:gearbox_items]
      raise VariableError.new(self, :gearbox_items, 'to be an Array of positives', gears) \
            unless gears.is_a?(Array) && gears.all? { |num| num.positive? rescue false } # rubocop:disable Style/RescueModifier

      @items = gears[@page - 1] || gears.last
    end

    # Setup @offset based on the :gearbox_items variable
    def assign_offset
      return super if !@vars[:gearbox_extra] || @vars[:items_extra]

      gears   = @vars[:gearbox_items]
      @offset = if @page <= gears.count
                  gears[0, @page - 1].sum
                else
                  gears.sum + (gears.last * (@page - gears.count - 1))
                end + @outset
    end

    # Setup Pagy @last based on the :gearbox_items variable and @count
    def assign_last
      return super if !@vars[:gearbox_extra] || @vars[:items_extra]

      gears = @vars[:gearbox_items]
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
