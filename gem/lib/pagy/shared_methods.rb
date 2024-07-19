# frozen_string_literal: true

class Pagy
  # Shared with Keyset
  module SharedMethods
    attr_reader :page, :limit, :vars

    # Validates and assign the passed vars: var must be present and value.to_i must be >= to min
    def assign_and_check(name_min)
      name_min.each do |name, min|
        raise VariableError.new(self, name, ">= #{min}", @vars[name]) \
        unless @vars[name]&.respond_to?(:to_i) && \
               instance_variable_set(:"@#{name}", @vars[name].to_i) >= min
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
end
