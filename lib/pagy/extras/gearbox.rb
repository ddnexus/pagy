# See the Pagy documentation: https://ddnexus.github.io/pagy/extras/gearbox
# frozen_string_literal: true

class Pagy
  VARS[:gearbox_extra] = true   # extra enabled by default
  VARS[:gearbox_items] = [15, 30, 60, 100]
  # Automatically change the number of items depending on the page number
  # accepts an array as the :gearbox_items variable, that will determine the items for the first pages
  module UseGearboxExtra

    # setup @items based on the :items variable
    def setup_items_var
      return super if !@vars[:gearbox_extra] || @vars[:items_extra]

      items = @vars[:gearbox_items]
      raise VariableError.new(self), "expected :items to be positive or Array of positives; got #{items.inspect}" \
            unless items.is_a?(Array) && items.all? { |num| num.positive? rescue false }   # rubocop:disable Style/RescueModifier

      @items = items[@page-1] || items.last
    end

    # setup @pages and @last based on the :items variable
    def setup_pages_var
      return super if !@vars[:gearbox_extra] || @vars[:items_extra]

      # this algorithm is thousands of times faster than its equivalent in geared pagination
      items  = @vars[:gearbox_items]
      @pages = @last = ( items_sum = items.sum
                         if @count > items_sum
                           [((@count - items_sum).to_f / items.last).ceil, 1].max + items.count
                         else
                           rest  = @count
                           pages = 0
                           while rest.positive?
                             pages += 1
                             rest  -= items[pages-1]
                           end
                           [pages, 1].max
                         end )
    end
  end
  prepend UseGearboxExtra

end
