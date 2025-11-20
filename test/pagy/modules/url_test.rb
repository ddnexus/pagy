# frozen_string_literal: true

require_relative '../../test_helper'
require_relative '../../mock_helpers/app'
require_relative '../../mock_helpers/collection'

describe 'pagy/helpers/url' do
  let(:app) { MockApp.new }

  before do
    @collection = MockCollection.new
  end

  describe 'compose_page_url' do
    it 'renders basic url' do
      pagy, = app.send(:pagy, :offset, @collection, count: 1000, page: 3)

      _(pagy.send(:compose_page_url, 5)).must_equal '/foo?page=5'
      _(pagy.send(:compose_page_url, 5, absolute: true)).must_equal 'http://example.com:3000/foo?page=5'
    end
    it 'renders url with params' do
      pagy, = app.send(:pagy, :offset, @collection, count: 1000, page: 3, querify: ->(qh) { qh.merge!(a: 3, b: 4) })

      _(pagy.send(:compose_page_url, 5)).must_equal "/foo?page=5&a=3&b=4"
      _(pagy.send(:compose_page_url, 5, absolute: true)).must_equal "http://example.com:3000/foo?page=5&a=3&b=4"
    end
    it 'renders url with fragment' do
      pagy, = app.send(:pagy, :offset, @collection, count: 1000, page: 3)

      _(pagy.send(:compose_page_url, 6, fragment: '#fragment')).must_equal '/foo?page=6#fragment'
      _(pagy.send(:compose_page_url, 6, absolute: true, fragment: '#fragment')).must_equal 'http://example.com:3000/foo?page=6#fragment'
    end
    it 'renders url with params and fragment' do
      pagy, = app.send(:pagy, :offset, @collection, count: 1000, page: 3, querify: ->(qh) { qh.merge!(a: 3, b: 4) })

      _(pagy.send(:compose_page_url, 5, fragment: '#fragment')).must_equal "/foo?page=5&a=3&b=4#fragment"
      _(pagy.send(:compose_page_url, 5, absolute: true, fragment: '#fragment')).must_equal "http://example.com:3000/foo?page=5&a=3&b=4#fragment"
    end
    it 'renders url with overridden path' do
      pagy, = app.send(:pagy, :offset, @collection, count: 1000, page: 3, path: '/bar')

      _(pagy.send(:compose_page_url, 5)).must_equal '/bar?page=5'
    end
    it 'renders url with overridden request' do
      pagy, = app.send(:pagy, :offset, @collection,
                       count:   1000,
                       page:    3,
                       request: { base_url: 'http://example.com',
                                  path:     '/path',
                                  params:   { 'a' => '1', 'b' => '2' } })

      _(pagy.send(:compose_page_url, 5, absolute: true)).must_equal 'http://example.com/path?a=1&b=2&page=5'
    end
  end

  describe 'process pagy_params' do
    it 'overrides params' do
      app   = MockApp.new(params: { delete_me: 'delete_me', a: 5 })
      pagy, = app.send(:pagy, :offset, @collection,
                       count:  1000,
                       page:    3,
                       querify: lambda do |params|
                         params.delete('delete_me')
                         params.merge!('b' => 4, 'add_me' => 'add_me')
                       end)

      _(pagy.send(:compose_page_url, 5, fragment: '#fragment')).must_equal "/foo?a=5&page=5&b=4&add_me=add_me#fragment"
    end
  end

  describe 'pagy query_utils' do
    it 'handles hashes and arrays' do
      _(Pagy::Linkable::QueryUtils.build_nested_query({ a: { b: 2 } })).must_equal "a%5Bb%5D=2" # "a[b]=2"
      _(Pagy::Linkable::QueryUtils.build_nested_query({ a: { b: { c: 3 } } })).must_equal "a%5Bb%5D%5Bc%5D=3" # "a[b][c]=3"
      _(Pagy::Linkable::QueryUtils.build_nested_query({ a: [1, 2, 3] })).must_equal "a%5B%5D=1&a%5B%5D=2&a%5B%5D=3" # "a[]=1&a[]=2&a[]=3
    end
    # We pass symbol key just for easy testing but the build_nested_query expects string keys
    it 'handles unescaped params' do
      _(Pagy::Linkable::QueryUtils.build_nested_query({ b: { 'c' => Pagy::RawQueryValue.new(' A ') } })).must_equal "b%5Bc%5D= A " # "a[b][c]=3"
      _(Pagy::Linkable::QueryUtils.build_nested_query({ a: { b: { 'c' => Pagy::RawQueryValue.new(' A ') } } })).must_equal "a%5Bb%5D%5Bc%5D= A " # "a[b][c]=3"
    end
    it "handles nil and '' values" do
      _("res: #{Pagy::Linkable::QueryUtils.build_nested_query({ b: nil })}").must_equal "res: b"
      _("res: #{Pagy::Linkable::QueryUtils.build_nested_query({ a: { b: { c: nil } } })}").must_equal "res: a%5Bb%5D%5Bc%5D"
      _(Pagy::Linkable::QueryUtils.build_nested_query({ b: '' })).must_equal "b="
      _(Pagy::Linkable::QueryUtils.build_nested_query({ a: { b: { c: '' } } })).must_equal "a%5Bb%5D%5Bc%5D=" # "a[b][c]=''"
    end
    it 'raises ArgumentError for wrong params' do
      _ { Pagy::Linkable::QueryUtils.build_nested_query('just a string') }.must_raise ArgumentError
    end
  end
end
