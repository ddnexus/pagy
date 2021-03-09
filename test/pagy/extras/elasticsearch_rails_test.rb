# encoding: utf-8
# frozen_string_literal: true

require_relative '../../test_helper'
require_relative '../../mock_helpers/elasticsearch_rails'
require 'pagy/extras/overflow'

SimpleCov.command_name 'elasticsearch' if ENV['RUN_SIMPLECOV'] == 'true'

describe Pagy::ElasticsearchRails do

  describe '#pagy_search' do

    it 'extends the class with #pagy_search' do
      _(MockElasticsearchRails::Model).must_respond_to :pagy_search
    end

    it 'returns class and arguments' do
      _(MockElasticsearchRails::Model.pagy_search('a', b:2)).must_equal [MockElasticsearchRails::Model, 'a', {b: 2}]
      args  = MockElasticsearchRails::Model.pagy_search('a', b:2)
      _(args).must_equal [MockElasticsearchRails::Model, 'a', {b: 2}]
    end

    it 'adds the caller and arguments' do
      _(MockElasticsearchRails::Model.pagy_search('a', b:2).records).must_equal [MockElasticsearchRails::Model, 'a', {b: 2}, :records]
      _(MockElasticsearchRails::Model.pagy_search('a', b:2).a('b', 2)).must_equal [MockElasticsearchRails::Model, 'a', {b: 2}, :a, 'b', 2]
    end

  end

end

