# frozen_string_literal: true

require_relative '../../test_helper'
require 'pagy/extras/headers'
require 'pagy/extras/countless'

require_relative '../../mock_helpers/controller'

describe 'pagy/extras/headers' do
  describe '#pagy_headers' do
    before do
      @controller = MockController.new
      @collection = MockCollection.new
    end
    it 'returns the full headers hash' do
      pagy, _records = @controller.send(:pagy, @collection)
      _(@controller.send(:pagy_headers, pagy)).must_rematch
    end
    it 'returns custom headers hash' do
      pagy, _records = @controller.send(:pagy, @collection, headers: { items:'Per-Page', count: 'Total', pages:false })
      _(@controller.send(:pagy_headers, pagy)).must_rematch
    end
    it 'returns custom headers hash' do
      pagy, _records = @controller.send(:pagy, @collection, headers: { items: false, count: false })
      _(@controller.send(:pagy_headers, pagy)).must_rematch
    end
    it 'returns the countless headers hash' do
      pagy, _records = @controller.send(:pagy_countless, @collection)
      _(@controller.send(:pagy_headers, pagy)).must_rematch
    end
    it 'omit prev on first page' do
      pagy, _records = @controller.send(:pagy, @collection, page: 1)
      _(@controller.send(:pagy_headers, pagy)).must_rematch
    end
    it 'omit next on last page' do
      pagy, _records = @controller.send(:pagy, @collection, page: 50)
      _(@controller.send(:pagy_headers, pagy)).must_rematch
    end
  end

  describe '#pagy_headers_merge' do
    before do
      @controller = MockController.new
      @collection = MockCollection.new
    end
    it 'returns the full headers hash' do
      pagy, _records = @controller.send(:pagy, @collection)
      @controller.send(:pagy_headers_merge, pagy)
      _(@controller.send(:response).headers.to_hash).must_rematch
    end
  end
end
