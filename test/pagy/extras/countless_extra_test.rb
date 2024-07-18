# frozen_string_literal: true

require_relative '../../test_helper'
require 'pagy/extras/countless'

require_relative '../../mock_helpers/collection'
require_relative '../../mock_helpers/app'

describe 'pagy/extras/countless' do
  let(:app) { MockApp.new }
  let(:last_page) { 1000 / 20 }
  before do
    @default_page_param = Pagy::DEFAULT[:page_param]
    @collection         = MockCollection.new
  end
  after do
    Pagy::DEFAULT[:page_param] = @default_page_param
  end

  describe '#pagy_countless' do
    it 'shows current and next for first page' do
      pagy, = app.send(:pagy_countless, @collection, page: 1)
      _(pagy.series).must_equal ['1', 2]
      _(pagy.count).must_be_nil
      _(pagy.prev).must_be_nil
      _(pagy.next).must_equal 2
    end
    it 'shows start-pages, :gap, before-pages, current and next for intermediate page' do
      pagy, = app.send(:pagy_countless, @collection, page: 25)
      _(pagy.series).must_equal [1, :gap, 22, 23, 24, '25', 26]
      _(pagy.count).must_be_nil
      _(pagy.prev).must_equal 24
      _(pagy.next).must_equal 26
    end
    it 'shows start-pages, :gap, before-pages, current and next for last page' do
      pagy, = app.send(:pagy_countless, @collection, page: last_page)
      _(pagy.series).must_equal [1, :gap, 46, 47, 48, 49, '50']
      _(pagy.count).must_be_nil
      _(pagy.prev).must_equal 49
      _(pagy.next).must_be_nil
    end
    it 'returns empty series for empty :size variable for first page' do
      pagy, = app.send(:pagy_countless, @collection, size: 0, page: 1)
      _(pagy.series).must_equal []
      _(pagy.count).must_be_nil
      _(pagy.prev).must_be_nil
      _(pagy.next).must_equal 2
    end
    it 'returns empty series for empty :size variable for intermediate page' do
      pagy, = app.send(:pagy_countless, @collection, size: 0, page: 25)
      _(pagy.series).must_equal []
      _(pagy.count).must_be_nil
      _(pagy.prev).must_equal 24
      _(pagy.next).must_equal 26
    end
    it 'returns empty series for empty :size variable for last page' do
      pagy, = app.send(:pagy_countless, @collection, size: 0, page: last_page)
      _(pagy.series).must_equal []
      _(pagy.count).must_be_nil
      _(pagy.prev).must_equal 49
      _(pagy.next).must_be_nil
    end
  end

  describe '#pagy_countless_get_vars' do
    let(:app) { MockApp.new(params: { a: 'a', page: 3, page_number: 4 }) }
    it 'sets :page_param from defaults' do
      Pagy::DEFAULT[:page_param] = :page_number
      pagy, paged = app.send(:pagy_countless, @collection)
      _(pagy.count).must_be_nil
      _(pagy.page).must_equal 4
      _(paged).must_equal Array(61..80)
    end
    it 'sets :page_param from vars' do
      Pagy::DEFAULT[:page_param] = :page
      pagy, paged = app.send(:pagy_countless, @collection, page_param: :page_number)
      _(pagy.count).must_be_nil
      _(pagy.page).must_equal 4
      _(paged).must_equal Array(61..80)
    end
    it 'bypasses :page_param with :page variable' do
      Pagy::DEFAULT[:page_param] = :another_page_number
      pagy, paged = app.send(:pagy_countless, @collection, page_param: :page_number, page: 1)
      _(pagy.count).must_be_nil
      _(pagy.page).must_equal 1
      _(paged).must_equal Array(1..20)
    end
    it 'can use :countless_minimal' do
      pagy, = app.send(:pagy_countless, @collection, page: 25, countless_minimal: true)
      _(pagy.series).must_be_nil
      _(pagy.count).must_be_nil
      _(pagy.prev).must_be_nil
      _(pagy.next).must_be_nil
    end
  end
end
