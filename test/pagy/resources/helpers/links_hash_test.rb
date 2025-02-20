# frozen_string_literal: true

require_relative '../../../test_helper'
require_relative '../../../mock_helpers/app'
require_relative '../../../mock_helpers/collection'
require_relative '../../../files/models'

describe 'links_hash' do
  before do
    @collection = MockCollection.new
    @pagy_default = { requestable_limit: 100, jsonapi: true }
  end

  describe 'links_hash' do
    it 'returns the ordered links' do
      app = MockApp.new(params: { page: { number: 3, size: 10 } })
      pagy, _records = app.send(:pagy, :offset, @collection, **@pagy_default, page_sym: :number, limit_sym: :size)
      result = pagy.links_hash
      _(result.keys).must_equal %i[first previous next last]
      _(result).must_rematch :result
    end
    it 'sets the previous value to null when the link is unavailable' do
      app = MockApp.new(params: { page: { page: 1 } })
      pagy, _records = app.send(:pagy, :offset, @collection, **@pagy_default)
      result = pagy.links_hash
      _(result[:previous]).must_be_nil
    end
    it 'sets the next value to null when the link is unavailable' do
      app = MockApp.new(params: { page: { page: 50 } })
      pagy, _records = app.send(:pagy, :offset, @collection, **@pagy_default)
      result = pagy.links_hash
      _(result[:next]).must_be_nil
    end
  end
  describe 'links_hash (keyset)' do
    it 'returns the ordered links' do
      app = MockApp.new(params: { page: { latest: 'WzIwXQ', size: 10 } })
      pagy, _records = app.send(:pagy, :keyset,
                                Pet.order(:id),
                                **@pagy_default,
                                page_sym:  :latest,
                                limit_sym: :size)
      result = pagy.links_hash
      _(result.keys).must_equal %i[first next]
      _(result).must_rematch :keyset_result
    end

    it 'sets the next value to null when the link is unavailable' do
      app = MockApp.new(params: { page: { size: 50 } })
      pagy, _records = app.send(:pagy, :keyset,
                                Pet.order(:id),
                                **@pagy_default,
                                page_sym:  :latest,
                                limit_sym: :size)
      result = pagy.links_hash
      _(result).must_rematch :keyset_result
      _(result[:next]).must_be_nil
    end
  end
end
