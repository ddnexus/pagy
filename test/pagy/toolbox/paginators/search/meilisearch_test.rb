# frozen_string_literal: true

require_relative '../../../../test_helper'
require_relative '../../../../mock_helpers/meilisearch'
require_relative '../../../../mock_helpers/collection'
require_relative '../../../../mock_helpers/app'

describe 'meilisearch' do
  describe 'model#pagy_search' do
    it 'extends the class with #pagy_search' do
      _(MockMeilisearch::Model).must_respond_to :pagy_search
    end
    it 'returns class and arguments' do
      _(MockMeilisearch::Model.pagy_search('a', b: 2)).must_equal [MockMeilisearch::Model, 'a', { b: 2 }, nil]
    end
    it 'adds an empty option hash' do
      _(MockMeilisearch::Model.pagy_search('a')).must_equal [MockMeilisearch::Model, 'a', {}, nil]
    end
  end

  describe 'controller_methods' do
    let(:app) { MockApp.new }

    describe '#pagy_meilisearch' do
      before do
        @collection = MockCollection.new
      end
      it 'paginates response with defaults' do
        pagy, results = app.send(:pagy, :meilisearch, MockMeilisearch::Model.pagy_search('a'))
        _(pagy).must_be_instance_of Pagy::Meilisearch
        _(pagy.count).must_equal 1000
        _(pagy.limit).must_equal Pagy::DEFAULT[:limit]
        _(pagy.page).must_equal app.params[:page].to_i
        _(results.length).must_equal Pagy::DEFAULT[:limit]
        _(results.to_a).must_rematch :results
      end
      it 'paginates with options' do
        pagy, results = app.send(:pagy, :meilisearch, MockMeilisearch::Model.pagy_search('b'),
                                 page: 2, limit: 10)
        _(pagy).must_be_instance_of Pagy::Meilisearch
        _(pagy.count).must_equal 1000
        _(pagy.limit).must_equal 10
        _(pagy.page).must_equal 2
        _(results.length).must_equal 10
        _(results.to_a).must_rematch :results
      end
    end
    describe 'Use search object' do
      it 'paginates results with defaults' do
        results = MockMeilisearch::Model.ms_search('a')
        pagy    = app.send(:pagy, :meilisearch, results)
        _(pagy).must_be_instance_of Pagy::Meilisearch
        _(pagy.count).must_equal 1000
        _(pagy.limit).must_equal 10
        _(pagy.page).must_equal 1
      end
      it 'paginates results with options' do
        results = MockMeilisearch::Model.ms_search('b', hits_per_page: 15, page: 3)
        pagy    = app.send(:pagy, :meilisearch, results)
        _(pagy).must_be_instance_of Pagy::Meilisearch
        _(pagy.count).must_equal 1000
        _(pagy.limit).must_equal 15
        _(pagy.page).must_equal 3
      end
    end
  end
end
