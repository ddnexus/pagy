# frozen_string_literal: true

require_relative '../../../test_helper'
require_relative '../../../mock_helpers/collection'
require_relative '../../../files/models'
require_relative '../../../mock_helpers/app'

describe 'paginators jsonapi' do
  before do
    @collection   = MockCollection.new
    @pagy_default = { client_max_limit: 100, jsonapi: true }
  end

  it 'raises PageParamError with page number' do
    app = MockApp.new(params: { page: 2 })

    _ { _pagy, _records = app.send(:pagy, :offset, @collection, **@pagy_default) }.must_raise Pagy::JsonapiReservedParamError
  end

  describe 'JsonApi' do
    it 'uses the :jsonapi with page:nil' do
      app = MockApp.new(params: { page: nil })
      pagy, _records = app.send(:pagy, :offset, @collection, jsonapi: true)
      _(pagy.send(:compose_page_url, 1)).must_rematch :url_1
      pagy, _records = app.send(:pagy, :offset, @collection, **@pagy_default)
      _(pagy.send(:compose_page_url, 1)).must_rematch :url_2
    end
    it 'uses the :jsonapi with page:3' do
      app = MockApp.new(params: { page: { page: 3 } })
      pagy, _records = app.send(:pagy, :offset, @collection, jsonapi: true)
      _(pagy.send(:compose_page_url, 2)).must_rematch :url_1
      pagy, _records = app.send(:pagy, :offset, @collection, **@pagy_default)
      _(pagy.send(:compose_page_url, 2)).must_rematch :url_2
    end
  end
  describe 'Skip JsonApi' do
    it 'skips the :jsonapi with page:nil' do
      app = MockApp.new(params: { page: nil })
      pagy, _records = app.send(:pagy, :offset, @collection)

      _(pagy.send(:compose_page_url, 1)).must_equal '/foo?page=1'
      pagy, _records = app.send(:pagy, :offset, @collection, client_max_limit: 100)

      _(pagy.send(:compose_page_url, 1)).must_equal '/foo?page=1&limit=20'
    end
    it 'skips the :jsonapi with page:3' do
      app = MockApp.new(params: { page: 3 })
      pagy, _records = app.send(:pagy, :offset, @collection)

      _(pagy.send(:compose_page_url, 2)).must_equal '/foo?page=2'
      pagy, _records = app.send(:pagy, :offset, @collection, **@pagy_default, jsonapi: false)

      _(pagy.send(:compose_page_url, 2)).must_equal '/foo?page=2&limit=20'
    end
  end
  describe 'JsonApi with custom named params' do
    it 'gets custom named params' do
      app = MockApp.new(params: { page: { number: 3, size: 10 } })
      pagy, _records = app.send(:pagy, :offset, @collection, **@pagy_default, page_key: 'number', limit_key: 'size')

      _(pagy.page).must_equal 3
      _(pagy.limit).must_equal 10
    end
    it 'sets custom named params' do
      app = MockApp.new(params: { page: { number: 3, size: 10 } })
      pagy, _records = app.send(:pagy, :offset, @collection, **@pagy_default, page_key: 'number', limit_key: 'size')
      _(pagy.send(:compose_page_url, 4)).must_rematch :url
    end
  end
end
