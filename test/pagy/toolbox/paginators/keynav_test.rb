# frozen_string_literal: true

require_relative '../../../test_helper'
require_relative '../../../files/models'
require_relative '../../../mock_helpers/app'
require_relative '../../../../gem/lib/pagy/modules/b64'

describe 'Keynav' do
  [Pet, PetSequel].each do |model|
    describe ":keynav_js #{model}" do
      it 'works for page 1' do
        app           = MockApp.new(params: {})
        pagy, records = app.send(:pagy, :keynav_js,
                                 model.order(:id),
                                 tuple_comparison: true,
                                 limit:            10)

        _(pagy).must_be_kind_of Pagy::Keyset::Keynav
        _(records.size).must_equal 10
        _(pagy.next).must_equal 2
        _(pagy.update).must_equal [nil, 'page', 2, [1, 1, [10]]]
      end
      it 'works for page 2' do
        app           = MockApp.new(params: {page: Pagy::B64.urlsafe_encode(['ppp', 'key', 2, 2, [10]].to_json)},
                                    cookie: 'pagy=ppp')
        pagy, records = app.send(:pagy, :keynav_js,
                                 model.order(:id),
                                 tuple_comparison: true,
                                 limit:            10)

        _(pagy).must_be_kind_of Pagy::Keyset::Keynav
        _(records.size).must_equal 10
        _(records.first.id).must_equal 11
        _(pagy.next).must_equal 3
        _(pagy.update).must_equal ["key", 'page', 3, [2, 1, [20]]]
      end
      it 'reset pagination for missing cookie' do
        app           = MockApp.new(params: {page: Pagy::B64.urlsafe_encode(['zzz', 'key', 2, 2, [10]].to_json)},
                                    cookie: 'pagy=ppp')
        pagy, records = app.send(:pagy, :keynav_js,
                                 model.order(:id),
                                 tuple_comparison: true,
                                 limit:            10)

        _(pagy).must_be_kind_of Pagy::Keyset::Keynav
        _(records.size).must_equal 10
        _(pagy.next).must_equal 2
        _(pagy.update).must_equal [nil, 'page', 2, [1, 1, [10]]]
      end
      it 'fallback to Countless if page param is a string with space' do
        app           = MockApp.new(cookie: 'pagy=ppp', params: { page: '2 3' })
        pagy, records = app.send(:pagy, :keynav_js,
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
                                    cookie: 'pagy=ppp')
        pagy, records = app.send(:pagy, :keynav_js,
                                 model.order(:id),
                                 tuple_comparison: true,
                                 limit:            10)

        _(pagy).must_be_kind_of Pagy::Keyset::Keynav
        _(records.size).must_equal 10
        _(records.first.id).must_equal 41
        _(pagy.next).must_be_nil
        _(pagy.update).must_equal %w[key page]
      end
    end
  end
end
