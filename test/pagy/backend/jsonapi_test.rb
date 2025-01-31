# frozen_string_literal: true

require_relative '../../test_helper'
require_relative '../../mock_helpers/collection'
require_relative '../../files/models'
require_relative '../../mock_helpers/app'

describe 'jsonapi' do
  before do
    @collection = MockCollection.new
    @pagy_default = { requestable_limit: 100, jsonapi: true }
  end

  it 'raises PageParamError with page number' do
    app = MockApp.new(params: { page: 2 })
    _ { _pagy, _records = app.send(:pagy_offset, @collection, **@pagy_default) }.must_raise Pagy::JsonapiReservedParamError
  end

  describe 'JsonApi' do
    it 'uses the :jsonapi with page:nil' do
      app = MockApp.new(params: { page: nil })
      pagy, _records = app.send(:pagy_offset, @collection, jsonapi: true)
      _(app.send(:pagy_page_url, pagy, 1)).must_rematch :url_1
      pagy, _records = app.send(:pagy_offset, @collection, **@pagy_default)
      _(app.send(:pagy_page_url, pagy, 1)).must_rematch :url_2
    end
    it 'uses the :jsonapi with page:3' do
      app = MockApp.new(params: { page: { page: 3 } })
      pagy, _records = app.send(:pagy_offset, @collection, jsonapi: true)
      _(app.send(:pagy_page_url, pagy, 2)).must_rematch :url_1
      pagy, _records = app.send(:pagy_offset, @collection, **@pagy_default)
      _(app.send(:pagy_page_url, pagy, 2)).must_rematch :url_2
    end
  end
  describe 'Skip JsonApi' do
    it 'skips the :jsonapi with page:nil' do
      app = MockApp.new(params: { page: nil })
      pagy, _records = app.send(:pagy_offset, @collection)
      _(app.send(:pagy_page_url, pagy, 1)).must_equal '/foo?page=1'
      pagy, _records = app.send(:pagy_offset, @collection, requestable_limit: 100)
      _(app.send(:pagy_page_url, pagy, 1)).must_equal '/foo?page=1&limit=20'
    end
    it 'skips the :jsonapi with page:3' do
      app = MockApp.new(params: { page: 3 })
      pagy, _records = app.send(:pagy_offset, @collection)
      _(app.send(:pagy_page_url, pagy, 2)).must_equal '/foo?page=2'
      pagy, _records = app.send(:pagy_offset, @collection, **@pagy_default, jsonapi: false)
      _(app.send(:pagy_page_url, pagy, 2)).must_equal '/foo?page=2&limit=20'
    end
  end
  describe 'JsonApi with custom named params' do
    it 'gets custom named params' do
      app = MockApp.new(params: { page: { number: 3, size: 10 } })
      pagy, _records = app.send(:pagy_offset, @collection, **@pagy_default, page_sym: :number, limit_sym: :size)
      _(pagy.page).must_equal 3
      _(pagy.limit).must_equal 10
    end
    it 'sets custom named params' do
      app = MockApp.new(params: { page: { number: 3, size: 10 } })
      pagy, _records = app.send(:pagy_offset, @collection, **@pagy_default, page_sym: :number, limit_sym: :size)
      _(app.send(:pagy_page_url, pagy, 4)).must_rematch :url
    end
  end
  describe '#pagy_links' do
    it 'returns the ordered links' do
      app = MockApp.new(params: { page: { number: 3, size: 10 } })
      pagy, _records = app.send(:pagy_offset, @collection, **@pagy_default, page_sym: :number, limit_sym: :size)
      result = app.send(:pagy_links, pagy)
      _(result.keys).must_equal %i[first previous next last]
      _(result).must_rematch :result
    end
    it 'sets the previous value to null when the link is unavailable' do
      app = MockApp.new(params: { page: { page: 1 } })
      pagy, _records = app.send(:pagy_offset, @collection, **@pagy_default)
      result = app.send(:pagy_links, pagy)
      _(result[:previous]).must_be_nil
    end
    it 'sets the next value to null when the link is unavailable' do
      app = MockApp.new(params: { page: { page: 50 } })
      pagy, _records = app.send(:pagy_offset, @collection, **@pagy_default)
      result = app.send(:pagy_links, pagy)
      _(result[:next]).must_be_nil
    end
  end
  describe '#pagy_links (keyset)' do
    it 'returns the ordered links' do
      app = MockApp.new(params: { page: { latest: 'WzIwXQ', size: 10 } })
      pagy, _records = app.send(:pagy_keyset,
                                Pet.order(:id),
                                **@pagy_default,
                                page_sym:  :latest,
                                limit_sym: :size)
      result = app.send(:pagy_links, pagy)
      _(result.keys).must_equal %i[first next]
      _(result).must_rematch :keyset_result
    end

    it 'sets the next value to null when the link is unavailable' do
      app = MockApp.new(params: { page: { size: 50 } })
      pagy, _records = app.send(:pagy_keyset,
                                Pet.order(:id),
                                **@pagy_default,
                                page_sym:  :latest,
                                limit_sym: :size)
      result = app.send(:pagy_links, pagy)
      _(result).must_rematch :keyset_result
      _(result[:next]).must_be_nil
    end
  end
end
