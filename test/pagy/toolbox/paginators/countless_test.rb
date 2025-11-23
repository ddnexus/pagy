# frozen_string_literal: true

require_relative '../../../test_helper'
require_relative '../../../mock_helpers/collection'
require_relative '../../../mock_helpers/app'
require_relative '../../../../gem/lib/pagy/toolbox/helpers/support/series' # just to check the series

describe 'countless' do
  let(:app) { MockApp.new }
  let(:last_page) { 1000 / 20 }
  before do
    @default_page_sym = :page
    @collection       = MockCollection.new
  end

  describe 'countless' do
    it 'shows current and next for first page' do
      pagy, = MockApp.new(params: { page: nil })
                     .send(:pagy, :countless, @collection)

      _(pagy.send(:series)).must_equal ['1', 2]
      _(pagy.count).must_be_nil
      _(pagy.previous).must_be_nil
      _(pagy.next).must_equal 2
    end
    it 'shows start-pages, :gap, before-pages, current and next for intermediate page' do
      pagy, = MockApp.new(params: { page: '25 26' })
                     .send(:pagy, :countless, @collection)

      _(pagy.send(:series)).must_equal [1, :gap, 22, 23, 24, '25', 26]
      _(pagy.count).must_be_nil
      _(pagy.previous).must_equal 24
      _(pagy.next).must_equal 26
    end
    it 'shows start-pages, :gap, before-pages, current and next for last page' do
      pagy, = MockApp.new(params: { page: '50 50' })
                     .send(:pagy, :countless, @collection)

      _(pagy.send(:series)).must_equal [1, :gap, 46, 47, 48, 49, '50']
      _(pagy.count).must_be_nil
      _(pagy.previous).must_equal 49
      _(pagy.next).must_be_nil
    end
    it 'returns empty series for empty :slots option for first page' do
      pagy, = MockApp.new(params: { page: nil })
                     .send(:pagy, :countless, @collection, slots: 0)

      _(pagy.send(:series)).must_equal []
      _(pagy.count).must_be_nil
      _(pagy.previous).must_be_nil
      _(pagy.next).must_equal 2
      # _(pagy.last).must_be_nil
    end
    it 'returns empty series for empty :slots option for intermediate page' do
      pagy, = MockApp.new(params: { page: '25 26' })
                     .send(:pagy, :countless, @collection, slots: 0)

      _(pagy.send(:series)).must_equal []
      _(pagy.count).must_be_nil
      _(pagy.previous).must_equal 24
      _(pagy.next).must_equal 26
      _(pagy.last).must_equal 26
    end
    it 'returns empty series for empty :slots option for last page' do
      pagy, = MockApp.new(params: { page: '50 50' })
                     .send(:pagy, :countless, @collection, slots: 0)

      _(pagy.send(:series)).must_equal []
      _(pagy.count).must_be_nil
      _(pagy.previous).must_equal 49
      _(pagy.next).must_be_nil
      _(pagy.last).must_equal 50
    end
    it 'returns empty series for empty :slots option for last page' do
      pagy, = MockApp.new.send(:pagy, :countless, MockCollection.new([]))

      _(pagy.instance_variable_get(:@count)).must_equal 0
      _(pagy.info_tag).must_match 'No items found'
    end
  end

  describe 'countless get_vars' do
    let(:app) { MockApp.new(params: { a: 'a', page: 3, page_number: 4 }) }
    it 'sets :page_key from options' do
      pagy, paged = MockApp.new(params: { page_number: '4 4'})
                           .send(:pagy, :countless, @collection, page_key: 'page_number')

      _(pagy.count).must_be_nil
      _(pagy.page).must_equal 4
      _(paged).must_equal Array(61..80)
    end
    it 'bypasses :page_key with :page option' do
      pagy, paged = app.send(:pagy, :countless, @collection, page_key: :page_number, page: 1)

      _(pagy.count).must_be_nil
      _(pagy.page).must_equal 1
      _(paged).must_equal Array(1..20)
    end
    it 'can use :headless with page param without last' do
      app   = MockApp.new(params: { page: 25 })
      pagy, = app.send(:pagy, :countless, @collection, headless: true)

      _(pagy.count).must_be_nil
      _(pagy.previous).must_be_nil
      _(pagy.next).must_be_nil
      _(pagy.last).must_be_nil
    end
  end
  describe 'Keep last' do
    it 'shows series including last page' do
      pagy, = MockApp.new(params: {page: '25 50'})
                     .send(:pagy, :countless, @collection)

      _(pagy.send(:series)).must_equal [1, :gap, 24, "25", 26, :gap, 50]
      _(pagy.count).must_be_nil
      _(pagy.previous).must_equal 24
      _(pagy.next).must_equal 26
      _(pagy.last).must_equal 50
    end
    it 'shows series including last page' do
      pagy, = MockApp.new(params: { a: 'a', page: ' 3'})
                     .send(:pagy, :countless, @collection)

      _(pagy.send(:series)).must_equal ["1", 2, 3]
      _(pagy.count).must_be_nil
      _(pagy.previous).must_be_nil
      _(pagy.next).must_equal 2
      _(pagy.last).must_equal 3
    end
  end
end
