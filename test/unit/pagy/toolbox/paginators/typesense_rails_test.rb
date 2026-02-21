# frozen_string_literal: true

require 'unit/test_helper'
require 'pagy/toolbox/paginators/typesense_rails'
require 'mocks/app'
require 'mocks/typesense_rails'

describe 'Pagy::TypesenseRailsPaginator' do
  let(:app) { MockApp.new }

  describe '#paginate' do
    describe 'Active Mode (pagy_search)' do
      it 'paginates with defaults' do
        args = MockTypesenseRails::Model.pagy_search('a', 'name')

        pagy, results = app.pagy(:typesense_rails, args, page: 1, limit: 10)

        _(pagy).must_be_kind_of Pagy::TypesenseRails
        _(pagy.count).must_equal 1000
        _(pagy.page).must_equal 1
        _(pagy.limit).must_equal 10
        _(results).must_be_kind_of MockTypesenseRails::Results
        _(results.raw_answer['hits'].first).must_equal 'a-1'
        _(results.raw_answer['hits'].size).must_equal 10
      end

      it 'paginates with custom options' do
        args = MockTypesenseRails::Model.pagy_search('b', 'name')

        pagy, results = app.pagy(:typesense_rails, args, page: 2, limit: 20)

        _(pagy.page).must_equal 2
        _(pagy.limit).must_equal 20
        _(results.raw_answer['page']).must_equal 2
        _(results.raw_answer['hits'].first).must_equal 'b-21'
        _(results.raw_answer['hits'].last).must_equal 'b-40'
      end
    end

    describe 'Passive Mode (Results object)' do
      it 'paginates from existing results' do
        results = MockTypesenseRails::Results.new('a', page: 3, per_page: 15)

        pagy = app.pagy(:typesense_rails, results)

        _(pagy).must_be_kind_of Pagy::TypesenseRails
        _(pagy.page).must_equal 3
        _(pagy.limit).must_equal 15
        _(pagy.count).must_equal 1000
      end
    end
  end
end
