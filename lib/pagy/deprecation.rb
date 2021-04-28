# frozen_string_literal: true
class Pagy
  class << self

    # deprecated variables
    def deprecated_var(var, val, new_var, new_val)
      value = new_val || val
      Warning.warn %([PAGY WARNING] deprecated use of `#{var}` var will not be supported in 5.0! Use `#{new_var}: #{value.inspect}` instead.)
      value
    end

    # deprecated pagy_url_for argument order
    def deprecated_order(pagy, page)
      Warning.warn '[PAGY WARNING] inverted use of pagy/page in pagy_url_for will not be supported in 5.0! Use pagy_url_for(pagy, page) instead.'
      [page, pagy]
    end


    # deprecated posiitioal arguments
    def deprecated_arg(arg, val, new_key, new_val)
      value = new_val || val  # we use the new_val if present
      Warning.warn %([PAGY WARNING] deprecated use of positional `#{arg}` arg will not be supported in 5.0! Use only the keyword arg `#{new_key}: #{value.inspect}` instead.)
      value
    end

  end
end
