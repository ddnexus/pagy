# encoding: utf-8
# frozen_string_literal: true

require_relative '../../test_helper'
require_relative '../../test_helper/elasticsearch_rails'
require 'pagy/extras/overflow'

SimpleCov.command_name 'elasticsearch' if ENV['RUN_SIMPLECOV']

describe Pagy::Search do

  describe '#pagy_search' do

    it 'extends the class with #pagy_search' do
      ElasticsearchRailsModel.must_respond_to :pagy_search
    end

    it 'returns class and arguments' do
      ElasticsearchRailsModel.pagy_search('a', b:2).must_equal [ElasticsearchRailsModel, 'a', {b: 2}, nil]
      args  = ElasticsearchRailsModel.pagy_search('a', b:2){|a| a*2}
      block = args[-1]
      args.must_equal [ElasticsearchRailsModel, 'a', {b: 2}, block]
    end

    it 'adds the caller and arguments' do
      ElasticsearchRailsModel.pagy_search('a', b:2).records.must_equal [ElasticsearchRailsModel, 'a', {b: 2}, nil, :records]
      ElasticsearchRailsModel.pagy_search('a', b:2).a('b', 2).must_equal [ElasticsearchRailsModel, 'a', {b: 2}, nil, :a, 'b', 2]
    end

  end

end

describe Pagy::Backend do

  let(:backend) { TestController.new }

  describe "#pagy_elasticsearch_rails" do

    before do
      @collection = TestCollection.new((1..1000).to_a)
    end

    it 'paginates response with defaults' do
      pagy, response = backend.send(:pagy_elasticsearch_rails, ElasticsearchRailsModel.pagy_search('a'))
      records = response.records
      pagy.must_be_instance_of Pagy
      pagy.count.must_equal 1000
      pagy.items.must_equal Pagy::VARS[:items]
      pagy.page.must_equal backend.params[:page]
      records.count.must_equal Pagy::VARS[:items]
      records.must_equal ["R-a-41", "R-a-42", "R-a-43", "R-a-44", "R-a-45", "R-a-46", "R-a-47", "R-a-48", "R-a-49", "R-a-50", "R-a-51", "R-a-52", "R-a-53", "R-a-54", "R-a-55", "R-a-56", "R-a-57", "R-a-58", "R-a-59", "R-a-60"]
    end

    it 'paginates records with defaults' do
      pagy, records = backend.send(:pagy_elasticsearch_rails, ElasticsearchRailsModel.pagy_search('a').records)
      pagy.must_be_instance_of Pagy
      pagy.count.must_equal 1000
      pagy.items.must_equal Pagy::VARS[:items]
      pagy.page.must_equal backend.params[:page]
      records.count.must_equal Pagy::VARS[:items]
      records.must_equal ["R-a-41", "R-a-42", "R-a-43", "R-a-44", "R-a-45", "R-a-46", "R-a-47", "R-a-48", "R-a-49", "R-a-50", "R-a-51", "R-a-52", "R-a-53", "R-a-54", "R-a-55", "R-a-56", "R-a-57", "R-a-58", "R-a-59", "R-a-60"]
    end

    it 'paginates with vars' do
      pagy, records = backend.send(:pagy_elasticsearch_rails, ElasticsearchRailsModel.pagy_search('b').records, page: 2, items: 10, link_extra: 'X')
      pagy.must_be_instance_of Pagy
      pagy.count.must_equal 1000
      pagy.items.must_equal 10
      pagy.page.must_equal 2
      pagy.vars[:link_extra].must_equal 'X'
      records.count.must_equal 10
      records.must_equal ["R-b-11", "R-b-12", "R-b-13", "R-b-14", "R-b-15", "R-b-16", "R-b-17", "R-b-18", "R-b-19", "R-b-20"]
    end

    it 'paginates with overflow' do
      pagy, records = backend.send(:pagy_elasticsearch_rails, ElasticsearchRailsModel.pagy_search('b').records, page: 200, items: 10, link_extra: 'X', overflow: :last_page)
      pagy.must_be_instance_of Pagy
      pagy.count.must_equal 1000
      pagy.items.must_equal 10
      pagy.page.must_equal 100
      pagy.vars[:link_extra].must_equal 'X'
      records.count.must_equal 10
      records.must_equal ["R-b-991", "R-b-992", "R-b-993", "R-b-994", "R-b-995", "R-b-996", "R-b-997", "R-b-998", "R-b-999", "R-b-1000"]
    end

  end

  describe '#pagy_elasticsearch_rails_get_vars' do

    it 'gets defaults' do
      vars   = {}
      merged = backend.send :pagy_elasticsearch_rails_get_vars, nil, vars
      merged.keys.must_include :page
      merged.keys.must_include :items
      merged[:page].must_equal 3
      merged[:items].must_equal 20
    end

    it 'gets vars' do
      vars   = {page: 2, items: 10, link_extra: 'X'}
      merged = backend.send :pagy_elasticsearch_rails_get_vars, nil, vars
      merged.keys.must_include :page
      merged.keys.must_include :items
      merged.keys.must_include :link_extra
      merged[:page].must_equal 2
      merged[:items].must_equal 10
      merged[:link_extra].must_equal 'X'
    end

  end

  describe 'Pagy.new_from_elasticsearch_rails' do

    it 'paginates response with defaults' do
      response = ElasticsearchRailsModel.search('a')
      pagy     = Pagy.new_from_elasticsearch_rails(response)
      pagy.must_be_instance_of Pagy
      pagy.count.must_equal 1000
      pagy.items.must_equal 10
      pagy.page.must_equal 1
    end

    it 'paginates response with vars' do
      response = ElasticsearchRailsModel.search('b', from: 15, size: 15)
      pagy     = Pagy.new_from_elasticsearch_rails(response, link_extra: 'X')
      pagy.must_be_instance_of Pagy
      pagy.count.must_equal 1000
      pagy.items.must_equal 15
      pagy.page.must_equal 2
      pagy.vars[:link_extra].must_equal 'X'
    end

  end

end
