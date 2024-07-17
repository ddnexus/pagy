# frozen_string_literal: true

require_relative '../../test_helper'

require 'pagy/extras/countless'
require 'pagy/extras/arel'
require 'pagy/extras/array'
require 'pagy/extras/limit'

require_relative '../../mock_helpers/elasticsearch_rails'
require_relative '../../mock_helpers/searchkick'
require_relative '../../mock_helpers/meilisearch'
require_relative '../../mock_helpers/arel'
require_relative '../../mock_helpers/collection'
require_relative '../../mock_helpers/app'

def test_limit_vars_params(limit, vars, params)
  app = MockApp.new params: params
  _(app.params.to_options).must_equal params
  [[:pagy_elasticsearch_rails, MockElasticsearchRails::Model],
   [:pagy_searchkick, MockSearchkick::Model]].each do |meth, mod|
    pagy, records = app.send(meth, mod.pagy_search('a').records, **vars)
    _(pagy.limit).must_equal limit
    _(records.size).must_equal limit
  end
  [[:pagy_meilisearch, MockMeilisearch::Model]].each do |meth, mod|
    pagy, records = app.send(meth, mod.pagy_search('a'), **vars)
    _(pagy.limit).must_equal limit
    _(records.size).must_equal limit
  end
  %i[pagy pagy_countless pagy_array pagy_arel].each do |meth|
    pagy, records = app.send(meth, @collection, **vars)
    _(pagy.limit).must_equal limit
    _(records.size).must_equal limit
  end
end

describe 'pagy/extras/limit' do
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
        _(merged[:limit]).must_equal 20
      end
      %i[pagy_get_vars pagy_array_get_vars pagy_arel_get_vars].each do |method|
        merged = app.send method, @collection, {}
        _(merged[:limit]).must_be_nil
      end
    end
    it 'uses the vars' do
      limit  = 15
      vars   = { limit: limit } # force limit
      params = { a: "a", page: 3, limit: 12 }
      test_limit_vars_params(limit, vars, params)
    end
    it 'uses the params' do
      limit  = 12
      vars   = {}
      params = { a: "a", page: 3, limit: limit }
      test_limit_vars_params(limit, vars, params)
    end
    it 'uses the params without page' do
      limit  = 12
      vars   = {}
      params = { a: "a", limit: limit }
      test_limit_vars_params(limit, vars, params)
    end
    it 'overrides the params' do
      limit  = 21
      vars   = { limit: limit }
      params = { a: "a", page: 3, limit: 12 }
      test_limit_vars_params(limit, vars, params)
    end
    it 'uses the max_limit default' do
      limit  = 100
      vars   = {}
      params = { a: "a", page: 3, limit: 120 }
      test_limit_vars_params(limit, vars, params)
    end
    it 'doesn\'t limit from vars' do
      limit  = 1000
      vars   = { max_limit: nil }
      params = { a: "a", limit: 1000 }
      test_limit_vars_params(limit, vars, params)
    end
    it 'doesn\'t limit from default' do
      limit  = 1000
      vars   = {}
      params = { a: "a", limit: limit }

      Pagy::DEFAULT[:max_limit] = nil
      test_limit_vars_params(limit, vars, params)
      Pagy::DEFAULT[:max_limit] = 100 # reset default
    end
    it 'uses limit_param from vars' do
      limit  = 14
      vars   = { limit_param: :custom }
      params = { a: "a", page: 3, limit_param: :custom, custom: limit }
      test_limit_vars_params(limit, vars, params)
    end
    it 'uses limit_param from default' do
      limit  = 15
      vars   = {}
      params = { a: "a", page: 3, custom: 15 }

      Pagy::DEFAULT[:limit_param] = :custom
      test_limit_vars_params(limit, vars, params)
      Pagy::DEFAULT[:limit_param] = :limit # reset default
    end
    it 'doesn\'t use the :limit_extra' do
      limit  = 20
      vars   = { limit_extra: false }
      params = { a: "a", page: 3, limit: 35 }

      Pagy::DEFAULT[:limit_extra] = false
      test_limit_vars_params(limit, vars, params)
      Pagy::DEFAULT[:limit_extra] = true # reset default
    end
  end

  describe 'view_methods' do
    describe '#pagy_url_for' do
      it 'renders basic url' do
        pagy = Pagy.new count: 1000, page: 3
        _(app.pagy_url_for(pagy, 5)).must_equal '/foo?page=5&limit=20'
      end
      it 'renders basic url and limit var' do
        pagy = Pagy.new count: 1000, page: 3, limit: 50
        _(app.pagy_url_for(pagy, 5)).must_equal '/foo?page=5&limit=50'
      end
      it 'renders url with limit_param' do
        pagy = Pagy.new count: 1000, page: 3, limit_param: :custom
        _(app.pagy_url_for(pagy, 5)).must_equal '/foo?page=5&custom=20'
      end
      it 'renders url with fragment' do
        pagy = Pagy.new count: 1000, page: 3
        _(app.pagy_url_for(pagy, 6, fragment: '#fragment')).must_equal '/foo?page=6&limit=20#fragment'
      end
      it 'renders url with params and fragment' do
        pagy = Pagy.new count: 1000, page: 3, params: { a: 3, b: 4 }, limit: 40
        _(app.pagy_url_for(pagy, 5, fragment: '#fragment')).must_equal "/foo?page=5&a=3&b=4&limit=40#fragment"
      end
    end
    it 'renders limit selector' do
      pagy = Pagy.new count: 1000, page: 3
      _(app.pagy_limit_selector_js(pagy)).must_rematch :selector_1
      _(app.pagy_limit_selector_js(pagy, id: 'test-id', item_name: 'products')).must_rematch :selector_2
      pagy = Pagy.new count: 1000, page: 3, limit_extra: false
      _(app.pagy_limit_selector_js(pagy, id: 'test-id')).must_equal ''
    end
  end
end
