# frozen_string_literal: true

require_relative '../../../test_helper'
require_relative '../../../mock_helpers/searchkick'
require_relative '../../../mock_helpers/collection'
require_relative '../../../mock_helpers/app'

describe 'searchkick' do
  describe 'model#pagy_search' do
    it 'extends the class with #pagy_search' do
      _(MockSearchkick::Model).must_respond_to :pagy_search
    end
    it 'returns class and arguments' do
      _(MockSearchkick::Model.pagy_search('a', b: 2)).must_equal [MockSearchkick::Model, 'a', { b: 2 }, nil]
      args  = MockSearchkick::Model.pagy_search('a', b: 2) { |a| a * 2 }
      block = args[-1]
      _(args).must_equal [MockSearchkick::Model, 'a', { b: 2 }, block]
    end
    it 'allows the term argument to be optional' do
      _(MockSearchkick::Model.pagy_search(b: 2)).must_equal [MockSearchkick::Model, nil, { b: 2 }, nil]
      args  = MockSearchkick::Model.pagy_search(b: 2) { |a| a * 2 }
      block = args[-1]
      _(args).must_equal [MockSearchkick::Model, nil, { b: 2 }, block]
    end
    it 'adds an empty option hash' do
      _(MockSearchkick::Model.pagy_search('a')).must_equal [MockSearchkick::Model, 'a', {}, nil]
      args  = MockSearchkick::Model.pagy_search('a') { |a| a * 2 }
      block = args[-1]
      _(args).must_equal [MockSearchkick::Model, 'a', {}, block]
    end
    it 'adds the caller and arguments' do
      _(MockSearchkick::Model.pagy_search('a', b: 2).results).must_equal [MockSearchkick::Model, 'a', { b: 2 }, nil, :results]
      _(MockSearchkick::Model.pagy_search('a', b: 2).a('b', 2)).must_equal [MockSearchkick::Model, 'a', { b: 2 }, nil, :a, 'b', 2]
    end
  end

  describe 'controller_methods' do
    let(:app) { MockApp.new }

    describe '#pagy_searchkick' do
      before do
        @collection = MockCollection.new
      end
      it 'paginates response with defaults' do
        pagy, response = app.send(:pagy_searchkick, MockSearchkick::Model.pagy_search('a') { 'B-' })
        results = response.results
        _(pagy).must_be_instance_of Pagy::Searchkick
        _(pagy.count).must_equal 1000
        _(pagy.limit).must_equal Pagy::DEFAULT[:limit]
        _(pagy.page).must_equal app.params[:page].to_i
        _(results.count).must_equal Pagy::DEFAULT[:limit]
        _(results).must_rematch :results
      end
      it 'paginates results with defaults' do
        pagy, results = app.send(:pagy_searchkick, MockSearchkick::Model.pagy_search.results)
        _(pagy).must_be_instance_of Pagy::Searchkick
        _(pagy.count).must_equal 1000
        _(pagy.limit).must_equal Pagy::DEFAULT[:limit]
        _(pagy.page).must_equal app.params[:page].to_i
        _(results.count).must_equal Pagy::DEFAULT[:limit]
        _(results).must_rematch :results
      end
      it 'paginates with opts' do
        pagy, results = app.send(:pagy_searchkick, MockSearchkick::Model.pagy_search('b').results,
                                 page: 2, limit: 10, anchor_string: 'X')
        _(pagy).must_be_instance_of Pagy::Searchkick
        _(pagy.count).must_equal 1000
        _(pagy.limit).must_equal 10
        _(pagy.page).must_equal 2
        _(pagy.opts[:anchor_string]).must_equal 'X'
        _(results.count).must_equal 10
        _(results).must_rematch :results
      end
    end
    describe 'Use search object' do
      it 'paginates results with defaults' do
        results = MockSearchkick::Model.search('a')
        pagy    = app.send(:pagy_searchkick, results)
        _(pagy).must_be_instance_of Pagy::Searchkick
        _(pagy.count).must_equal 1000
        _(pagy.limit).must_equal 10
        _(pagy.page).must_equal 1
      end
      it 'paginates results with opts and no term' do
        results = MockSearchkick::Model.search('b', page: 2, per_page: 15)
        pagy    = app.send(:pagy_searchkick, results, anchor_string: 'X')
        _(pagy).must_be_instance_of Pagy::Searchkick
        _(pagy.count).must_equal 1000
        _(pagy.limit).must_equal 15
        _(pagy.page).must_equal 2
        _(pagy.opts[:anchor_string]).must_equal 'X'
      end
    end
  end
end
