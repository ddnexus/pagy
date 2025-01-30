# frozen_string_literal: true

require_relative '../../test_helper'
require_relative '../../mock_helpers/elasticsearch_rails'
require_relative '../../mock_helpers/searchkick'
require_relative '../../mock_helpers/meilisearch'
require_relative '../../mock_helpers/arel'
require_relative '../../mock_helpers/collection'
require_relative '../../mock_helpers/app'

def test_limit_opts_params(limit, opts, params)
  app = MockApp.new params: params
  _(app.params.to_param).must_equal params.to_param
  [[:pagy_elasticsearch_rails, MockElasticsearchRails::Model],
   [:pagy_searchkick, MockSearchkick::Model]].each do |meth, mod|
    pagy, records = app.send(meth, mod.pagy_search('a').records, **opts)
    _(pagy.limit).must_equal limit
    _(records.size).must_equal limit
  end
  [[:pagy_meilisearch, MockMeilisearch::Model]].each do |meth, mod|
    pagy, records = app.send(meth, mod.pagy_search('a'), **opts)
    _(pagy.limit).must_equal limit
    _(records.size).must_equal limit
  end
  %i[pagy_offset pagy_array pagy_arel].each do |meth|
    pagy, records = app.send(meth, @collection, **opts)
    _(pagy.limit).must_equal limit
    _(records.size).must_equal limit
  end
end

describe 'requestable_limit' do
  let(:app) { MockApp.new }
  describe "controller_methods" do
    before do
      @collection = MockCollection.new
    end
    it 'uses the opts' do
      limit  = 15
      opts   = { limit: limit } # force limit
      params = { a: "a", page: 3, limit: 12 }
      test_limit_opts_params(limit, opts, params)
    end
    it 'uses the params' do
      limit  = 12
      opts   = { requestable_limit: 100 }
      params = { a: "a", page: 3, limit: limit }
      test_limit_opts_params(limit, opts, params)
    end
    it 'uses the params without page' do
      limit  = 12
      opts   = { requestable_limit: 100 }
      params = { a: "a", limit: limit }
      test_limit_opts_params(limit, opts, params)
    end
    it 'overrides the params' do
      limit  = 21
      opts   = { limit: limit }
      params = { a: "a", page: 3, limit: 12 }
      test_limit_opts_params(limit, opts, params)
    end
    it 'uses limit_sym from opts' do
      limit  = 14
      opts   = { requestable_limit: 100, limit_sym: :custom }
      params = { a: "a", page: 3, limit_sym: :custom, custom: limit }
      test_limit_opts_params(limit, opts, params)
    end
    it 'uses limit_sym from default' do
      limit  = 15
      opts   = { limit_sym: :custom, requestable_limit: 100 }
      params = { a: "a", page: 3, custom: 15 }

      test_limit_opts_params(limit, opts, params)
    end
    it 'doesn\'t use the :requestable_limit' do
      limit  = 20
      opts   = {}
      params = { a: "a", page: 3, limit: 35 }

      test_limit_opts_params(limit, opts, params)
    end
  end

  describe 'view_methods' do
    describe '#pagy_page_url' do
      it 'renders basic url' do
        pagy = Pagy::Offset.new(count: 1000, page: 3, requestable_limit: 100)
        _(app.pagy_page_url(pagy, 5)).must_equal '/foo?page=5&limit=20'
      end
      it 'renders basic url and limit var' do
        pagy = Pagy::Offset.new(count: 1000, page: 3, limit: 50, requestable_limit: 100)
        _(app.pagy_page_url(pagy, 5)).must_equal '/foo?page=5&limit=50'
      end
      it 'renders url with limit_sym' do
        pagy = Pagy::Offset.new(count: 1000, page: 3, limit_sym: :custom, requestable_limit: 100)
        _(app.pagy_page_url(pagy, 5)).must_equal '/foo?page=5&custom=20'
      end
      it 'renders url with fragment' do
        pagy = Pagy::Offset.new(count: 1000, page: 3, requestable_limit: 100)
        _(app.pagy_page_url(pagy, 6, fragment: '#fragment')).must_equal '/foo?page=6&limit=20#fragment'
      end
      it 'renders url with params and fragment' do
        pagy = Pagy::Offset.new(count: 1000, page: 3, params: { a: 3, b: 4 }, limit: 40, requestable_limit: 100)
        _(app.pagy_page_url(pagy, 5, fragment: '#fragment')).must_equal "/foo?page=5&limit=40&a=3&b=4#fragment"
      end
    end
    it 'renders or skips the output depending on requestable_limit' do
      pagy, = app.send(:pagy_offset, MockCollection.new, page: 3, requestable_limit: 100)
      _(app.pagy_limit_selector_js(pagy)).must_rematch :selector_1
      _(app.pagy_limit_selector_js(pagy, id: 'test-id', item_name: 'products')).must_rematch :selector_2
      pagy, = app.send(:pagy_offset, MockCollection.new, page: 3)
      _(app.pagy_limit_selector_js(pagy, id: 'test-id')).must_equal ''
    end
  end
end
