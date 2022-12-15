# frozen_string_literal: true

require_relative '../../test_helper'
require_relative '../../mock_helpers/meilisearch'
require_relative '../../mock_helpers/collection'
require_relative '../../mock_helpers/app'

require 'pagy/extras/overflow'

describe 'pagy/extras/meilisearch' do
  describe 'model#pagy_search' do
    it 'extends the class with #pagy_search' do
      _(MockMeilisearch::Model).must_respond_to :pagy_search
    end
    it 'returns class and arguments' do
      _(MockMeilisearch::Model.pagy_search('a', b: 2)).must_equal [MockMeilisearch::Model, 'a', { b: 2 }]
    end
    it 'allows the query argument to be optional' do
      _(MockMeilisearch::Model.pagy_search(b: 2)).must_equal [MockMeilisearch::Model, nil, { b: 2 }]
    end
    it 'adds an empty option hash' do
      _(MockMeilisearch::Model.pagy_search('a')).must_equal [MockMeilisearch::Model, 'a', {}]
    end
  end

  describe 'controller_methods' do
    let(:app) { MockApp.new }

    describe '#pagy_meilisearch' do
      before do
        @collection = MockCollection.new
      end
      it 'paginates response with defaults' do
        pagy, results = app.send(:pagy_meilisearch, MockMeilisearch::Model.pagy_search('a'))
        _(pagy).must_be_instance_of Pagy
        _(pagy.count).must_equal 1000
        _(pagy.items).must_equal Pagy::DEFAULT[:items]
        _(pagy.page).must_equal app.params[:page]
        _(results.length).must_equal Pagy::DEFAULT[:items]
        _(results.to_a).must_rematch
      end
      it 'paginates with vars' do
        pagy, results = app.send(:pagy_meilisearch, MockMeilisearch::Model.pagy_search('b'),
                                 page: 2, items: 10, link_extra: 'X')
        _(pagy).must_be_instance_of Pagy
        _(pagy.count).must_equal 1000
        _(pagy.items).must_equal 10
        _(pagy.page).must_equal 2
        _(pagy.vars[:link_extra]).must_equal 'X'
        _(results.length).must_equal 10
        _(results.to_a).must_rematch
      end
      it 'paginates with overflow' do
        pagy, results = app.send(:pagy_meilisearch, MockMeilisearch::Model.pagy_search('b'),
                                 page: 200, items: 10, link_extra: 'X', overflow: :last_page)
        _(pagy).must_be_instance_of Pagy
        _(pagy.count).must_equal 1000
        _(pagy.items).must_equal 10
        _(pagy.page).must_equal 100
        _(pagy.vars[:link_extra]).must_equal 'X'
        _(results.length).must_equal 10
        _(results.to_a).must_rematch
      end
    end

    describe '#pagy_meilisearch_get_vars' do
      it 'gets defaults' do
        vars   = {}
        merged = app.send :pagy_meilisearch_get_vars, nil, vars
        _(merged.keys).must_include :page
        _(merged.keys).must_include :items
        _(merged[:page]).must_equal 3
        _(merged[:items]).must_equal 20
      end
      it 'gets vars' do
        vars   = { page: 2, items: 10, link_extra: 'X' }
        merged = app.send :pagy_meilisearch_get_vars, nil, vars
        _(merged.keys).must_include :page
        _(merged.keys).must_include :items
        _(merged.keys).must_include :link_extra
        _(merged[:page]).must_equal 2
        _(merged[:items]).must_equal 10
        _(merged[:link_extra]).must_equal 'X'
      end
    end

    describe 'Pagy.new_from_meilisearch' do
      it 'paginates results with defaults' do
        results = MockMeilisearch::Model.ms_search('a')
        pagy    = Pagy.new_from_meilisearch(results)
        _(pagy).must_be_instance_of Pagy
        _(pagy.count).must_equal 1000
        _(pagy.items).must_equal 10
        _(pagy.page).must_equal 1
      end
      it 'paginates results with vars' do
        results = MockMeilisearch::Model.ms_search('b', hits_per_page: 15, page: 3)
        pagy    = Pagy.new_from_meilisearch(results, link_extra: 'X')
        _(pagy).must_be_instance_of Pagy
        _(pagy.count).must_equal 1000
        _(pagy.items).must_equal 15
        _(pagy.page).must_equal 3
        _(pagy.vars[:link_extra]).must_equal 'X'
      end
    end
  end
end