describe Pagy::Backend do

  let(:controller) { MockController.new }

  describe "#pagy_elasticsearch_rails" do

    before do
      @collection = MockCollection.new
    end

    it 'paginates response with defaults' do
      pagy, response = controller.send(:pagy_elasticsearch_rails, MockElasticsearchRails::Model.pagy_search('a'))
      records = response.records
      _(pagy).must_be_instance_of Pagy
      _(pagy.count).must_equal 1000
      _(pagy.items).must_equal Pagy::VARS[:items]
      _(pagy.page).must_equal controller.params[:page]
      _(records.count).must_equal Pagy::VARS[:items]
      _(records).must_equal ["R-a-41", "R-a-42", "R-a-43", "R-a-44", "R-a-45", "R-a-46", "R-a-47", "R-a-48", "R-a-49", "R-a-50", "R-a-51", "R-a-52", "R-a-53", "R-a-54", "R-a-55", "R-a-56", "R-a-57", "R-a-58", "R-a-59", "R-a-60"]
    end

    it 'paginates records with defaults' do
      pagy, records = controller.send(:pagy_elasticsearch_rails, MockElasticsearchRails::Model.pagy_search('a').records)
      _(pagy).must_be_instance_of Pagy
      _(pagy.count).must_equal 1000
      _(pagy.items).must_equal Pagy::VARS[:items]
      _(pagy.page).must_equal controller.params[:page]
      _(records.count).must_equal Pagy::VARS[:items]
      _(records).must_equal ["R-a-41", "R-a-42", "R-a-43", "R-a-44", "R-a-45", "R-a-46", "R-a-47", "R-a-48", "R-a-49", "R-a-50", "R-a-51", "R-a-52", "R-a-53", "R-a-54", "R-a-55", "R-a-56", "R-a-57", "R-a-58", "R-a-59", "R-a-60"]
    end

    it 'paginates with vars' do
      pagy, records = controller.send(:pagy_elasticsearch_rails, MockElasticsearchRails::Model.pagy_search('b').records, page: 2, items: 10, link_extra: 'X')
      _(pagy).must_be_instance_of Pagy
      _(pagy.count).must_equal 1000
      _(pagy.items).must_equal 10
      _(pagy.page).must_equal 2
      _(pagy.vars[:link_extra]).must_equal 'X'
      _(records.count).must_equal 10
      _(records).must_equal ["R-b-11", "R-b-12", "R-b-13", "R-b-14", "R-b-15", "R-b-16", "R-b-17", "R-b-18", "R-b-19", "R-b-20"]
    end

    it 'paginates with overflow' do
      pagy, records = controller.send(:pagy_elasticsearch_rails, MockElasticsearchRails::Model.pagy_search('b').records, page: 200, items: 10, link_extra: 'X', overflow: :last_page)
      _(pagy).must_be_instance_of Pagy
      _(pagy.count).must_equal 1000
      _(pagy.items).must_equal 10
      _(pagy.page).must_equal 100
      _(pagy.vars[:link_extra]).must_equal 'X'
      _(records.count).must_equal 10
      _(records).must_equal ["R-b-991", "R-b-992", "R-b-993", "R-b-994", "R-b-995", "R-b-996", "R-b-997", "R-b-998", "R-b-999", "R-b-1000"]
    end

  end

  describe "#pagy_elasticsearch7_rails" do

    before do
      @collection = MockCollection.new
    end

    it 'paginates response with defaults' do
      pagy, response = controller.send(:pagy_elasticsearch_rails, MockElasticsearchRails::ModelES7.pagy_search('a'))
      records = response.records
      _(pagy).must_be_instance_of Pagy
      _(pagy.count).must_equal 1000
      _(pagy.items).must_equal Pagy::VARS[:items]
      _(pagy.page).must_equal controller.params[:page]
      _(records.count).must_equal Pagy::VARS[:items]
      _(records).must_equal ["R-a-41", "R-a-42", "R-a-43", "R-a-44", "R-a-45", "R-a-46", "R-a-47", "R-a-48", "R-a-49", "R-a-50", "R-a-51", "R-a-52", "R-a-53", "R-a-54", "R-a-55", "R-a-56", "R-a-57", "R-a-58", "R-a-59", "R-a-60"]
    end

    it 'paginates records with defaults' do
      pagy, records = controller.send(:pagy_elasticsearch_rails, MockElasticsearchRails::ModelES7.pagy_search('a').records)
      _(pagy).must_be_instance_of Pagy
      _(pagy.count).must_equal 1000
      _(pagy.items).must_equal Pagy::VARS[:items]
      _(pagy.page).must_equal controller.params[:page]
      _(records.count).must_equal Pagy::VARS[:items]
      _(records).must_equal ["R-a-41", "R-a-42", "R-a-43", "R-a-44", "R-a-45", "R-a-46", "R-a-47", "R-a-48", "R-a-49", "R-a-50", "R-a-51", "R-a-52", "R-a-53", "R-a-54", "R-a-55", "R-a-56", "R-a-57", "R-a-58", "R-a-59", "R-a-60"]
    end

    it 'paginates with vars' do
      pagy, records = controller.send(:pagy_elasticsearch_rails, MockElasticsearchRails::ModelES7.pagy_search('b').records, page: 2, items: 10, link_extra: 'X')
      _(pagy).must_be_instance_of Pagy
      _(pagy.count).must_equal 1000
      _(pagy.items).must_equal 10
      _(pagy.page).must_equal 2
      _(pagy.vars[:link_extra]).must_equal 'X'
      _(records.count).must_equal 10
      _(records).must_equal ["R-b-11", "R-b-12", "R-b-13", "R-b-14", "R-b-15", "R-b-16", "R-b-17", "R-b-18", "R-b-19", "R-b-20"]
    end

    it 'paginates with overflow' do
      pagy, records = controller.send(:pagy_elasticsearch_rails, MockElasticsearchRails::Model.pagy_search('b').records, page: 200, items: 10, link_extra: 'X', overflow: :last_page)
      _(pagy).must_be_instance_of Pagy
      _(pagy.count).must_equal 1000
      _(pagy.items).must_equal 10
      _(pagy.page).must_equal 100
      _(pagy.vars[:link_extra]).must_equal 'X'
      _(records.count).must_equal 10
      _(records).must_equal ["R-b-991", "R-b-992", "R-b-993", "R-b-994", "R-b-995", "R-b-996", "R-b-997", "R-b-998", "R-b-999", "R-b-1000"]
    end

  end

  describe '#pagy_elasticsearch_rails_get_vars' do

    it 'gets defaults' do
      vars   = {}
      merged = controller.send :pagy_elasticsearch_rails_get_vars, nil, vars
      _(merged.keys).must_include :page
      _(merged.keys).must_include :items
      _(merged[:page]).must_equal 3
      _(merged[:items]).must_equal 20
    end

    it 'gets vars' do
      vars   = {page: 2, items: 10, link_extra: 'X'}
      merged = controller.send :pagy_elasticsearch_rails_get_vars, nil, vars
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

    it 'paginates response with defaults on Elasticearch 5' do
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
