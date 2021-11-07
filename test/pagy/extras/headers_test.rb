# frozen_string_literal: true

require_relative '../../test_helper'
require 'pagy/extras/headers'
require 'pagy/extras/calendar'
require 'pagy/extras/countless'

require_relative '../../mock_helpers/collection'
require_relative '../../mock_helpers/app'

describe 'pagy/extras/headers' do
  describe '#pagy_headers' do
    let(:app) { MockApp.new }
    before do
      @collection = MockCollection.new
    end
    it 'returns the full headers hash' do
      pagy, _records = app.send(:pagy, @collection)
      _(app.send(:pagy_headers, pagy)).must_rematch
    end
    it 'returns custom headers hash' do
      pagy, _records = app.send(:pagy, @collection, headers: { items: 'Per-Page', count: 'Total', pages: false })
      _(app.send(:pagy_headers, pagy)).must_rematch
    end
    it 'returns custom headers hash' do
      pagy, _records = app.send(:pagy, @collection, headers: { items: false, count: false })
      _(app.send(:pagy_headers, pagy)).must_rematch
    end
    it 'returns the countless headers hash' do
      pagy, _records = app.send(:pagy_countless, @collection)
      _(app.send(:pagy_headers, pagy)).must_rematch
    end
    it 'omit prev on first page' do
      pagy, _records = app.send(:pagy, @collection, page: 1)
      _(app.send(:pagy_headers, pagy)).must_rematch
    end
    it 'omit next on last page' do
      pagy, _records = app.send(:pagy, @collection, page: 50)
      _(app.send(:pagy_headers, pagy)).must_rematch
    end
  end

  describe '#pagy_headers with Calendar' do
    let(:app) { MockApp::Calendar.new }
    before do
      @collection = MockCollection::Calendar.new
    end
    it 'returns the full headers hash' do
      pagy, _records = app.send(:pagy, @collection)
      _(app.send(:pagy_headers, pagy)).must_rematch
    end
    it 'returns custom headers hash' do
      pagy, _records = app.send(:pagy, @collection, headers: { items: 'Per-Page', count: 'Total', pages: false })
      _(app.send(:pagy_headers, pagy)).must_rematch
    end
    it 'returns custom headers hash' do
      pagy, _records = app.send(:pagy, @collection, headers: { items: false, count: false })
      _(app.send(:pagy_headers, pagy)).must_rematch
    end
    it 'returns the countless headers hash' do
      pagy, _records = app.send(:pagy_countless, @collection)
      _(app.send(:pagy_headers, pagy)).must_rematch
    end
    it 'omit prev on first page' do
      pagy, _records = app.send(:pagy, @collection, page: 1)
      _(app.send(:pagy_headers, pagy)).must_rematch
    end
    it 'omit next on last page' do
      pagy, _records = app.send(:pagy, @collection, page: 26)
      _(app.send(:pagy_headers, pagy)).must_rematch
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
      _(app.send(:response).headers.to_hash).must_rematch
    end
  end
  describe '#pagy_headers_merge with Calendar' do
    let(:app) { MockApp::Calendar.new }
    before do
      @collection = MockCollection::Calendar.new
    end
    it 'returns the full headers hash' do
      pagy, _records = app.send(:pagy, @collection)
      app.send(:pagy_headers_merge, pagy)
      _(app.send(:response).headers.to_hash).must_rematch
    end
  end
end
