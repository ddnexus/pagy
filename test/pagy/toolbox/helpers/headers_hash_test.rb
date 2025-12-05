# frozen_string_literal: true

require 'test_helper'
require 'mock_helpers/collection'
require 'mock_helpers/app'
require 'files/models'

describe 'headers_hash' do
  describe 'headers_hash with Offset' do
    let(:app) { MockApp.new(params: { a: 'one', b: 'two' }) }
    before do
      @collection = MockCollection.new
    end
    it 'returns the full headers hash' do
      pagy, = app.pagy(:offset, @collection)
      _(pagy.headers_hash).must_rematch :headers
    end
    it 'returns custom headers hash' do
      pagy, = app.pagy(:offset, @collection, headers_map: { limit: 'Per-Page', count: 'Total', pages: false })
      _(pagy.headers_hash).must_rematch :headers
    end
    it 'returns custom headers hash' do
      pagy, = app.pagy(:offset, @collection, headers_map: { limit: false, count: false })
      _(pagy.headers_hash).must_rematch :headers
    end
    it 'returns the countless headers hash' do
      pagy, = app.pagy(:countless, @collection)
      _(pagy.headers_hash).must_rematch :headers
    end
    it 'omit previous on first page' do
      pagy, = app.pagy(:offset, @collection, page: 1)
      _(pagy.headers_hash).must_rematch :headers
    end
    it 'omit next on last page' do
      pagy, = app.pagy(:offset, @collection, page: 50)
      _(pagy.headers_hash).must_rematch :headers
    end
  end

  describe 'headers_hash with Calendar' do
    let(:app) { MockApp::Calendar.new(params: { a: 'one', b: 'two' }) }
    it 'returns the full headers hash' do
      pagy, = app.pagy(:offset, Event.all)
      _(pagy.headers_hash).must_rematch :headers
    end
    it 'returns custom headers hash' do
      pagy, = app.pagy(:offset, Event.all, headers_map: { limit: 'Per-Page', count: 'Total', pages: false })
      _(pagy.headers_hash).must_rematch :headers
    end
    it 'returns custom headers hash' do
      pagy, = app.pagy(:offset, Event.all, headers_map: { limit: false, count: false })
      _(pagy.headers_hash).must_rematch :headers
    end
    it 'returns the countless headers hash' do
      pagy, = app.pagy(:countless, Event.all)
      _(pagy.headers_hash).must_rematch :headers
    end
    it 'omit previous on first page' do
      pagy, = app.pagy(:offset, Event.all, page: 1)
      _(pagy.headers_hash).must_rematch :headers
    end
    it 'omit next on last page' do
      pagy, = app.pagy(:offset, Event.all, page: 26)
      _(pagy.headers_hash).must_rematch :headers
    end
  end

  describe 'headers_hash with Keyset' do
    let(:app) { MockApp.new(params: { a: 'one', b: 'two' }) }
    it 'returns the full headers hash' do
      pagy, = app.pagy(:keyset, Pet.order(:id))
      _(pagy.headers_hash).must_rematch :headers
    end
    it 'returns custom headers hash' do
      pagy, = app.pagy(:keyset,
                       Pet.order(:id),
                       page: 'WzIwXQ',
                       headers_map: { limit: 'Per-Page', page: 'Page', count: 'Total', pages: false })
      _(pagy.headers_hash).must_rematch :headers
    end
    it 'omit next on last page' do
      pagy, = app.pagy(:keyset, Pet.order(:id), limit: 50)
      _(pagy.headers_hash).must_rematch :headers
    end
  end
end
