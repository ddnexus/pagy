# frozen_string_literal: true

require 'unit/test_helper'

describe 'Pagy::Offset Specs' do
  let(:pagy_class) { Pagy::Offset }

  describe 'initialization' do
    it 'initializes with defaults' do
      pagy = pagy_class.new(count: 100)
      _(pagy.page).must_equal 1
      _(pagy.limit).must_equal 20
      _(pagy.last).must_equal 5
      _(pagy.offset).must_equal 0
      _(pagy.from).must_equal 1
      _(pagy.to).must_equal 20
      _(pagy.in).must_equal 20
      _(pagy.previous).must_be_nil
      _(pagy.next).must_equal 2
    end

    it 'calculates variables for page 2' do
      pagy = pagy_class.new(count: 100, limit: 10, page: 2)
      _(pagy.page).must_equal 2
      _(pagy.last).must_equal 10
      _(pagy.offset).must_equal 10
      _(pagy.from).must_equal 11
      _(pagy.to).must_equal 20
      _(pagy.in).must_equal 10
      _(pagy.previous).must_equal 1
      _(pagy.next).must_equal 3
    end

    it 'calculates variables for last page' do
      pagy = pagy_class.new(count: 100, limit: 10, page: 10)
      _(pagy.page).must_equal 10
      _(pagy.offset).must_equal 90
      _(pagy.from).must_equal 91
      _(pagy.to).must_equal 100
      _(pagy.in).must_equal 10
      _(pagy.previous).must_equal 9
      _(pagy.next).must_be_nil
    end

    it 'handles count 0' do
      pagy = pagy_class.new(count: 0)
      _(pagy.last).must_equal 1
      _(pagy.page).must_equal 1
      _(pagy.offset).must_equal 0
      _(pagy.from).must_equal 0
      _(pagy.to).must_equal 0
      _(pagy.in).must_equal 0
      _(pagy.previous).must_be_nil
      _(pagy.next).must_be_nil
    end

    it 'handles max_pages' do
      # If page is > max_pages (but <= count/limit), it's out of logical range?
      # Logic: @last = max_pages if @last > max_pages
      # So if we ask for page 6, and last is clamped to 5:
      # in_range? checks @page <= @last (6 <= 5 is false) -> Error
      _ { pagy_class.new(count: 100, limit: 10, max_pages: 5, page: 6, raise_range_error: true) }.must_raise Pagy::RangeError
    end
  end

  describe 'identity' do
    it 'returns true for offset?' do
      _(pagy_class.new(count: 100).send(:offset?)).must_equal true
    end
  end

  describe '#records' do
    it 'calls offset and limit on collection' do
      collection = Minitest::Mock.new
      pagy = pagy_class.new(count: 100, page: 2, limit: 10)

      # Expect chain: collection.offset(10).limit(10)
      # We need the intermediate object returned by offset to expect limit
      intermediate = Minitest::Mock.new
      intermediate.expect :limit, :result, [10]

      collection.expect :offset, intermediate, [10]

      _(pagy.records(collection)).must_equal :result

      collection.verify
      intermediate.verify
    end
  end

  describe 'out of range handling' do
    it 'raises RangeError when raise_range_error: true' do
      _ { pagy_class.new(count: 100, page: 100, raise_range_error: true) }.must_raise Pagy::RangeError
    end

    it 'assigns empty page variables default (raise_range_error: false)' do
      # When not raising error, it assigns empty vars
      pagy = pagy_class.new(count: 100, page: 11, limit: 10)
      _(pagy.offset).must_equal 100 # Default calculation before empty check

      # Variables reset by assign_empty_page_variables
      _(pagy.from).must_equal 0
      _(pagy.to).must_equal 0
      _(pagy.in).must_equal 0
      _(pagy.previous).must_equal 10 # inherits last page
      _(pagy.next).must_be_nil
    end
  end
end
