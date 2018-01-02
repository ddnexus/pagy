require "test_helper"

class ApiTest < Minitest::Test

  def setup
    @pagy = Pagy.new 100, 4
  end

  def test_that_it_has_a_version_number
    refute_nil ::Pagy::VERSION
  end

  def test_initialization
    assert_instance_of Pagy, @pagy
    assert_equal @pagy.options, Pagy::GlobalOptions.to_h
    assert_raises(ArgumentError) { Pagy.new(nil, 2) }
    assert_raises(ArgumentError) { Pagy.new(100, nil) }
    assert_raises(ArgumentError) { Pagy.new('100', 1) }
    assert_raises(ArgumentError) { Pagy.new(100, '2') }
    assert_raises(ArgumentError) { Pagy.new(100, 0) }
    assert_raises(ArgumentError) { Pagy.new(100, 12 ) }
    assert_raises(ArgumentError) { Pagy.new(100, 2, max_items_per_page: '10' ) }
    assert_raises(RuntimeError)  { @pagy.options[:max_items_per_page] = 2}
  end

  def test_responds_to_accessors
    [:page, :total_items, :options].each do |meth|
      assert_respond_to @pagy, meth
    end
  end

  def test_responds_to_option_accessors
    [:max_items_per_page, :max_ending_pages, :max_before_pages,
     :max_after_pages, :overlapping_pages?].each do |meth|
      assert_respond_to @pagy, meth
    end
  end

  def test_responds_to_methods
    [:offset, :limit, :total_pages, :last_page, :first_page?, :last_page?, :from_item, :to_item,
     :previous_page, :next_page, :before_pages, :after_pages, :beginning_pages, :ending_pages,
     :before_gap?, :after_gap?].each do |meth|
      assert_respond_to @pagy, meth
    end
  end

end
