class TestController
  include Pagy::Backend

  attr_reader :params

  def initialize(params={a: 'a', page: 3})
    @params = params
  end

end

class TestCollection < Array

  def initialize(*args)
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

  def group_values
    []
  end

end

class TestGroupedCollection < TestCollection

  def count(*)
    @collection.map { |value| [value, value + 1] }.to_h
  end

  def group_values
    [:field]
  end
end
