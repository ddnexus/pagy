# frozen_string_literal: true

require 'active_record'
require 'yaml'

require 'active_support'
require 'active_support/core_ext/time'
require 'active_support/core_ext/date_and_time/calculations'
require 'active_support/core_ext/numeric/time'
require 'active_support/core_ext/integer/time'

class MockCollection < Array
  def initialize(arr = Array(1..1000))
    super
    @collection = clone
  end

  def offset(value)
    @collection = self[value..] || []
    self
  end

  def limit(value)
    @collection.empty? ? [] : @collection[0, value]
  end

  def count(*)
    size
  end

  def pick(*)
    size
  end

  class Grouped < MockCollection
    def count(*)
      @collection.to_h { |v| [v, v + 1] }
    end

    def is_a?(*) = true

    def unscope(*)
      self
    end

    def group_values
      [:other_table_id]
    end
  end
end
