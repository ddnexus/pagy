# frozen_string_literal: true

require_relative '../../test_helper'
require 'pagy/extras/limit'
require 'pagy/extras/jsonapi'
require 'pagy/extras/keyset'

require_relative '../../mock_helpers/collection'
require_relative '../../files/models'
require_relative '../../mock_helpers/app'

describe 'pagy/extras/jsonapi' do
  before do
    @collection = MockCollection.new
  end

  it 'defaults to true' do
    _(Pagy::DEFAULT[:jsonapi]).must_equal true
  end

  it 'raises PageParamError with page number' do
    app = MockApp.new(params: { page: 2 })
    _ { _pagy, _records = app.send(:pagy, @collection) }.must_raise Pagy::JsonApiExtra::ReservedParamError
  end

  describe 'JsonApi' do
    it 'uses the :jsonapi with page:nil' do
      app = MockApp.new(params: { page: nil })
      pagy, _records = app.send(:pagy, @collection, limit_extra: false)
      _(app.send(:pagy_url_for, pagy, 1)).must_rematch :url_1
      pagy, _records = app.send(:pagy, @collection)
      _(app.send(:pagy_url_for, pagy, 1)).must_rematch :url_2
    end
    it 'uses the :jsonapi with page:3' do
      app = MockApp.new(params: { page: { page: 3 } })
      pagy, _records = app.send(:pagy, @collection, limit_extra: false)
      _(app.send(:pagy_url_for, pagy, 2)).must_rematch :url_1
      pagy, _records = app.send(:pagy, @collection)
      _(app.send(:pagy_url_for, pagy, 2)).must_rematch :url_2
    end
  end
  describe 'Skip JsonApi' do
    it 'skips the :jsonapi with page:nil' do
      Pagy::DEFAULT[:jsonapi] = false
      app = MockApp.new(params: { page: nil })
      pagy, _records = app.send(:pagy, @collection, limit_extra: false)
      _(app.send(:pagy_url_for, pagy, 1)).must_equal '/foo?page=1'
      pagy, _records = app.send(:pagy, @collection)
      _(app.send(:pagy_url_for, pagy, 1)).must_equal '/foo?page=1&limit=20'
      Pagy::DEFAULT[:jsonapi] = true
    end
    it 'skips the :jsonapi with page:3' do
      Pagy::DEFAULT[:jsonapi] = false
      app = MockApp.new(params: { page: 3 })
      pagy, _records = app.send(:pagy, @collection, limit_extra: false)
      _(app.send(:pagy_url_for, pagy, 2)).must_equal '/foo?page=2'
      pagy, _records = app.send(:pagy, @collection)
      _(app.send(:pagy_url_for, pagy, 2)).must_equal '/foo?page=2&limit=20'
      Pagy::DEFAULT[:jsonapi] = true
    end
  end
  describe 'JsonApi with custom named params' do
    it 'gets custom named params' do
      app = MockApp.new(params: { page: { number: 3, size: 10 } })
      pagy, _records = app.send(:pagy, @collection, page_param: :number, limit_param: :size)
      _(pagy.page).must_equal 3
      _(pagy.limit).must_equal 10
    end
    it 'sets custom named params' do
      app = MockApp.new(params: { page: { number: 3, size: 10 } })
      pagy, _records = app.send(:pagy, @collection, page_param: :number, limit_param: :size)
      _(app.send(:pagy_url_for, pagy, 4)).must_rematch :url
    end
  end
  describe '#pagy_jsonapi_links' do
    it 'returns the ordered links' do
      app = MockApp.new(params: { page: { number: 3, size: 10 } })
      pagy, _records = app.send(:pagy, @collection, page_param: :number, limit_param: :size)
      result = app.send(:pagy_jsonapi_links, pagy)
      _(result.keys).must_equal %i[first last prev next]
      _(result).must_rematch :result
    end
    it 'sets the prev value to null when the link is unavailable' do
      app = MockApp.new(params: { page: { page: 1 } })
      pagy, _records = app.send(:pagy, @collection)
      result = app.send(:pagy_jsonapi_links, pagy)
      _(result[:prev]).must_be_nil
    end
    it 'sets the next value to null when the link is unavailable' do
      app = MockApp.new(params: { page: { page: 50 } })
      pagy, _records = app.send(:pagy, @collection)
      result = app.send(:pagy_jsonapi_links, pagy)
      _(result[:next]).must_be_nil
    end
  end
  describe '#pagy_jsonapi_links (keyset)' do
    it 'returns the ordered links' do
      app = MockApp.new(params: { page: { latest: 'eyJpZCI6MTB9', size: 10 } })
      pagy, _records = app.send(:pagy_keyset,
                                Pet.order(:id),
                                page_param: :latest,
                                limit_param: :size)
      result = app.send(:pagy_jsonapi_links, pagy)
      _(result.keys).must_equal %i[first last prev next]
      _(result).must_rematch :keyset_result
    end

    it 'sets the next value to null when the link is unavailable' do
      app = MockApp.new(params: { page: { size: 50 } })
      pagy, _records = app.send(:pagy_keyset,
                                Pet.order(:id),
                                page_param: :latest,
                                limit_param: :size)
      result = app.send(:pagy_jsonapi_links, pagy)
      _(result).must_rematch :keyset_result
      _(result[:next]).must_be_nil
    end
  end
end
