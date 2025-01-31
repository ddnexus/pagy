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
      pagy, records = app.send(:pagy_offset, @collection)
      _(pagy).must_be_instance_of Pagy::Offset
      _(pagy.count).must_equal 1000
      _(pagy.limit).must_equal Pagy::DEFAULT[:limit]
      _(pagy.page).must_equal app.params[:page].to_i
      _(records.count).must_equal Pagy::DEFAULT[:limit]
      _(records).must_equal [41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60]
    end
    it 'paginates with options' do
      pagy, records = app.send(:pagy_offset, @collection, page: 2, limit: 10, anchor_string: 'X')
      _(pagy).must_be_instance_of Pagy::Offset
      _(pagy.count).must_equal 1000
      _(pagy.limit).must_equal pagy.limit
      _(pagy.page).must_equal 2
      _(pagy.options[:anchor_string]).must_equal 'X'
      _(records.count).must_equal 10
      _(records).must_equal [11, 12, 13, 14, 15, 16, 17, 18, 19, 20]
    end
  end

  describe '#pagy options' do
    before do
      @collection = MockCollection.new
    end
    it 'gets defaults' do
      options   = {}
      pagy,  = app.send(:pagy_offset, @collection, **options)
      merged = pagy.options
      _(merged.keys).must_include :count
      _(merged.keys).must_include :page
      _(merged[:count]).must_equal 1000
      _(merged[:page]).must_equal 3
    end
    it 'gets options' do
      options   = { page: 2, limit: 10, anchor_string: 'X' }
      pagy,  = app.send(:pagy_offset, @collection, **options)
      merged = pagy.options
      _(merged.keys).must_include :count
      _(merged.keys).must_include :page
      _(merged.keys).must_include :limit
      _(merged.keys).must_include :anchor_string
      _(merged[:count]).must_equal 1000
      _(merged[:page]).must_equal 2
      _(merged[:limit]).must_equal 10
      _(merged[:anchor_string]).must_equal 'X'
    end
    it 'works with grouped collections' do
      collection = MockCollection::Grouped.new((1..1000).to_a)
      options   = { page: 2, limit: 10, anchor_string: 'X' }
      pagy,  = app.send(:pagy_offset, collection, **options)
      merged = pagy.options
      _(merged.keys).must_include :count
      _(merged.keys).must_include :page
      _(merged.keys).must_include :limit
      _(merged.keys).must_include :anchor_string
      _(merged[:count]).must_equal 1000
      _(merged[:page]).must_equal 2
      _(merged[:limit]).must_equal 10
      _(merged[:anchor_string]).must_equal 'X'
    end
    it 'overrides count and page' do
      options   = { count: 100, page: 3 }
      pagy,  = app.send(:pagy_offset, @collection, **options)
      merged = pagy.options
      _(merged.keys).must_include :count
      _(merged[:count]).must_equal 100
      _(merged.keys).must_include :page
      _(merged[:page]).must_equal 3
    end
  end

  describe '#pagy_get_items' do
    it 'gets items' do
      collection = MockCollection.new
      _pagy, records = app.send(:pagy_offset, collection, page: 1)
      _(records).must_equal [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20]
    end
  end
end
