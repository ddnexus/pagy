# frozen_string_literal: true

require_relative '../../../test_helper'
require_relative '../../../files/models'
require_relative '../../../mock_helpers/app'

describe 'keyset' do
  [Pet, PetSequel].each do |model|
    describe ":keyset #{model}" do
      it 'returns Pagy::Keyset object and records' do
        app = MockApp.new(params: { page: nil })
        pagy, records = app.send(:pagy, :keyset,
                                 model.order(:animal, :name, :id),
                                 tuple_comparison: true,
                                 limit: 10)
        _(pagy).must_be_kind_of Pagy::Keyset
        _(records.size).must_equal 10
        _(pagy.next).must_equal "WyJjYXQiLCJFbGxhIiwxOF0"
      end
      it 'pulls the page from params' do
        app = MockApp.new(params: { page: "WzEwXQ", limit: 10 })
        pagy, records = app.send(:pagy, :keyset,
                                 model.order(:id),
                                 tuple_comparison: true,
                                 requestable_limit: 100)
        _(records.first.id).must_equal 11
        _(pagy.next).must_equal "WzIwXQ"
      end
    end
    describe "URL helpers #{model}" do
      it 'returns the URLs for first page' do
        app = MockApp.new(params: { page: nil, limit: 10 })
        pagy, _records = app.send(:pagy, :keyset,
                                  model.order(:id),
                                  requestable_limit: 100)
        _(pagy.page_url(:first)).must_equal "/foo?limit=10"
        _(pagy.page_url(:next)).must_equal "/foo?limit=10&page=WzEwXQ"
      end
      it 'returns the URLs for second page' do
        app = MockApp.new(params: { page: "WzEwXQ", limit: 10 })
        pagy, _records = app.send(:pagy, :keyset,
                                  model.order(:id),
                                  requestable_limit: 100)
        _(pagy.page_url(:first)).must_equal "/foo?limit=10"
        _(pagy.page_url(:next)).must_equal "/foo?limit=10&page=WzIwXQ"
      end
      it 'returns the URLs for last page' do
        app = MockApp.new(params: { page: "WzQwXQ", limit: 10 })
        pagy, _records = app.send(:pagy, :keyset,
                                  model.order(:id),
                                  requestable_limit: 100)
        _(pagy.page_url(:first)).must_equal "/foo?limit=10"
        _(pagy.page_url(:next)).must_be_nil
      end
    end
  end
end
