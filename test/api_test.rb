require "test_helper"

class ApiTest < Minitest::Test

  def setup
    @pagy = Pagy.new count: 100, page: 4
  end

  def test_version_number
    refute_nil Pagy::VERSION
  end

  def test_initialization
    assert_instance_of Pagy, @pagy
    assert_instance_of Pagy, Pagy.new(count: 100)
    assert_instance_of Pagy, Pagy.new(count: '100')
    assert_instance_of Pagy, Pagy.new(count: 100, page: '2')
    assert_instance_of Pagy, Pagy.new(count: 100, page: '')
    assert_instance_of Pagy, Pagy.new(count: 100, items: '10')
    assert_raises(ArgumentError) { Pagy.new({}) }
    assert_raises(ArgumentError) { Pagy.new(count: 100, page: 0) }
    assert_raises(ArgumentError) { Pagy.new(count: 100, page: 2, items: 0) }
    assert_raises(ArgumentError) { Pagy.new(count: 100, page: 2, size: [1,2,3]).series }
    assert_raises(ArgumentError) { Pagy.new(count: 100, page: 2, size: [1,2,3,'4']).series }
    assert_raises(Pagy::OutOfRangeError) { Pagy.new(count: 100, page: '11') }
    assert_raises(Pagy::OutOfRangeError) { Pagy.new(count: 100, page: 12 ) }
  end

  def test_respond_to_accessors
    [:count, :page, :items, :vars, # input
     :offset, :pages, :last, :from, :to, :prev, :next, :series # output
    ].each do |meth|
      assert_respond_to @pagy, meth
    end
  end

end
