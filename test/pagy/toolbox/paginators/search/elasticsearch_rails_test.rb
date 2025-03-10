# frozen_string_literal: true

require_relative '../../../../test_helper'
require_relative '../../../../mock_helpers/elasticsearch_rails'
require_relative '../../../../mock_helpers/collection'
require_relative '../../../../mock_helpers/app'

describe 'elasticsearch_rails' do
  describe 'model#pagy_search' do
    it 'extends the class with #pagy_search' do
      _(MockElasticsearchRails::Model).must_respond_to :pagy_search
    end
    it 'returns class and arguments' do
      _(MockElasticsearchRails::Model.pagy_search('a', b: 2)).must_equal [MockElasticsearchRails::Model, 'a', { b: 2 }, nil]
      args = MockElasticsearchRails::Model.pagy_search('a', b: 2)
      _(args).must_equal [MockElasticsearchRails::Model, 'a', { b: 2 }, nil]
    end
    it 'adds the caller and arguments' do
      _(MockElasticsearchRails::Model.pagy_search('a', b: 2).records).must_equal [MockElasticsearchRails::Model, 'a', { b: 2 }, nil, :records]
      _(MockElasticsearchRails::Model.pagy_search('a', b: 2).a('b', 2)).must_equal [MockElasticsearchRails::Model, 'a', { b: 2 }, nil, :a, 'b', 2]
    end
  end

  describe 'controller_methods' do
    let(:app) { MockApp.new }

    describe '#pagy_elasticsearch_rails' do
      before do
        @collection = MockCollection.new
      end
      it 'paginates response with defaults' do
        pagy, response = app.send(:pagy, :elasticsearch_rails, MockElasticsearchRails::Model.pagy_search('a'))
        records = response.records
        _(pagy).must_be_instance_of Pagy::ElasticsearchRails
        _(pagy.count).must_equal 1000
        _(pagy.limit).must_equal Pagy::DEFAULT[:limit]
        _(pagy.page).must_equal app.params[:page].to_i
        _(records.count).must_equal Pagy::DEFAULT[:limit]
        _(records).must_rematch :records
      end
      it 'paginates records with defaults' do
        pagy, records = app.send(:pagy, :elasticsearch_rails,
                                 MockElasticsearchRails::Model.pagy_search('a').records)
        _(pagy).must_be_instance_of Pagy::ElasticsearchRails
        _(pagy.count).must_equal 1000
        _(pagy.limit).must_equal Pagy::DEFAULT[:limit]
        _(pagy.page).must_equal app.params[:page].to_i
        _(records.count).must_equal Pagy::DEFAULT[:limit]
        _(records).must_rematch :records
      end
      it 'paginates with options' do
        pagy, records = app.send(:pagy, :elasticsearch_rails,
                                 MockElasticsearchRails::Model.pagy_search('b').records,
                                 page: 2, limit: 10)
        _(pagy).must_be_instance_of Pagy::ElasticsearchRails
        _(pagy.count).must_equal 1000
        _(pagy.limit).must_equal 10
        _(pagy.page).must_equal 2
        _(records.count).must_equal 10
        _(records).must_rematch :records
      end
    end

    describe '#pagy_elasticsearch7_rails' do
      before do
        @collection = MockCollection.new
      end
      it 'paginates response with defaults' do
        pagy, response = app.send(:pagy, :elasticsearch_rails, MockElasticsearchRails::ModelES7.pagy_search('a'))
        records = response.records
        _(pagy).must_be_instance_of Pagy::ElasticsearchRails
        _(pagy.count).must_equal 1000
        _(pagy.limit).must_equal Pagy::DEFAULT[:limit]
        _(pagy.page).must_equal app.params[:page].to_i
        _(records.count).must_equal Pagy::DEFAULT[:limit]
        _(records).must_rematch :records
      end
      it 'paginates records with defaults' do
        pagy, records = app.send(:pagy, :elasticsearch_rails,
                                 MockElasticsearchRails::ModelES7.pagy_search('a').records)
        _(pagy).must_be_instance_of Pagy::ElasticsearchRails
        _(pagy.count).must_equal 1000
        _(pagy.limit).must_equal Pagy::DEFAULT[:limit]
        _(pagy.page).must_equal app.params[:page].to_i
        _(records.count).must_equal Pagy::DEFAULT[:limit]
        _(records).must_rematch :records
      end
      it 'paginates with options' do
        pagy, records = app.send(:pagy, :elasticsearch_rails,
                                 MockElasticsearchRails::ModelES7.pagy_search('b').records,
                                 page: 2, limit: 10)
        _(pagy).must_be_instance_of Pagy::ElasticsearchRails
        _(pagy.count).must_equal 1000
        _(pagy.limit).must_equal 10
        _(pagy.page).must_equal 2
        _(records.count).must_equal 10
        _(records).must_rematch :records
      end
    end
    describe 'Use search object' do
      it 'paginates response with defaults' do
        response = MockElasticsearchRails::Model.search('a')
        pagy     = app.send(:pagy, :elasticsearch_rails, response)
        _(pagy).must_be_instance_of Pagy::ElasticsearchRails
        _(pagy.count).must_equal 1000
        _(pagy.limit).must_equal 10
        _(pagy.page).must_equal 1
      end
      it 'paginates response with options' do
        response = MockElasticsearchRails::Model.search('b', from: 15, size: 15)
        pagy     = app.send(:pagy, :elasticsearch_rails, response)
        _(pagy).must_be_instance_of Pagy::ElasticsearchRails
        _(pagy.count).must_equal 1000
        _(pagy.limit).must_equal 15
        _(pagy.page).must_equal 2
      end
      it 'paginates response with defaults on Elasticsearch 5' do
        response = MockElasticsearchRails::ModelES5.search('a')
        pagy     = app.send(:pagy, :elasticsearch_rails, response)
        _(pagy).must_be_instance_of Pagy::ElasticsearchRails
        _(pagy.count).must_equal 1000
        _(pagy.limit).must_equal 10
        _(pagy.page).must_equal 1
      end
      it 'paginates response with options on Elasticsearch 5' do
        response = MockElasticsearchRails::ModelES5.search('b', from: 15, size: 15)
        pagy     = app.send(:pagy, :elasticsearch_rails, response)
        _(pagy).must_be_instance_of Pagy::ElasticsearchRails
        _(pagy.count).must_equal 1000
        _(pagy.limit).must_equal 15
        _(pagy.page).must_equal 2
      end
    end
  end
end
