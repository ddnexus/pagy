# frozen_string_literal: true

require 'unit/test_helper'
require 'pagy/toolbox/paginators/elasticsearch_rails'
require 'mocks/app'
require 'mocks/elasticsearch_rails'

describe 'Pagy::ElasticsearchRailsPaginator' do
  let(:app) { MockApp.new }

  describe '#paginate' do
    describe 'Active Mode (pagy_search)' do
      it 'paginates with defaults (Standard Model)' do
        args = MockElasticsearchRails::Model.pagy_search('a')

        # page 1, limit 10
        pagy, response = app.pagy(:elasticsearch_rails, args, page: 1, limit: 10)

        _(pagy).must_be_kind_of Pagy::ElasticsearchRails
        _(pagy.count).must_equal 1000
        _(pagy.page).must_equal 1
        _(pagy.limit).must_equal 10
        _(response).must_be_kind_of MockElasticsearchRails::Response
        _(response.records.first).must_equal 'R-a-1'
      end

      it 'paginates with ES7 Model (Total as Hash)' do
        args = MockElasticsearchRails::ModelES7.pagy_search('b')

        pagy, response = app.pagy(:elasticsearch_rails, args, page: 2, limit: 20)

        _(pagy.count).must_equal 1000
        _(pagy.page).must_equal 2
        _(response).must_be_kind_of MockElasticsearchRails::ResponseES7
      end

      it 'paginates with ES5 Model (response method)' do
        args = MockElasticsearchRails::ModelES5.pagy_search('a')

        pagy, response = app.pagy(:elasticsearch_rails, args, page: 1, limit: 10)

        _(pagy.count).must_equal 1000
        _(response).must_be_kind_of MockElasticsearchRails::ResponseES5
      end

      it 'handles Hash queries (Active Mode)' do
        # Passing a Hash as query
        query = { query: { match: 'a' } }
        args = MockElasticsearchRails::Model.pagy_search(query)

        pagy, response = app.pagy(:elasticsearch_rails, args, page: 1, limit: 10)

        _(pagy.count).must_equal 1000
        _(response.search.definition).must_equal query
      end
    end

    describe 'Passive Mode (Existing Response)' do
      it 'paginates from existing response (Standard)' do
        # Simulate existing search response: page 3 (offset 20), size 10
        response = MockElasticsearchRails::Model.search('a', from: 20, size: 10)

        pagy = app.pagy(:elasticsearch_rails, response)

        _(pagy).must_be_kind_of Pagy::ElasticsearchRails
        _(pagy.page).must_equal 3 # (20 / 10) + 1
        _(pagy.limit).must_equal 10
        _(pagy.count).must_equal 1000
      end

      it 'paginates from existing response (ES7)' do
        response = MockElasticsearchRails::ModelES7.search('b', from: 40, size: 20)

        pagy = app.pagy(:elasticsearch_rails, response)

        _(pagy.page).must_equal 3 # (40 / 20) + 1
        _(pagy.limit).must_equal 20
        _(pagy.count).must_equal 1000
      end

      it 'paginates from existing response (ES5)' do
        response = MockElasticsearchRails::ModelES5.search('a', from: 0, size: 15)

        pagy = app.pagy(:elasticsearch_rails, response)

        _(pagy.page).must_equal 1
        _(pagy.limit).must_equal 15
        _(pagy.count).must_equal 1000
      end

      it 'extracts params from DSL object (to_hash)' do
        # Query object responding to to_hash
        dsl_query = MockElasticsearchRails::DslSearch.new(from: 10, size: 10)
        response = MockElasticsearchRails::Model.search(dsl_query)

        pagy = app.pagy(:elasticsearch_rails, response)

        _(pagy.page).must_equal 2
        _(pagy.limit).must_equal 10
      end

      it 'extracts params from Hash definition' do
        # Query as Hash
        response = MockElasticsearchRails::Model.search({ from: 10, size: 5 })

        pagy = app.pagy(:elasticsearch_rails, response)

        _(pagy.page).must_equal 3
        _(pagy.limit).must_equal 5
      end

      it 'extracts params from options (when definition has no params)' do
        # Query as String, params in options
        response = MockElasticsearchRails::Model.search('a', from: 30, size: 10)

        pagy = app.pagy(:elasticsearch_rails, response)

        _(pagy.page).must_equal 4
        _(pagy.limit).must_equal 10
      end

      it 'defaults limit to 10 if zero/missing' do
        response = MockElasticsearchRails::Model.search('a', size: 0)
        pagy = app.pagy(:elasticsearch_rails, response)
        _(pagy.limit).must_equal 10
      end
    end
  end
end
