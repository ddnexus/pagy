# frozen_string_literal: true

require_relative '../../test_helper'
require 'pagy/extras/keyset_for_ui'
require 'pagy/extras/limit'

require_relative '../../files/models'
require_relative '../../mock_helpers/app'

describe 'pagy/extras/keyset_for_ui' do
  [Pet, PetSequel].each do |model|
    describe 'pagy_keyset_for_ui' do
      it 'works for page 1' do
        app           = MockApp.new(params: {})
        pagy, records = app.send(:pagy_keyset_for_ui,
                                 model.order(:id),
                                 tuple_comparison: true,
                                 limit:            10)
        _(pagy).must_be_kind_of Pagy::KeysetForUI
        _(records.size).must_equal 10
        _(pagy.next).must_equal 2
        _(pagy.update).must_equal [nil, [1, 1, [10]]]
      end
      it 'works for page 2' do
        app           = MockApp.new(params: {page: Pagy::B64.urlsafe_encode(['ppp', 'key', 2, 2, [10]].to_json)},
                                    cookie: 'pagy=ppp')
        pagy, records = app.send(:pagy_keyset_for_ui,
                                 model.order(:id),
                                 tuple_comparison: true,
                                 limit:            10)
        _(pagy).must_be_kind_of Pagy::KeysetForUI
        _(records.size).must_equal 10
        _(records.first.id).must_equal 11
        _(pagy.next).must_equal 3
        _(pagy.update).must_equal ['key', [2, 1, [20]]]
      end
      it 'reset pagination for missing cookie' do
        app           = MockApp.new(params: {page: Pagy::B64.urlsafe_encode(['zzz', 'key', 2, 2, [10]].to_json)},
                                    cookie: 'pagy=ppp')
        pagy, records = app.send(:pagy_keyset_for_ui,
                                 model.order(:id),
                                 tuple_comparison: true,
                                 limit:            10)
        _(pagy).must_be_kind_of Pagy::KeysetForUI
        _(records.size).must_equal 10
        _(pagy.next).must_equal 2
        _(pagy.update).must_equal [nil, [1, 1, [10]]]
      end
      it 'fallback to Countless if page param is a number' do
        app           = MockApp.new(cookie: 'pagy=ppp')
        pagy, records = app.send(:pagy_keyset_for_ui,
                                 model.order(:id),
                                 page: 2,
                                 tuple_comparison: true,
                                 limit:            10)
        _(pagy).must_be_kind_of Pagy::Countless
        _(records.size).must_equal 10
        _(records.first.id).must_equal 11
        _(pagy.next).must_equal 3
      end
      it 'works for page 5' do
        app           = MockApp.new(params: {page: Pagy::B64.urlsafe_encode(['ppp', 'key', 5, 5, [40]].to_json)},
                                    cookie: 'pagy=ppp')
        pagy, records = app.send(:pagy_keyset_for_ui,
                                 model.order(:id),
                                 tuple_comparison: true,
                                 limit:            10)
        _(pagy).must_be_kind_of Pagy::KeysetForUI
        _(records.size).must_equal 10
        _(records.first.id).must_equal 41
        _(pagy.next).must_be_nil
        _(pagy.update).must_equal ['key']
      end
    end
  end
end