# frozen_string_literal: true

require 'unit/test_helper'
require 'pagy/toolbox/paginators/rails_active_search'
require 'mocks/app'
require 'mocks/rails_active_search'

describe 'Pagy::RailsActiveSearchPaginator' do
  let(:app) { MockApp.new }

  describe '#paginate' do
    describe 'Active Mode (pagy_search)' do
      it 'paginates with defaults' do
        args = MockRailsActiveSearch::Model.pagy_search('a')

        pagy, results = app.pagy(:rails_active_search, args, page: 1, limit: 10)

        _(pagy).must_be_kind_of Pagy::RailsActiveSearch
        _(pagy.count).must_equal 1000
        _(pagy.page).must_equal 1
        _(pagy.limit).must_equal 10
        _(results).must_be_kind_of MockRailsActiveSearch::Results
        _(results.to_a).must_equal ('a-1'..'a-10').to_a
      end

      it 'paginates with keyword options and block' do
        args = MockRailsActiveSearch::Model.pagy_search('b', prefix: 'kw-') { 'block-' }

        pagy, results = app.pagy(:rails_active_search, args, page: 3, limit: 20)

        _(pagy.page).must_equal 3
        _(pagy.limit).must_equal 20
        _(results.first).must_equal 'kw-block-b-41'
        _(results.count).must_equal 20
      end

      it 'uses the :search_method option' do
        model = Class.new(MockRailsActiveSearch::Model) do
          def self.custom_search(...) = search(...)
        end
        args  = model.pagy_search('b')

        pagy, results = app.pagy(:rails_active_search, args, page: 2, limit: 10, search_method: :custom_search)

        _(pagy.count).must_equal 1000
        _(results.first).must_equal 'b-11'
      end
    end

    describe 'Passive Mode (ActiveSearch::Results)' do
      it 'paginates from existing results' do
        results = MockRailsActiveSearch::Model.search('a').limit(25).offset(75).results
        pagy    = app.pagy(:rails_active_search, results)

        _(pagy).must_be_kind_of Pagy::RailsActiveSearch
        _(pagy.page).must_equal 4
        _(pagy.limit).must_equal 25
        _(pagy.count).must_equal 1000
        _(pagy.from).must_equal 76
        _(results.first).must_equal 'a-76'
      end

      it 'paginates from results without offset' do
        results = MockRailsActiveSearch::Model.search('b').results
        pagy    = app.pagy(:rails_active_search, results)

        _(pagy.page).must_equal 1
        _(pagy.limit).must_equal 10
        _(pagy.count).must_equal 1000
      end
    end
  end
end
