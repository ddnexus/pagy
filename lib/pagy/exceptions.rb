# frozen_string_literal: true

class Pagy
  # Generic variable error
  class VariableError < ArgumentError
    attr_reader :pagy, :variable, :value

    def initialize(pagy, variable, description, value = nil)
      @pagy     = pagy
      @variable = variable
      @value    = value
      message   = +"expected :#{@variable} #{description}"
      message  << "; got #{@value.inspect}" if value
      super message
    end
  end

  # Specific overflow error
  class OverflowError < VariableError; end

  # I18n configuration error
  class I18nError < StandardError; end

  # Generic internal error
  class InternalError < StandardError; end
end
