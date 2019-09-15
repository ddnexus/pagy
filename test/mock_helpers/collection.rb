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
    @collection[0, value]
  end

  def count(*)
    size
  end

  def unscope(*)
    self
  end

  class Grouped < MockCollection

    def count(*)
      Hash[@collection.map { |value| [value, value + 1] }]
    end

  end
end
