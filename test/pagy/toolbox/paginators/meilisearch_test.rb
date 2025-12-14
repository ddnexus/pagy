# frozen_string_literal: true

require 'test_helper'
require 'pagy/toolbox/paginators/meilisearch'
require 'mocks/app'
require 'mocks/meilisearch'

describe 'Pagy::MeilisearchPaginator' do
  let(:app) { MockApp.new }

  describe '#paginate' do
    describe 'Active Mode (pagy_search)' do
      it 'paginates with defaults' do
        # Model.pagy_search creates the Arguments object
        args = MockMeilisearch::Model.pagy_search('a')

        # pagy(:meilisearch, ...)
        pagy, results = app.pagy(:meilisearch, args, page: 1, limit: 10)

        _(pagy).must_be_kind_of Pagy::Meilisearch
        _(pagy.count).must_equal 1000
        _(pagy.page).must_equal 1
        _(pagy.limit).must_equal 10
        _(results).must_be_kind_of MockMeilisearch::Results

        # Verify data slicing
        _(results.raw_answer['hits'].first).must_equal 'a-1'
        _(results.raw_answer['hits'].size).must_equal 10
      end

      it 'paginates with custom options' do
        args = MockMeilisearch::Model.pagy_search('b', filter: 'id > 10')

        pagy, results = app.pagy(:meilisearch, args, page: 2, limit: 20)

        _(pagy.page).must_equal 2
        _(pagy.limit).must_equal 20
        _(results.raw_answer['page']).must_equal 2

        # Verify data slicing for page 2 (b-21 to b-40)
        _(results.raw_answer['hits'].first).must_equal 'b-21'
        _(results.raw_answer['hits'].last).must_equal 'b-40'
      end
    end

    describe 'Passive Mode (Results object)' do
      it 'paginates from existing results' do
        # Simulate results from a previous search
        results = MockMeilisearch::Results.new('a', page: 3, hits_per_page: 15)

        pagy = app.pagy(:meilisearch, results)

        _(pagy).must_be_kind_of Pagy::Meilisearch
        _(pagy.page).must_equal 3
        _(pagy.limit).must_equal 15
        _(pagy.count).must_equal 1000
      end
    end
  end
end
