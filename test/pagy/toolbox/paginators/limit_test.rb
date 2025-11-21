# frozen_string_literal: true

require_relative '../../../test_helper'
require_relative '../../../mock_helpers/elasticsearch_rails'
require_relative '../../../mock_helpers/searchkick'
require_relative '../../../mock_helpers/meilisearch'
require_relative '../../../mock_helpers/collection'
require_relative '../../../mock_helpers/app'

def test_limit_options_params(limit, options, params)
  app = MockApp.new params: params

  _(app.params.to_param).must_equal params.to_param
  [[:elasticsearch_rails, MockElasticsearchRails::Model],
   [:searchkick, MockSearchkick::Model]].each do |paginator, mod|
    pagy, records = app.send(:pagy, paginator, mod.pagy_search('a').records, **options)

    _(pagy.limit).must_equal limit
    _(records.size).must_equal limit
  end
  [[:meilisearch, MockMeilisearch::Model]].each do |paginator, mod|
    pagy, records = app.send(:pagy, paginator, mod.pagy_search('a'), **options)

    _(pagy.limit).must_equal limit
    _(records.size).must_equal limit
  end
  %i[offset].each do |paginator|
    pagy, records = app.send(:pagy, paginator, @collection, **options)

    _(pagy.limit).must_equal limit
    _(records.size).must_equal limit
  end
end

describe 'client_max_limit' do
  let(:app) { MockApp.new }
  describe "controller_methods" do
    before do
      @collection = MockCollection.new
    end
    it 'uses the options' do
      limit  = 15
      options   = { limit: limit } # force limit
      params = { a: "a", page: 3, limit: 12 }
      test_limit_options_params(limit, options, params)
    end
    it 'uses the params' do
      limit  = 12
      options   = { client_max_limit: 100 }
      params = { a: "a", page: 3, limit: limit }
      test_limit_options_params(limit, options, params)
    end
    it 'uses the params without page' do
      limit  = 12
      options   = { client_max_limit: 100 }
      params = { a: "a", limit: limit }
      test_limit_options_params(limit, options, params)
    end
    it 'overrides the params' do
      limit  = 21
      options   = { limit: limit }
      params = { a: "a", page: 3, limit: 12 }
      test_limit_options_params(limit, options, params)
    end
    it 'uses limit_key from options' do
      limit  = 14
      options   = { client_max_limit: 100, limit_key: 'custom' }
      params = { a: "a", page: 3, limit_key: 'custom', custom: limit }
      test_limit_options_params(limit, options, params)
    end
    it 'uses limit_key from default' do
      limit  = 15
      options   = { limit_key: 'custom', client_max_limit: 100 }
      params = { a: "a", page: 3, custom: 15 }

      test_limit_options_params(limit, options, params)
    end
    it 'doesn\'t use the :client_max_limit' do
      limit  = 20
      options   = {}
      params = { a: "a", page: 3, limit: 35 }

      test_limit_options_params(limit, options, params)
    end
  end

  describe 'view_methods' do
    describe 'compose_page_url' do
      let(:request) { MockApp.new.request }

      it 'renders basic url' do
        pagy = Pagy::Offset.new(count: 1000, page: 3, client_max_limit: 100)

        _(pagy.limit).must_equal 20
      end
      it 'renders basic url and limit var' do
        pagy = Pagy::Offset.new(count: 1000, page: 3, limit: 50, client_max_limit: 100)

        _(pagy.limit).must_equal 50
      end
      it 'renders url with limit_key' do
        pagy = Pagy::Offset.new(count: 1000, page: 3, limit_key: 'custom', client_max_limit: 100, request:)

        _(pagy.send(:compose_page_url, 5)).must_equal '/foo?page=5&custom=20'
      end
      it 'renders url with fragment' do
        pagy = Pagy::Offset.new(count: 1000, page: 3, client_max_limit: 100, request:)

        _(pagy.send(:compose_page_url, 6, fragment: '#fragment')).must_equal '/foo?page=6&limit=20#fragment'
      end
      it 'renders url with params and fragment' do
        pagy = Pagy::Offset.new(count: 1000, page: 3, querify: ->(qh) { qh.merge!('a' => 3, 'b' => 4) }, limit: 40, client_max_limit: 100, request:)

        _(pagy.send(:compose_page_url, 5, fragment: '#fragment')).must_equal "/foo?page=5&limit=40&a=3&b=4#fragment"
      end
    end
    it 'renders or skips the output depending on client_max_limit' do
      pagy, = app.send(:pagy, :offset, MockCollection.new, page: 3, client_max_limit: 100)
      _(pagy.limit_tag_js).must_rematch :selector_1
      _(pagy.limit_tag_js(id: 'test-id', item_name: 'products')).must_rematch :selector_2
      pagy, = app.send(:pagy, :offset, MockCollection.new, page: 3)

      _ { pagy.limit_tag_js(id: 'test-id') }.must_raise Pagy::OptionError
    end
  end
end
