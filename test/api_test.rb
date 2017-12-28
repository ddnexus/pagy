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
    assert_raises(ArgumentError) { Pagy.new(100, 2, items_per_page: '10' ) }
    assert_raises(RuntimeError)  { @pagy.options[:items_per_page] = 2}
  end

  def test_responds_to_accessors
    [:page, :current_page, :total_items, :options].each do |meth|
      assert_respond_to @pagy, meth
    end
  end

  def test_responds_to_option_accessors
    [:items_per_page, :number_of_ending_pages, :number_of_before_pages,
     :number_of_after_pages, :remove_overlapping_pages].each do |meth|
      assert_respond_to @pagy, meth
    end
  end

  def test_responds_to_methods
    [:offset, :limit, :total_pages, :last_page, :first_page?, :last_page?, :page_first_item, :page_last_item,
     :previous_page, :next_page, :before_pages, :after_pages, :starting_pages, :ending_pages,
     :left_gap?, :right_gap?].each do |meth|
      assert_respond_to @pagy, meth
    end
  end

end
