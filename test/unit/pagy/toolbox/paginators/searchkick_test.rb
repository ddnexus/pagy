# frozen_string_literal: true

require 'unit/test_helper'
require 'pagy/toolbox/paginators/searchkick'
require 'mocks/app'
require 'mocks/searchkick'

describe 'Pagy::SearchkickPaginator' do
  let(:app) { MockApp.new }

  describe '#paginate' do
    describe 'Active Mode (pagy_search)' do
      it 'paginates with defaults' do
        # Model.pagy_search creates the Arguments object
        args = MockSearchkick::Model.pagy_search('a')
        pagy, results = app.pagy(:searchkick, args, page: 1, limit: 10)

        _(pagy).must_be_kind_of Pagy::Searchkick
        _(pagy.count).must_equal 1000
        _(pagy.page).must_equal 1
        _(results).must_be_kind_of MockSearchkick::Results
        _(results.results.first).must_equal "R-a-1"
      end

      it 'paginates with options and block' do
        args = MockSearchkick::Model.pagy_search('b', some: :option) { 'block-' }

        pagy, results = app.pagy(:searchkick, args, page: 2, limit: 10)

        _(pagy.page).must_equal 2
        # The mock model yields the block content prepended to results
        _(results.results.first).must_equal "R-block-b-11"
      end
    end

    describe 'Passive Mode (Results object)' do
      it 'paginates from existing results (Legacy/Standard)' do
        # Simulate getting results from a previous search call
        results = MockSearchkick::Model.search('a', page: 3, per_page: 10)
        # Passive mode doesn't strictly need Pagy::Request for limits (extracts from results),
        # but using app.pagy maintains consistency.
        pagy = app.pagy(:searchkick, results)

        # The Active mode returns [pagy, results].
        # The Passive mode (else branch) returns `Searchkick.new`, just the pagy object.
        _(pagy).must_be_kind_of Pagy::Searchkick
        _(pagy.page).must_equal 3
        _(pagy.limit).must_equal 10
        _(pagy.count).must_equal 1000
      end

      it 'paginates from existing results (V6 style)' do
        # ResultsV6 does not have .options, uses accessor methods
        results = MockSearchkick::ModelV6.search('a', page: 4, per_page: 20)
        pagy    = app.pagy(:searchkick, results)

        _(pagy).must_be_kind_of Pagy::Searchkick
        _(pagy.page).must_equal 4
        _(pagy.limit).must_equal 20
        _(pagy.count).must_equal 1000
      end
    end
  end
end
