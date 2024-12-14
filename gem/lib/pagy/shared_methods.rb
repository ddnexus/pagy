# frozen_string_literal: true

class Pagy
  # Shared with Keyset
  module SharedMethods
    attr_reader :page, :limit, :vars

    # Validates and assign the passed vars: var must be present and value.to_i must be >= to min
    def assign_and_check(name_min)
      name_min.each do |name, min|
        raise VariableError.new(self, name, ">= #{min}", @vars[name]) \
              unless @vars[name]&.respond_to?(:to_i) && instance_variable_set(:"@#{name}", @vars[name].to_i) >= min
      end
    end

    # Assign @limit (overridden by the gearbox extra)
    def assign_limit
      assign_and_check(limit: 1)
    end

    # Assign @vars
    def assign_vars(default, vars)
      @vars = { **default, **vars.delete_if { |k, v| default.key?(k) && (v.nil? || v == '') } }
    end
  end

  # Shared with KeysetForUI
  module SharedUIMethods
    attr_reader :in, :last, :prev
    alias pages last

    # Label for the current page. Allow the customization of the output (overridden by the calendar extra)
    def label = @page.to_s

    # Label for any page. Allow the customization of the output (overridden by the calendar extra)
    def label_for(page) = page.to_s

    # Return the array of page numbers and :gap e.g. [1, :gap, 8, "9", 10, :gap, 36]
    def series(size: @vars[:size], **_)
      raise VariableError.new(self, :size, 'to be an Integer >= 0', size) \
      unless size.is_a?(Integer) && size >= 0
      return [] if size.zero?

      [].tap do |series|
        if size >= @last
          series.push(*1..@last)
        else
          left  = ((size - 1) / 2.0).floor             # left half might be 1 page shorter for even size
          start = if @page <= left                     # beginning pages
                    1
                  elsif @page > (@last - size + left)  # end pages
                    @last - size + 1
                  else                                 # intermediate pages
                    @page - left
                  end
          series.push(*start...start + size)
          # Set first and last pages plus gaps when needed, respecting the size
          if vars[:ends] && size >= 7
            series[0]  = 1
            series[1]  = :gap  unless series[1]  == 2
            series[-2] = :gap  unless series[-2] == @last - 1
            series[-1] = @last
          end
        end
        series[series.index(@page)] = @page.to_s
      end
    end
  end
end
