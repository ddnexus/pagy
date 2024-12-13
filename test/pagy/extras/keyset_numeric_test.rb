# frozen_string_literal: true

require_relative '../../test_helper'
require 'pagy/extras/keyset_numeric'
require 'pagy/extras/limit'

require_relative '../../files/models'
require_relative '../../mock_helpers/app'

describe 'pagy/extras/keyset' do
  [Pet, PetSequel].each do |model|
    describe '#pagy_keyset_numeric' do
      it 'returns Pagy::Keyset::Numeric object and records' do
        srand(123) # random cache keys "OiYT_", "Sx3RJ", "9g6R_", "JI4l2", "W4K-s"s
        # Page 1: cache_key = "OiYT_"
        app           = MockApp.new(params: {})
        pagy, records = app.send(:pagy_keyset_numeric,
                                 model.order(:id),
                                 tuple_comparison: true,
                                 limit:            10)
        _(pagy).must_be_kind_of Pagy::Keyset::Numeric
        _(records.size).must_equal 10
        _(pagy.next).must_equal 2

        # Page 2
        app           = MockApp.new(params:  { page: 2, limit: 10, cache_key: pagy.vars[:cache_key] },
                                    session: app.session)
        pagy, records = app.send(:pagy_keyset_numeric,
                                 model.order(:id),
                                 tuple_comparison: true)
        _(records.first.id).must_equal 11
        _(pagy.next).must_equal 3

        # Page 3
        app           = MockApp.new(params:  { page: 3, limit: 10, cache_key: pagy.vars[:cache_key] },
                                    session: app.session)
        pagy, records = app.send(:pagy_keyset_numeric,
                                 model.order(:id),
                                 tuple_comparison: true)
        _(records.first.id).must_equal 21
        _(pagy.next).must_equal 4

        # Manually create the new key in the session, which would be created next autmatically
        # To be sure that it will be skipped and a new one created
        app.session = app.session.merge("Sx3RJ" => [nil, nil])

        _(app.send(:pagy_cache_new_key)).must_equal "9g6R_"

        # Add the cache_key query string param
        app            = MockApp.new(params: { limit: 10 })
        pagy, _records = app.send(:pagy_keyset_numeric,
                                  model.order(:id))
        _(app.send(:pagy_url_for, pagy, pagy.next)).must_equal "/foo?limit=10&page=2&cache_key=JI4l2"

        # Add the cache_key_param query string param
        app            = MockApp.new(params: { limit: 10 })
        pagy, _records = app.send(:pagy_keyset_numeric,
                                  model.order(:id),
                                  cache_key_param: :ck)
        _(app.send(:pagy_url_for, pagy, pagy.next)).must_equal "/foo?limit=10&page=2&ck=W4K-s"
      end
    end
  end
end
