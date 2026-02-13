# frozen_string_literal: true

require 'unit/test_helper'
require 'mocks/app'

describe 'Pagy::Method' do
  let(:collection) { Pet.all }

  describe '#pagy (Offset default)' do
    it 'paginates with defaults' do
      # MockApp defaults to params: { page: 3 }
      app = MockApp.new
      pagy, records = app.pagy(collection)

      _(pagy).must_be_kind_of Pagy::Offset
      _(pagy.count).must_equal 50   # From Pet seeds
      _(pagy.page).must_equal 3     # From MockApp default
      _(pagy.limit).must_equal 20   # Pagy default
      _(records.size).must_equal 10 # 50 total, limit 20, page 3 -> items 41-50 (10 items)
    end
  end

  describe '#pagy (Explicit Paginator)' do
    it 'delegates to Keyset' do
      # Initialize with empty params to avoid default page=3 (keyset expects nil or token)
      app = MockApp.new(params: {})

      # Keyset requires ordered collection
      pagy, = app.pagy(:keyset, Pet.order(:id))

      _(pagy).must_be_kind_of Pagy::Keyset
    end
  end

  describe '#pagy (Calendar)' do
    it 'delegates to Calendar' do
      # Use MockApp::Calendar to support the callbacks required by CalendarPaginator
      app = MockApp::Calendar.new

      # Seeds range: 2021-10-21 to 2023-11-13.
      period = [Time.zone.local(2021, 10, 21), Time.zone.local(2023, 11, 13)]
      calendar, pagy, records = app.pagy(:calendar, Event.all, month: { period: period })
      _(calendar).must_be_kind_of Pagy::Calendar
      _(calendar[:month]).must_be_kind_of Pagy::Calendar::Month
      _(pagy).must_be_kind_of Pagy::Offset
      _(records).must_be_kind_of ActiveRecord::Relation
    end
  end

  describe 'JSON:API support' do
    it 'enforces root_key :page' do
      # Simulate JSON:API params structure: ?page[number]=2
      params = { 'page' => { 'number' => '2' } }
      app    = MockApp.new(params: params)

      # jsonapi: true -> enforces root_key='page'.
      # We assume the user mapped 'page_key' to 'number' to match their API.
      pagy, = app.pagy(collection, jsonapi: true, page_key: 'number')

      _(pagy.page).must_equal 2
      _(pagy.options[:root_key]).must_equal 'page'
    end
  end

  describe 'Custom Request' do
    it 'overrides controller request with options[:request]' do
      app = MockApp.new(params: { page: 1 })

      # Inject a custom request hash (simulating what Pagy::Request accepts)
      # mimic page 5
      custom_req = { params: { 'page' => 5 }, path: '/custom' }
      pagy,      = app.pagy(collection, request: custom_req)

      _(pagy.page).must_equal 5
    end
  end
end
