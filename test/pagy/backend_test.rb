# frozen_string_literal: true

require_relative '../test_helper'

require_relative '../mock_helpers/collection'
require_relative '../mock_helpers/app'

describe 'pagy/backend' do
  let(:app) { MockApp.new }

  describe '#pagy' do
    before do
      @collection = MockCollection.new
    end
    it 'paginates with defaults' do
      pagy, records = app.send(:pagy, @collection)
      _(pagy).must_be_instance_of Pagy
      _(pagy.count).must_equal 1000
      _(pagy.items).must_equal Pagy::DEFAULT[:items]
      _(pagy.page).must_equal app.params[:page]
      _(records.count).must_equal Pagy::DEFAULT[:items]
      _(records).must_equal [41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60]
    end
    it 'paginates with vars' do
      pagy, records = app.send(:pagy, @collection, page: 2, items: 10, anchor_string: 'X')
      _(pagy).must_be_instance_of Pagy
      _(pagy.count).must_equal 1000
      _(pagy.items).must_equal 10
      _(pagy.page).must_equal 2
      _(pagy.vars[:anchor_string]).must_equal 'X'
      _(records.count).must_equal 10
      _(records).must_equal [11, 12, 13, 14, 15, 16, 17, 18, 19, 20]
    end
  end

  describe '#pagy_get_vars' do
    before do
      @collection = MockCollection.new
    end
    it 'gets defaults' do
      vars   = {}
      merged = app.send :pagy_get_vars, @collection, vars
      _(merged.keys).must_include :count
      _(merged.keys).must_include :page
      _(merged[:count]).must_equal 1000
      _(merged[:page]).must_equal 3
    end
    it 'gets vars' do
      vars   = { page: 2, items: 10, anchor_string: 'X' }
      merged = app.send :pagy_get_vars, @collection, vars
      _(merged.keys).must_include :count
      _(merged.keys).must_include :page
      _(merged.keys).must_include :items
      _(merged.keys).must_include :anchor_string
      _(merged[:count]).must_equal 1000
      _(merged[:page]).must_equal 2
      _(merged[:items]).must_equal 10
      _(merged[:anchor_string]).must_equal 'X'
    end
    it 'works with grouped collections' do
      collection = MockCollection::Grouped.new((1..1000).to_a)
      vars   = { page: 2, items: 10, anchor_string: 'X' }
      merged = app.send :pagy_get_vars, collection, vars
      _(collection.count.size).must_equal 1000
      _(merged.keys).must_include :count
      _(merged.keys).must_include :page
      _(merged.keys).must_include :items
      _(merged.keys).must_include :anchor_string
      _(merged[:count]).must_equal 1000
      _(merged[:page]).must_equal 2
      _(merged[:items]).must_equal 10
      _(merged[:anchor_string]).must_equal 'X'
    end
    it 'overrides count and page' do
      vars   = { count: 10, page: 32 }
      merged = app.send :pagy_get_vars, @collection, vars
      _(merged.keys).must_include :count
      _(merged[:count]).must_equal 10
      _(merged.keys).must_include :page
      _(merged[:page]).must_equal 32
    end
  end

  describe '#pagy_get_records' do
    it 'gets items' do
      collection = MockCollection.new
      pagy       = Pagy.new count: 1000
      items      = app.send :pagy_get_records, collection, pagy
      _(items).must_equal [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20]
    end
  end
end
