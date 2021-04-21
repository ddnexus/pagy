# frozen_string_literal: true

require_relative '../../test_helper'
require_relative '../../mock_helpers/elasticsearch_rails'
require_relative '../../mock_helpers/searchkick'
require 'pagy/extras/items'

describe Pagy::Backend do

  describe "#pagy_get_vars and #pagy_countless_get_vars" do

    before do
      @collection = MockCollection.new
    end

    it 'uses the defaults' do
      vars    = {}
      controller = MockController.new
      [:pagy_elasticsearch_rails_get_vars, :pagy_searchkick_get_vars].each do |method|
        merged  = controller.send method, nil, vars
        _(merged.keys).must_include :items
        _(merged[:items]).must_equal 20
      end
    end

    it 'uses the vars' do
      vars    = {items: 15}     # force items
      params  = {:a=>"a", :page=>3, :items=>12}
      controller = MockController.new params
      _(controller.params).must_equal params

      [[:pagy_elasticsearch_rails, MockElasticsearchRails::Model], [:pagy_searchkick, MockSearchkick::Model]].each do |meth, mod|
        pagy, records = controller.send meth, mod.pagy_search('a').records, vars
        _(pagy.items).must_equal 15
        _(records.size).must_equal 15
      end
    end

    it 'uses the params' do
      vars    = {}
      params  = {:a=>"a", :page=>3, :items=>12}
      controller = MockController.new params
      _(controller.params).must_equal params

      [[:pagy_elasticsearch_rails, MockElasticsearchRails::Model], [:pagy_searchkick, MockSearchkick::Model]].each do |meth, mod|
        pagy, records = controller.send meth, mod.pagy_search('a').records, vars
        _(pagy.items).must_equal 12
        _(records.size).must_equal 12
      end
    end

    it 'uses the params without page' do
      vars    = {}
      params  = {:a=>"a", :items=>12}
      controller = MockController.new params
      _(controller.params).must_equal params

      [[:pagy_elasticsearch_rails, MockElasticsearchRails::Model], [:pagy_searchkick, MockSearchkick::Model]].each do |meth, mod|
        pagy, records = controller.send meth, mod.pagy_search('a').records, vars
        _(pagy.items).must_equal 12
        _(records.size).must_equal 12
      end
    end


    it 'overrides the params' do
      vars    = {items: 21}
      params  = {:a=>"a", :page=>3, :items=>12}
      controller = MockController.new params
      _(controller.params).must_equal params

      [[:pagy_elasticsearch_rails, MockElasticsearchRails::Model], [:pagy_searchkick, MockSearchkick::Model]].each do |meth, mod|
        pagy, records = controller.send meth, mod.pagy_search('a').records, vars
        _(pagy.items).must_equal 21
        _(records.size).must_equal 21
      end
    end

    it 'uses the max_items default' do
      vars    = {}
      params  = {:a=>"a", :page=>3, :items=>120}
      controller = MockController.new params
      _(controller.params).must_equal params

      [[:pagy_elasticsearch_rails, MockElasticsearchRails::Model], [:pagy_searchkick, MockSearchkick::Model]].each do |meth, mod|
        pagy, records = controller.send meth, mod.pagy_search('a').records, vars
        _(pagy.items).must_equal 100
        _(records.size).must_equal 100
      end
    end

    it 'doesn\'t limit the items from vars' do
      vars    = {max_items: nil}
      params  = {:a=>"a", :items=>1000}
      controller = MockController.new params
      _(controller.params).must_equal params

      [[:pagy_elasticsearch_rails, MockElasticsearchRails::Model], [:pagy_searchkick, MockSearchkick::Model]].each do |meth, mod|
        pagy, records = controller.send meth, mod.pagy_search('a').records, vars
        _(pagy.items).must_equal 1000
        _(records.size).must_equal 1000
      end
    end

    it 'doesn\'t limit the items from default' do
      vars = {}
      params = {:a=>"a", :items=>1000}
      controller = MockController.new params
      _(controller.params).must_equal params
      Pagy::VARS[:max_items] = nil

      [[:pagy_elasticsearch_rails, MockElasticsearchRails::Model], [:pagy_searchkick, MockSearchkick::Model]].each do |meth, mod|
        pagy, records = controller.send meth, mod.pagy_search('a').records, vars
        _(pagy.items).must_equal 1000
        _(records.size).must_equal 1000
      end
      Pagy::VARS[:max_items] = 100 # reset default
    end

    it 'uses items_param from vars' do
      vars    = {items_param: :custom}
      params  = {:a=>"a", :page=>3, :items_param=>:custom, :custom=>14}
      controller = MockController.new params
      _(controller.params).must_equal params

      [[:pagy_elasticsearch_rails, MockElasticsearchRails::Model], [:pagy_searchkick, MockSearchkick::Model]].each do |meth, mod|
        pagy, records = controller.send meth, mod.pagy_search('a').records, vars
        _(pagy.items).must_equal 14
        _(records.size).must_equal 14
      end
    end

    it 'uses items_param from default' do
      vars = {}
      params = {:a=>"a", :page=>3, :custom=>15}
      controller = MockController.new params
      _(controller.params).must_equal params
      Pagy::VARS[:items_param] = :custom

      [[:pagy_elasticsearch_rails, MockElasticsearchRails::Model], [:pagy_searchkick, MockSearchkick::Model]].each do |meth, mod|
        pagy, records = controller.send meth, mod.pagy_search('a').records, vars
        _(pagy.items).must_equal 15
        _(records.size).must_equal 15
      end
      Pagy::VARS[:items_param] = :items  # reset default
    end

  end

end

describe Pagy::Frontend do

  let(:view) { MockView.new }

  describe '#pagy_url_for' do

    it 'renders basic url' do
      pagy = Pagy.new count: 1000, page: 3
      _(view.pagy_url_for(5, pagy)).must_equal '/foo?page=5&items=20'
    end

    it 'renders basic url and items var' do
      pagy = Pagy.new count: 1000, page: 3, items: 50
      _(view.pagy_url_for(5, pagy)).must_equal '/foo?page=5&items=50'
    end

    it 'renders url with items_params' do
      pagy = Pagy.new count: 1000, page: 3, items_param: :custom
      _(view.pagy_url_for(5, pagy)).must_equal '/foo?page=5&custom=20'
    end

    it 'renders url with anchor' do
      pagy = Pagy.new count: 1000, page: 3, anchor: '#anchor'
      _(view.pagy_url_for(6, pagy)).must_equal '/foo?page=6&items=20#anchor'
    end

    it 'renders url with params and anchor' do
      pagy = Pagy.new count: 1000, page: 3, params: {a: 3, b: 4}, anchor: '#anchor', items: 40
      _(view.pagy_url_for(5, pagy)).must_equal "/foo?page=5&a=3&b=4&items=40#anchor"
    end

  end

  describe '#pagy_items_selector_js with elasticsearch' do

    it 'renders items selector' do
      @pagy = Pagy.new count: 1000, page: 3
      _(view.pagy_items_selector_js(@pagy, pagy_id: 'test-id')).must_equal \
        "<span id=\"test-id\">Show <input type=\"number\" min=\"1\" max=\"100\" value=\"20\" style=\"padding: 0; text-align: center; width: 3rem;\"> items per page</span><script type=\"application/json\" class=\"pagy-json\">[\"items_selector\",41,\"<a href=\\\"/foo?page=__pagy_page__&items=__pagy_items__\\\"   style=\\\"display: none;\\\"></a>\"]</script>"
    end

  end

end
