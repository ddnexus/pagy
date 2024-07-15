# frozen_string_literal: true

require_relative '../../test_helper'
require 'pagy/extras/headers'
require 'pagy/extras/calendar'
require 'pagy/extras/countless'
require 'pagy/extras/keyset'

require_relative '../../mock_helpers/collection'
require_relative '../../mock_helpers/app'
require_relative '../../files/models'

describe 'pagy/extras/headers' do
  describe '#pagy_headers' do
    let(:app) { MockApp.new(params: { a: 'one', b: 'two' }) }
    before do
      @collection = MockCollection.new
    end
    it 'returns the full headers hash' do
      pagy, _records = app.send(:pagy, @collection)
      _(app.send(:pagy_headers, pagy)).must_rematch :headers
    end
    it 'returns custom headers hash' do
      pagy, _records = app.send(:pagy, @collection, headers: { items: 'Per-Page', count: 'Total', pages: false })
      _(app.send(:pagy_headers, pagy)).must_rematch :headers
    end
    it 'returns custom headers hash' do
      pagy, _records = app.send(:pagy, @collection, headers: { items: false, count: false })
      _(app.send(:pagy_headers, pagy)).must_rematch :headers
    end
    it 'returns the countless headers hash' do
      pagy, _records = app.send(:pagy_countless, @collection)
      _(app.send(:pagy_headers, pagy)).must_rematch :headers
    end
    it 'omit prev on first page' do
      pagy, _records = app.send(:pagy, @collection, page: 1)
      _(app.send(:pagy_headers, pagy)).must_rematch :headers
    end
    it 'omit next on last page' do
      pagy, _records = app.send(:pagy, @collection, page: 50)
      _(app.send(:pagy_headers, pagy)).must_rematch :headers
    end
  end

  describe '#pagy_headers with Calendar' do
    let(:app) { MockApp::Calendar.new(params: { a: 'one', b: 'two' }) }
    it 'returns the full headers hash' do
      pagy, _records = app.send(:pagy, Event.all)
      _(app.send(:pagy_headers, pagy)).must_rematch :headers
    end
    it 'returns custom headers hash' do
      pagy, _records = app.send(:pagy, Event.all, headers: { items: 'Per-Page', count: 'Total', pages: false })
      _(app.send(:pagy_headers, pagy)).must_rematch :headers
    end
    it 'returns custom headers hash' do
      pagy, _records = app.send(:pagy, Event.all, headers: { items: false, count: false })
      _(app.send(:pagy_headers, pagy)).must_rematch :headers
    end
    it 'returns the countless headers hash' do
      pagy, _records = app.send(:pagy_countless, Event.all)
      _(app.send(:pagy_headers, pagy)).must_rematch :headers
    end
    it 'omit prev on first page' do
      pagy, _records = app.send(:pagy, Event.all, page: 1)
      _(app.send(:pagy_headers, pagy)).must_rematch :headers
    end
    it 'omit next on last page' do
      pagy, _records = app.send(:pagy, Event.all, page: 26)
      _(app.send(:pagy_headers, pagy)).must_rematch :headers
    end
  end

  describe '#pagy_headers with Keyset' do
    let(:app) { MockApp.new(params: { a: 'one', b: 'two' }) }
    it 'returns the full headers hash' do
      pagy, _records = app.send(:pagy_keyset, Pet.order(:id))
      _(app.send(:pagy_headers, pagy)).must_rematch :headers
    end
    it 'returns custom headers hash' do
      pagy, _records = app.send(:pagy_keyset,
                                Pet.order(:id),
                                page: 'eyJpZCI6MjB9',
                                headers: { items: 'Per-Page', page: 'Page', count: 'Total', pages: false })
      _(app.send(:pagy_headers, pagy)).must_rematch :headers
    end
    it 'omit next on last page' do
      pagy, _records = app.send(:pagy_keyset, Pet.order(:id), items: 50)
      _(app.send(:pagy_headers, pagy)).must_rematch :headers
    end
  end

  describe '#pagy_headers_merge' do
    let(:app) { MockApp.new }
    before do
      @collection = MockCollection.new
    end
    it 'returns the full headers hash' do
      pagy, _records = app.send(:pagy, @collection)
      app.send(:pagy_headers_merge, pagy)
      _(app.send(:response).headers).must_rematch :response
    end
  end
  describe '#pagy_headers_merge with Calendar' do
    let(:app) { MockApp::Calendar.new }
    it 'returns the full headers hash' do
      pagy, _records = app.send(:pagy, Event.all)
      app.send(:pagy_headers_merge, pagy)
      _(app.send(:response).headers.to_hash).must_rematch :response
    end
  end
end
