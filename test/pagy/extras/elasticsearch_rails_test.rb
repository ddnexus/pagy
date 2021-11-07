# frozen_string_literal: true

require_relative '../../test_helper'
require 'pagy/extras/overflow'

require_relative '../../mock_helpers/elasticsearch_rails'
require_relative '../../mock_helpers/collection'
require_relative '../../mock_helpers/app'

describe 'pagy/extras/elasticsearch_rails' do
  describe 'model#pagy_search' do
    it 'extends the class with #pagy_search' do
      _(MockElasticsearchRails::Model).must_respond_to :pagy_search
    end
    it 'returns class and arguments' do
      _(MockElasticsearchRails::Model.pagy_search('a', b: 2)).must_equal [MockElasticsearchRails::Model, 'a', { b: 2 }]
      args = MockElasticsearchRails::Model.pagy_search('a', b: 2)
      _(args).must_equal [MockElasticsearchRails::Model, 'a', { b: 2 }]
    end
    it 'adds the caller and arguments' do
      _(MockElasticsearchRails::Model.pagy_search('a', b: 2).records).must_equal [MockElasticsearchRails::Model, 'a', { b: 2 }, :records]
      _(MockElasticsearchRails::Model.pagy_search('a', b: 2).a('b', 2)).must_equal [MockElasticsearchRails::Model, 'a', { b: 2 }, :a, 'b', 2]
    end
  end

  describe 'controller_methods' do
    let(:app) { MockApp.new }

    describe '#pagy_elasticsearch_rails' do
      before do
        @collection = MockCollection.new
      end
      it 'paginates response with defaults' do
        pagy, response = app.send(:pagy_elasticsearch_rails, MockElasticsearchRails::Model.pagy_search('a'))
        records = response.records
        _(pagy).must_be_instance_of Pagy
        _(pagy.count).must_equal 1000
        _(pagy.items).must_equal Pagy::DEFAULT[:items]
        _(pagy.page).must_equal app.params[:page]
        _(records.count).must_equal Pagy::DEFAULT[:items]
        _(records).must_rematch
      end
      it 'paginates records with defaults' do
        pagy, records = app.send(:pagy_elasticsearch_rails,
                                 MockElasticsearchRails::Model.pagy_search('a').records)
        _(pagy).must_be_instance_of Pagy
        _(pagy.count).must_equal 1000
        _(pagy.items).must_equal Pagy::DEFAULT[:items]
        _(pagy.page).must_equal app.params[:page]
        _(records.count).must_equal Pagy::DEFAULT[:items]
        _(records).must_rematch
      end
      it 'paginates with vars' do
        pagy, records = app.send(:pagy_elasticsearch_rails,
                                 MockElasticsearchRails::Model.pagy_search('b').records,
                                 page: 2, items: 10, link_extra: 'X')
        _(pagy).must_be_instance_of Pagy
        _(pagy.count).must_equal 1000
        _(pagy.items).must_equal 10
        _(pagy.page).must_equal 2
        _(pagy.vars[:link_extra]).must_equal 'X'
        _(records.count).must_equal 10
        _(records).must_rematch
      end
      it 'paginates with overflow' do
        pagy, records = app.send(:pagy_elasticsearch_rails,
                                 MockElasticsearchRails::Model.pagy_search('b').records,
                                 page: 200, items: 10, link_extra: 'X', overflow: :last_page)
        _(pagy).must_be_instance_of Pagy
        _(pagy.count).must_equal 1000
        _(pagy.items).must_equal 10
        _(pagy.page).must_equal 100
        _(pagy.vars[:link_extra]).must_equal 'X'
        _(records.count).must_equal 10
        _(records).must_rematch
      end
    end

    describe '#pagy_elasticsearch7_rails' do
      before do
        @collection = MockCollection.new
      end
      it 'paginates response with defaults' do
        pagy, response = app.send(:pagy_elasticsearch_rails, MockElasticsearchRails::ModelES7.pagy_search('a'))
        records = response.records
        _(pagy).must_be_instance_of Pagy
        _(pagy.count).must_equal 1000
        _(pagy.items).must_equal Pagy::DEFAULT[:items]
        _(pagy.page).must_equal app.params[:page]
        _(records.count).must_equal Pagy::DEFAULT[:items]
        _(records).must_rematch
      end
      it 'paginates records with defaults' do
        pagy, records = app.send(:pagy_elasticsearch_rails,
                                 MockElasticsearchRails::ModelES7.pagy_search('a').records)
        _(pagy).must_be_instance_of Pagy
        _(pagy.count).must_equal 1000
        _(pagy.items).must_equal Pagy::DEFAULT[:items]
        _(pagy.page).must_equal app.params[:page]
        _(records.count).must_equal Pagy::DEFAULT[:items]
        _(records).must_rematch
      end
      it 'paginates with vars' do
        pagy, records = app.send(:pagy_elasticsearch_rails,
                                 MockElasticsearchRails::ModelES7.pagy_search('b').records,
                                 page: 2, items: 10, link_extra: 'X')
        _(pagy).must_be_instance_of Pagy
        _(pagy.count).must_equal 1000
        _(pagy.items).must_equal 10
        _(pagy.page).must_equal 2
        _(pagy.vars[:link_extra]).must_equal 'X'
        _(records.count).must_equal 10
        _(records).must_rematch
      end
      it 'paginates with overflow' do
        pagy, records = app.send(:pagy_elasticsearch_rails,
                                 MockElasticsearchRails::Model.pagy_search('b').records,
                                 page: 200, items: 10, link_extra: 'X', overflow: :last_page)
        _(pagy).must_be_instance_of Pagy
        _(pagy.count).must_equal 1000
        _(pagy.items).must_equal 10
        _(pagy.page).must_equal 100
        _(pagy.vars[:link_extra]).must_equal 'X'
        _(records.count).must_equal 10
        _(records).must_rematch
      end
    end

    describe '#pagy_elasticsearch_rails_get_vars' do
      it 'gets defaults' do
        vars   = {}
        merged = app.send :pagy_elasticsearch_rails_get_vars, nil, vars
        _(merged.keys).must_include :page
        _(merged.keys).must_include :items
        _(merged[:page]).must_equal 3
        _(merged[:items]).must_equal 20
      end
      it 'gets vars' do
        vars   = { page: 2, items: 10, link_extra: 'X' }
        merged = app.send :pagy_elasticsearch_rails_get_vars, nil, vars
        _(merged.keys).must_include :page
        _(merged.keys).must_include :items
        _(merged.keys).must_include :link_extra
        _(merged[:page]).must_equal 2
        _(merged[:items]).must_equal 10
        _(merged[:link_extra]).must_equal 'X'
      end
    end

    describe 'Pagy.new_from_elasticsearch_rails' do
      it 'paginates response with defaults' do
        response = MockElasticsearchRails::Model.search('a')
        pagy     = Pagy.new_from_elasticsearch_rails(response)
        _(pagy).must_be_instance_of Pagy
        _(pagy.count).must_equal 1000
        _(pagy.items).must_equal 10
        _(pagy.page).must_equal 1
      end
      it 'paginates response with vars' do
        response = MockElasticsearchRails::Model.search('b', from: 15, size: 15)
        pagy     = Pagy.new_from_elasticsearch_rails(response, link_extra: 'X')
        _(pagy).must_be_instance_of Pagy
        _(pagy.count).must_equal 1000
        _(pagy.items).must_equal 15
        _(pagy.page).must_equal 2
        _(pagy.vars[:link_extra]).must_equal 'X'
      end
      it 'paginates response with defaults on Elasticsearch 5' do
        response = MockElasticsearchRails::ModelES5.search('a')
        pagy     = Pagy.new_from_elasticsearch_rails(response)
        _(pagy).must_be_instance_of Pagy
        _(pagy.count).must_equal 1000
        _(pagy.items).must_equal 10
        _(pagy.page).must_equal 1
      end
      it 'paginates response with vars on Elasticsearch 5' do
        response = MockElasticsearchRails::ModelES5.search('b', from: 15, size: 15)
        pagy     = Pagy.new_from_elasticsearch_rails(response, link_extra: 'X')
        _(pagy).must_be_instance_of Pagy
        _(pagy.count).must_equal 1000
        _(pagy.items).must_equal 15
        _(pagy.page).must_equal 2
        _(pagy.vars[:link_extra]).must_equal 'X'
      end
    end
  end
end
