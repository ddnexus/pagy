# frozen_string_literal: true
class Pagy
  class << self

    # deprecated posiitioal arguments
    def deprecated_arg(arg, val, new_key, new_val)
      value = val || new_val  # we use the new_val if present
      Warning.warn %([PAGY WARNING] deprecated use of positional '#{arg}' arg will not be supported in 5.0! Use only the keyword arg '#{new_key}: #{value.inspect}' instead.)
      value
    end

  end
end
