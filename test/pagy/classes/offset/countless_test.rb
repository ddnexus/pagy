# frozen_string_literal: true

require_relative '../../../test_helper'
require_relative '../../../mock_helpers/app'
require_relative '../../../../gem/lib/pagy/toolbox/helpers/support/series' # just to check the series

describe 'Pagy Countless' do
  let(:app) { MockApp.new }
  describe 'finalize' do
    it 'initializes empty collection' do
      pagy, = Pagy::Offset::Countless.new(page: 1)
      pagy.send(:finalize, 0)

      _(pagy.count).must_equal 0
      _(pagy.limit).must_equal 20
      _(pagy.last).must_equal 1
      _(pagy.last).must_equal 1
      _(pagy.in).must_equal 0
      _(pagy.from).must_equal 0
      _(pagy.to).must_equal 0
      _(pagy.previous).must_be_nil
      _(pagy.next).must_be_nil
    end
    it 'initializes first page' do
      pagy, = Pagy::Offset::Countless.new(page: 1)
      pagy.send(:finalize, 21) # one more page

      _(pagy.count).must_be_nil
      _(pagy).must_be_instance_of Pagy::Offset::Countless
      _(pagy.limit).must_equal 20
      _(pagy.last).must_equal 2
      _(pagy.in).must_equal 20
      _(pagy.from).must_equal 1
      _(pagy.to).must_equal 20
      _(pagy.previous).must_be_nil
      _(pagy.next).must_equal 2
    end
    it 'initializes single full page' do
      pagy, = Pagy::Offset::Countless.new
      pagy.send(:finalize, 20) # no more page - last full

      _(pagy.count).must_be_nil
      _(pagy.limit).must_equal 20
      _(pagy.last).must_equal 1
      _(pagy.in).must_equal 20
      _(pagy.from).must_equal 1
      _(pagy.to).must_equal 20
      _(pagy.previous).must_be_nil
      _(pagy.next).must_be_nil
    end
    it 'initialize single partial page' do
      pagy, = Pagy::Offset::Countless.new
      pagy.send(:finalize, 4) # partial page of 4 - also last

      _(pagy.count).must_be_nil
      _(pagy.limit).must_equal 20
      _(pagy.last).must_equal 1
      _(pagy.in).must_equal 4
      _(pagy.from).must_equal 1
      _(pagy.to).must_equal 4
      _(pagy.previous).must_be_nil
      _(pagy.next).must_be_nil
    end
    it 'initializes last partial page' do
      pagy, = Pagy::Offset::Countless.new(page: 3, last: 3)
      pagy.send(:finalize, 19) # partial page of 3 - also last

      _(pagy.count).must_be_nil
      _(pagy.limit).must_equal 20
      _(pagy.last).must_equal 3
      _(pagy.in).must_equal 19
      _(pagy.from).must_equal 41
      _(pagy.to).must_equal 59
      _(pagy.previous).must_equal 2
      _(pagy.next).must_be_nil
    end
    it 'raises exception with no fetched records and page > 1' do
      _ { Pagy::Offset::Countless.new(page: 2, raise_range_error: true).send(:finalize, 0) }.must_raise Pagy::RangeError
    end
  end
  describe 'Handling the last page' do
    it 'gets the visited page' do
      pagy, = Pagy::Offset::Countless.new(page: 3, last: 5)
      pagy.send(:finalize, 21)

      _(pagy.limit).must_equal 20
      _(pagy.last).must_equal 5
      _(pagy.in).must_equal 20
      _(pagy.from).must_equal 41
      _(pagy.to).must_equal 60
      _(pagy.previous).must_equal 2
      _(pagy.next).must_equal 4
    end
    it 'updates the @last if visited page is the last page' do
      pagy, = Pagy::Offset::Countless.new(page: 3, last: 5)
      pagy.send(:finalize, 15)

      _(pagy.limit).must_equal 20
      _(pagy.last).must_equal 3
      _(pagy.in).must_equal 15
      _(pagy.from).must_equal 41
      _(pagy.to).must_equal 55
      _(pagy.previous).must_equal 2
      _(pagy.next).must_be_nil
    end
  end
  describe 'Handling the :max_pages option' do
    it 'gets the visited page' do
      pagy, = Pagy::Offset::Countless.new(page: 20, max_pages: 15)
      pagy.send(:finalize, 21)

      _(pagy.page).must_equal 15
      _(pagy.last).must_equal 15
      _(pagy.in).must_equal 20
      _(pagy.limit).must_equal 20
      _(pagy.offset).must_equal 280
      _(pagy.from).must_equal 281
      _(pagy.to).must_equal 300
      _(pagy.previous).must_equal 14
      _(pagy.next).must_be_nil
      _(pagy.send(:series)).must_equal [1, :gap, 11, 12, 13, 14, "15"]
    end
  end
end
