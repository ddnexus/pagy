# frozen_string_literal: true

require 'test_helper'

describe Pagy::Offset::Countless do
  let(:pagy_class) { Pagy::Offset::Countless }

  describe 'initialization' do
    it 'initializes with defaults' do
      pagy = pagy_class.new
      _(pagy.page).must_equal 1
      _(pagy.limit).must_equal 20
      _(pagy.offset).must_equal 0
      _(pagy.last).must_be_nil # Unknown initially
    end

    it 'handles specific defaults' do
      pagy = pagy_class.new(page: 2, limit: 10)
      _(pagy.page).must_equal 2
      _(pagy.limit).must_equal 10
      _(pagy.offset).must_equal 10
    end

    it 'handles max_pages' do
      pagy = pagy_class.new(page: 10, max_pages: 5)
      _(pagy.page).must_equal 5 # clamped
    end
  end

  describe 'identity' do
    it 'returns true for countless?' do
      _(pagy_class.new.send(:countless?)).must_equal true
    end

    it 'returns true for offset?' do
      _(pagy_class.new.send(:offset?)).must_equal true
    end
  end

  describe '#records' do
    let(:collection) { Minitest::Mock.new }

    it 'fetches limit + 1 items and returns limit items' do
      pagy = pagy_class.new(limit: 10)

      # Mock chain: collection.offset(0).limit(11).to_a
      # Return 11 items (indicating more pages exist)
      items = (1..11).to_a

      intermediate = Minitest::Mock.new
      intermediate.expect :limit, intermediate, [11]
      intermediate.expect :to_a, items

      collection.expect :offset, intermediate, [0]

      result = pagy.records(collection)

      _(result).must_equal (1..10).to_a # Returns only 10
      _(pagy.last).must_equal 2         # Inferred next page
      _(pagy.next).must_equal 2

      collection.verify
    end

    it 'handles end of collection (fetches <= limit)' do
      pagy = pagy_class.new(limit: 10)

      # Return 5 items (less than limit 10)
      items = (1..5).to_a

      intermediate = Minitest::Mock.new
      intermediate.expect :limit, intermediate, [11]
      intermediate.expect :to_a, items

      collection.expect :offset, intermediate, [0]

      result = pagy.records(collection)

      _(result).must_equal items
      _(pagy.last).must_equal 1
      _(pagy.next).must_be_nil
    end

    it 'handles empty collection on page 1' do
      pagy = pagy_class.new(limit: 10)

      intermediate = Minitest::Mock.new
      intermediate.expect :limit, intermediate, [11]
      intermediate.expect :to_a, []

      collection.expect :offset, intermediate, [0]

      result = pagy.records(collection)

      _(result).must_equal []
      _(pagy.count).must_equal 0
      _(pagy.last).must_equal 1
      _(pagy.in).must_equal 0
    end
  end

  describe 'headless mode' do
    it 'calls super implementation without finalizing' do
      pagy = pagy_class.new(limit: 10, headless: true)
      collection = Minitest::Mock.new

      # Headless just calls generic offset/limit
      intermediate = Minitest::Mock.new
      intermediate.expect :limit, :result, [10]
      collection.expect :offset, intermediate, [0]

      _(pagy.records(collection)).must_equal :result
      _(pagy.last).must_be_nil
    end
  end

  describe 'finalization logic' do
    it 'handles out of range (page > exist)' do
      pagy = pagy_class.new(page: 2, limit: 10)

      # finalize with 0 items fetched
      pagy.send(:finalize, 0)

      # Should trigger assign_empty_page_variables
      _(pagy.in).must_equal 0
      _(pagy.from).must_equal 0
      _(pagy.to).must_equal 0
      _(pagy.last).must_equal 1
      _(pagy.previous).must_equal 1
    end

    it 'preserves known last page when iterating (past && more)' do
      # Case: We are on page 2, we know last is 5 (past=true).
      # We fetch 11 items (limit 10), so more=true.
      # This hits "unless past && more", skipping the @last update.
      pagy = pagy_class.new(page: 2, limit: 10, last: 5)

      # Simulate fetching 11 items (one more than limit)
      pagy.send(:finalize, 11)

      _(pagy.last).must_equal 5 # Should NOT update to 3 (@page + 1)
      _(pagy.next).must_equal 3
    end
  end

  describe 'compose_page_param' do
    it 'returns EscapedValue with page+last' do
      pagy = pagy_class.new
      # Manually set last for test
      pagy.instance_variable_set(:@last, 5)

      val = pagy.send(:compose_page_param, 3)
      _(val).must_be_kind_of Pagy::EscapedValue
      _(val).must_equal '3+5'
    end

    it 'defaults page to 1' do
      pagy = pagy_class.new
      pagy.instance_variable_set(:@last, 10)

      val = pagy.send(:compose_page_param, nil)
      _(val).must_equal '1+10'
    end
  end
end
