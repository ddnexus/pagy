# frozen_string_literal: true

require_relative '../test_helper'
require_relative '../mock_helpers/app'

describe 'pagy/url_helpers' do
  let(:app) { MockApp.new }

  describe '#pagy_page_url' do
    it 'renders basic url' do
      pagy = Pagy.new count: 1000, page: 3
      _(app.pagy_page_url(pagy, 5)).must_equal '/foo?page=5'
      _(app.pagy_page_url(pagy, 5, absolute: true)).must_equal 'http://example.com:3000/foo?page=5'
    end
    it 'renders url with params' do
      pagy = Pagy.new count: 1000, page: 3, params: { a: 3, b: 4 }
      _(app.pagy_page_url(pagy, 5)).must_equal "/foo?page=5&a=3&b=4"
      _(app.pagy_page_url(pagy, 5, absolute: true)).must_equal "http://example.com:3000/foo?page=5&a=3&b=4"
    end
    it 'renders url with fragment' do
      pagy = Pagy.new count: 1000, page: 3
      _(app.pagy_page_url(pagy, 6, fragment: '#fragment')).must_equal '/foo?page=6#fragment'
      _(app.pagy_page_url(pagy, 6, absolute: true, fragment: '#fragment')).must_equal 'http://example.com:3000/foo?page=6#fragment'
    end
    it 'renders url with params and fragment' do
      pagy = Pagy.new count: 1000, page: 3, params: { a: 3, b: 4 }
      _(app.pagy_page_url(pagy, 5, fragment: '#fragment')).must_equal "/foo?page=5&a=3&b=4#fragment"
      _(app.pagy_page_url(pagy, 5, absolute: true, fragment: '#fragment')).must_equal "http://example.com:3000/foo?page=5&a=3&b=4#fragment"
    end
    it 'renders url with overridden path' do
      pagy = Pagy.new count: 1000, page: 3, request_path: '/bar'
      _(app.pagy_page_url(pagy, 5)).must_equal '/bar?page=5'
    end
  end

  describe '#pagy_set_query_params' do
    it 'overrides params' do
      app  = MockApp.new(params: { delete_me: 'delete_me', a: 5 })
      pagy = Pagy.new(count: 1000,
                      page: 3,
                      params: lambda do |params|
                        params.delete('delete_me')
                        params.merge('b' => 4, 'add_me' => 'add_me')
                      end)
      _(app.pagy_page_url(pagy, 5, fragment: '#fragment')).must_equal "/foo?a=5&page=5&b=4&add_me=add_me#fragment"
    end
  end

  describe 'pagy/extras/standalone/query_utils' do
    it 'handles nested hashes' do
      _(Pagy::UrlHelpers::QueryUtils.build_nested_query({ a: { b: 2 } })).must_equal "a%5Bb%5D=2" # "a[b]=2"
      _(Pagy::UrlHelpers::QueryUtils.build_nested_query({ a: { b: { c: 3 } } })).must_equal "a%5Bb%5D%5Bc%5D=3" # "a[b][c]=3"
    end
    it 'raises ArgumentError for wrong params' do
      _ { Pagy::UrlHelpers::QueryUtils.build_nested_query('just a string') }.must_raise ArgumentError
    end
  end
end
