# frozen_string_literal: true

class Pagy
  # Generic variable error
  class VariableError < ArgumentError
    attr_reader :pagy, :variable, :value

    # Set the variables and prepare the message
    def initialize(pagy, variable, description, value)
      @pagy     = pagy
      @variable = variable
      @value    = value
      super "expected :#{@variable} #{description}; got #{@value.inspect}"
    end
  end

  # Specific overflow error
  class OverflowError < VariableError; end

  # I18n configuration error
  class I18nError < StandardError; end

  # Generic internal error
  class InternalError < StandardError; end
end
