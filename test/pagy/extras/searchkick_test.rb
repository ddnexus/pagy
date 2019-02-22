# encoding: utf-8
# frozen_string_literal: true

require_relative '../../test_helper'
require_relative '../../test_helper/searchkick'

SingleCov.covered! unless ENV['SKIP_SINGLECOV']

describe Pagy::Search do

  describe '#pagy_search' do

    it 'extends the class with #pagy_search' do
      SearchkickModel.must_respond_to :pagy_search
    end

    it 'returns class and arguments' do
      SearchkickModel.pagy_search('a', b:2).must_equal [SearchkickModel, 'a', {b: 2}, nil]
      args  = SearchkickModel.pagy_search('a', b:2){|a| a*2}
      block = args[-1]
      args.must_equal [SearchkickModel, 'a', {b: 2}, block]
    end

    it 'adds the caller and arguments' do
      SearchkickModel.pagy_search('a', b:2).results.must_equal [SearchkickModel, 'a', {b: 2}, nil, :results]
      SearchkickModel.pagy_search('a', b:2).a('b', 2).must_equal [SearchkickModel, 'a', {b: 2}, nil, :a, 'b', 2]
    end

  end

end

describe Pagy::Backend do

  let(:backend) { TestController.new }

  describe "#pagy_searchkick" do

    before do
      @collection = TestCollection.new((1..1000).to_a)
    end

    it 'paginates response with defaults' do
      pagy, response = backend.send(:pagy_searchkick, SearchkickModel.pagy_search('a'){'B-'})
      results = response.results
      pagy.must_be_instance_of Pagy
      pagy.count.must_equal 1000
      pagy.items.must_equal Pagy::VARS[:items]
      pagy.page.must_equal backend.params[:page]
      results.count.must_equal Pagy::VARS[:items]
      results.must_equal ["R-B-a-41", "R-B-a-42", "R-B-a-43", "R-B-a-44", "R-B-a-45", "R-B-a-46", "R-B-a-47", "R-B-a-48", "R-B-a-49", "R-B-a-50", "R-B-a-51", "R-B-a-52", "R-B-a-53", "R-B-a-54", "R-B-a-55", "R-B-a-56", "R-B-a-57", "R-B-a-58", "R-B-a-59", "R-B-a-60"]    end

    it 'paginates results with defaults' do
      pagy, results = backend.send(:pagy_searchkick, SearchkickModel.pagy_search('a').results)
      pagy.must_be_instance_of Pagy
      pagy.count.must_equal 1000
      pagy.items.must_equal Pagy::VARS[:items]
      pagy.page.must_equal backend.params[:page]
      results.count.must_equal Pagy::VARS[:items]
      results.must_equal ["R-a-41", "R-a-42", "R-a-43", "R-a-44", "R-a-45", "R-a-46", "R-a-47", "R-a-48", "R-a-49", "R-a-50", "R-a-51", "R-a-52", "R-a-53", "R-a-54", "R-a-55", "R-a-56", "R-a-57", "R-a-58", "R-a-59", "R-a-60"]
    end

    it 'paginates with vars' do
      pagy, results = backend.send(:pagy_searchkick, SearchkickModel.pagy_search('b').results, page: 2, items: 10, link_extra: 'X')
      pagy.must_be_instance_of Pagy
      pagy.count.must_equal 1000
      pagy.items.must_equal 10
      pagy.page.must_equal 2
      pagy.vars[:link_extra].must_equal 'X'
      results.count.must_equal 10
      results.must_equal ["R-b-11", "R-b-12", "R-b-13", "R-b-14", "R-b-15", "R-b-16", "R-b-17", "R-b-18", "R-b-19", "R-b-20"]
    end

  end

  describe '#pagy_searchkick_get_vars' do

    it 'gets defaults' do
      vars   = {}
      merged = backend.send :pagy_searchkick_get_vars, nil, vars
      merged.keys.must_include :page
      merged.keys.must_include :items
      merged[:page].must_equal 3
      merged[:items].must_equal 20
    end

    it 'gets vars' do
      vars   = {page: 2, items: 10, link_extra: 'X'}
      merged = backend.send :pagy_searchkick_get_vars, nil, vars
      merged.keys.must_include :page
      merged.keys.must_include :items
      merged.keys.must_include :link_extra
      merged[:page].must_equal 2
      merged[:items].must_equal 10
      merged[:link_extra].must_equal 'X'
    end

  end

  describe 'Pagy.new_from_searchkick' do

    it 'paginates results with defaults' do
      results = SearchkickModel.search('a')
      pagy    = Pagy.new_from_searchkick(results)
      pagy.must_be_instance_of Pagy
      pagy.count.must_equal 1000
      pagy.items.must_equal 1000
      pagy.page.must_equal 1
    end

    it 'paginates results with vars' do
      results = SearchkickModel.search('b', page: 2, per_page: 15)
      pagy    = Pagy.new_from_searchkick(results, link_extra: 'X')
      pagy.must_be_instance_of Pagy
      pagy.count.must_equal 1000
      pagy.items.must_equal 15
      pagy.page.must_equal 2
      pagy.vars[:link_extra].must_equal 'X'
    end

  end

end
