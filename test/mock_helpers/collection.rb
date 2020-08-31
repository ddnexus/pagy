class MockCollection < Array

  def initialize(arr=Array(1..1000))
    super
    @collection = self.clone
  end

  def offset(value)
    @collection = self[value..-1]
    self
  end

  def limit(value)
    if value == 1
      self # used in pluck
    else
      @collection[0, value]
    end
  end

  def count(*)
    size
  end

  def pluck(*)
    [size]
  end

  def group_values
    []
  end

  def reorder(order)
    self
  end

  class Grouped < MockCollection

    def count(*)
      Hash[@collection.map { |value| [value, value + 1] }]
    end

    def unscope(*)
      self
    end

    def group_values
      [:other_table_id]
    end

  end
end
