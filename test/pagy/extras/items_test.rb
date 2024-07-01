# frozen_string_literal: true

require_relative '../../test_helper'

require 'pagy/extras/countless'
require 'pagy/extras/arel'
require 'pagy/extras/array'
require 'pagy/extras/items'

require_relative '../../mock_helpers/elasticsearch_rails'
require_relative '../../mock_helpers/searchkick'
require_relative '../../mock_helpers/meilisearch'
require_relative '../../mock_helpers/arel'
require_relative '../../mock_helpers/collection'
require_relative '../../mock_helpers/app'

def test_items_vars_params(items, vars, params)
  app = MockApp.new params: params
  _(app.params.to_options).must_equal params
  [[:pagy_elasticsearch_rails, MockElasticsearchRails::Model],
   [:pagy_searchkick, MockSearchkick::Model]].each do |meth, mod|
    pagy, records = app.send meth, mod.pagy_search('a').records, vars
    _(pagy.items).must_equal items
    _(records.size).must_equal items
  end
  [[:pagy_meilisearch, MockMeilisearch::Model]].each do |meth, mod|
    pagy, records = app.send meth, mod.pagy_search('a'), vars
    _(pagy.items).must_equal items
    _(records.size).must_equal items
  end
  %i[pagy pagy_countless pagy_array pagy_arel].each do |meth|
    pagy, records = app.send meth, @collection, vars
    _(pagy.items).must_equal items
    _(records.size).must_equal items
  end
end

describe 'pagy/extras/items' do
  let(:app) { MockApp.new }
  describe "controller_methods" do
    before do
      @collection = MockCollection.new
    end
    it 'uses the defaults' do
      vars = {}
      app = MockApp.new
      %i[pagy_elasticsearch_rails_get_vars pagy_searchkick_get_vars pagy_meilisearch_get_vars].each do |method|
        merged = app.send method, nil, vars
        _(merged[:items]).must_equal 20
      end
      %i[pagy_get_vars pagy_array_get_vars pagy_arel_get_vars].each do |method|
        merged = app.send method, @collection, {}
        _(merged[:items]).must_be_nil
      end
    end
    it 'uses the vars' do
      items  = 15
      vars   = { items: items } # force items
      params = { a: "a", page: 3, items: 12 }
      test_items_vars_params(items, vars, params)
    end
    it 'uses the params' do
      items  = 12
      vars   = {}
      params = { a: "a", page: 3, items: items }
      test_items_vars_params(items, vars, params)
    end
    it 'uses the params without page' do
      items  = 12
      vars   = {}
      params = { a: "a", items: items }
      test_items_vars_params(items, vars, params)
    end
    it 'overrides the params' do
      items  = 21
      vars   = { items: items }
      params = { a: "a", page: 3, items: 12 }
      test_items_vars_params(items, vars, params)
    end
    it 'uses the max_items default' do
      items  = 100
      vars   = {}
      params = { a: "a", page: 3, items: 120 }
      test_items_vars_params(items, vars, params)
    end
    it 'doesn\'t limit the items from vars' do
      items  = 1000
      vars   = { max_items: nil }
      params = { a: "a", items: 1000 }
      test_items_vars_params(items, vars, params)
    end
    it 'doesn\'t limit the items from default' do
      items  = 1000
      vars   = {}
      params = { a: "a", items: items }

      Pagy::DEFAULT[:max_items] = nil
      test_items_vars_params(items, vars, params)
      Pagy::DEFAULT[:max_items] = 100 # reset default
    end
    it 'uses items_param from vars' do
      items  = 14
      vars   = { items_param: :custom }
      params = { a: "a", page: 3, items_param: :custom, custom: items }
      test_items_vars_params(items, vars, params)
    end
    it 'uses items_param from default' do
      items  = 15
      vars   = {}
      params = { a: "a", page: 3, custom: 15 }

      Pagy::DEFAULT[:items_param] = :custom
      test_items_vars_params(items, vars, params)
      Pagy::DEFAULT[:items_param] = :items # reset default
    end
    it 'doesn\'t use the :items_extra' do
      items  = 20
      vars   = { items_extra: false }
      params = { a: "a", page: 3, items: 35 }

      Pagy::DEFAULT[:items_extra] = false
      test_items_vars_params(items, vars, params)
      Pagy::DEFAULT[:items_extra] = true # reset default
    end
  end

  describe 'view_methods' do
    describe '#pagy_url_for' do
      it 'renders basic url' do
        pagy = Pagy.new count: 1000, page: 3
        _(app.pagy_url_for(pagy, 5)).must_equal '/foo?page=5&items=20'
      end
      it 'renders basic url and items var' do
        pagy = Pagy.new count: 1000, page: 3, items: 50
        _(app.pagy_url_for(pagy, 5)).must_equal '/foo?page=5&items=50'
      end
      it 'renders url with items_param' do
        pagy = Pagy.new count: 1000, page: 3, items_param: :custom
        _(app.pagy_url_for(pagy, 5)).must_equal '/foo?page=5&custom=20'
      end
      it 'renders url with fragment' do
        pagy = Pagy.new count: 1000, page: 3
        _(app.pagy_url_for(pagy, 6, fragment: '#fragment')).must_equal '/foo?page=6&items=20#fragment'
      end
      it 'renders url with params and fragment' do
        pagy = Pagy.new count: 1000, page: 3, params: { a: 3, b: 4 }, items: 40
        _(app.pagy_url_for(pagy, 5, fragment: '#fragment')).must_equal "/foo?page=5&a=3&b=4&items=40#fragment"
      end
    end
    it 'renders items selector' do
      pagy = Pagy.new count: 1000, page: 3
      _(app.pagy_items_selector_js(pagy)).must_rematch :selector_1
      _(app.pagy_items_selector_js(pagy, id: 'test-id', item_name: 'products')).must_rematch :selector_2
      pagy = Pagy.new count: 1000, page: 3, items_extra: false
      _(app.pagy_items_selector_js(pagy, id: 'test-id')).must_equal ''
    end
  end
end
