# frozen_string_literal: true

require 'test_helper'
require 'files/models'
require 'mock_helpers/app'
require 'pagy/modules/b64'

describe 'Keynav' do
  [Pet, PetSequel].each do |model|
    describe ":keynav_js #{model}" do
      it 'works for page 1' do
        app           = MockApp.new(params: {})
        pagy, records = app.pagy(:keynav_js,
                                 model.order(:id),
                                 tuple_comparison: true,
                                 limit:            10)

        _(pagy).must_be_kind_of Pagy::Keyset::Keynav
        _(records.size).must_equal 10
        _(pagy.next).must_equal 2
        _(pagy.update).must_equal [nil, nil, 'page', 2, [1, 1, [10]]]
      end
      it 'works for page 2' do
        app           = MockApp.new(params: {page: Pagy::B64.urlsafe_encode(['ppp', 'key', 2, 2, [10]].to_json)},
                                    cookies: { pagy: 'ppp' })
        pagy, records = app.pagy(:keynav_js,
                                 model.order(:id),
                                 tuple_comparison: true,
                                 limit:            10)

        _(pagy).must_be_kind_of Pagy::Keyset::Keynav
        _(records.size).must_equal 10
        _(records.first.id).must_equal 11
        _(pagy.next).must_equal 3
        _(pagy.update).must_equal ["key", nil, 'page', 3, [2, 1, [20]]]
      end
      it 'reset pagination for missing cookie' do
        app           = MockApp.new(params: {page: Pagy::B64.urlsafe_encode(['zzz', 'key', 2, 2, [10]].to_json)},
                                    cookies: {pagy: 'ppp'})
        pagy, records = app.pagy(:keynav_js,
                                 model.order(:id),
                                 tuple_comparison: true,
                                 limit: 10, root_key: 'root')

        _(pagy).must_be_kind_of Pagy::Keyset::Keynav
        _(records.size).must_equal 10
        _(pagy.next).must_equal 2
        _(pagy.update).must_equal [nil, 'root', 'page', 2, [1, 1, [10]]]
      end
      it 'fallback to Countless if page param is a string with space' do
        app           = MockApp.new(cookies: { pagy: 'ppp' }, params: { page: '2 3' })
        pagy, records = app.pagy(:keynav_js,
                                 model.order(:id),
                                 tuple_comparison: true,
                                 limit:            10)

        _(pagy).must_be_kind_of Pagy::Offset::Countless
        _(records.size).must_equal 10
        _(records.first.id).must_equal 11
        _(pagy.next).must_equal 3
      end
      it 'works for page 5' do
        app           = MockApp.new(params: {page: Pagy::B64.urlsafe_encode(['ppp', 'key', 5, 5, [40]].to_json)},
                                    cookies: { pagy: 'ppp' })
        pagy, records = app.pagy(:keynav_js,
                                 model.order(:id),
                                 tuple_comparison: true,
                                 limit: 10, root_key: 'root')

        _(pagy).must_be_kind_of Pagy::Keyset::Keynav
        _(records.size).must_equal 10
        _(records.first.id).must_equal 41
        _(pagy.next).must_be_nil
        _(pagy.update).must_equal %w[key root page]
      end
    end
  end
end
