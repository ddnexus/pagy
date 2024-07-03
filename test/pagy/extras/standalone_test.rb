# frozen_string_literal: true

require_relative '../../test_helper'
require 'pagy/extras/standalone'

require_relative '../../mock_helpers/app'

class EmptyController
  include Pagy::Backend
end

class FilledController
  def params
    { a: 'a', b: 'b' }
  end
  include Pagy::Backend
end

describe 'pagy/extras/standalone' do
  let(:app) { MockApp.new }

  describe 'defines #params if missing' do
    it 'defines a dummy #params' do
      _(EmptyController.new.params).must_equal({})
    end
    it 'does not define a dummy #params' do
      _(FilledController.new.params).must_equal({ a: 'a', b: 'b' })
    end
  end

  describe '#pagy_url_for' do
    it 'renders basic url' do
      pagy = Pagy.new count: 1000, page: 3
      _(app.pagy_url_for(pagy, 5)).must_equal '/foo?page=5'
      _(app.pagy_url_for(pagy, 5, absolute: true)).must_equal 'http://example.com:3000/foo?page=5'
      pagy = Pagy.new count: 1000, page: 3, url: 'http://www.pagy-standalone.com/subdir'
      _(app.pagy_url_for(pagy, 5)).must_equal 'http://www.pagy-standalone.com/subdir?page=5'
      _(app.pagy_url_for(pagy, 5, absolute: true)).must_equal 'http://www.pagy-standalone.com/subdir?page=5'
      pagy = Pagy.new count: 1000, page: 3, url: ''
      _(app.pagy_url_for(pagy, 5)).must_equal '?page=5'
      _(app.pagy_url_for(pagy, 5, absolute: true)).must_equal '?page=5'
    end

    it 'renders url with params' do
      pagy = Pagy.new count: 1000, page: 3, params: { a: 3, b: 4 }
      _(app.pagy_url_for(pagy, 5)).must_equal '/foo?page=5&a=3&b=4'
      _(app.pagy_url_for(pagy, 5, absolute: true)).must_equal 'http://example.com:3000/foo?page=5&a=3&b=4'
      pagy = Pagy.new count: 1000, page: 3, params: { a: 3, b: 4 }, url: 'http://www.pagy-standalone.com/subdir'
      _(app.pagy_url_for(pagy, 5)).must_equal "http://www.pagy-standalone.com/subdir?a=3&b=4&page=5"
      _(app.pagy_url_for(pagy, 5, absolute: true)).must_equal "http://www.pagy-standalone.com/subdir?a=3&b=4&page=5"
      pagy = Pagy.new count: 1000, page: 3, params: { a: 3, b: 4 }, url: ''
      _(app.pagy_url_for(pagy, 5)).must_equal "?a=3&b=4&page=5"
      _(app.pagy_url_for(pagy, 5, absolute: true)).must_equal "?a=3&b=4&page=5"
    end
    it 'renders url with fragment' do
      pagy = Pagy.new count: 1000, page: 3
      _(app.pagy_url_for(pagy, 6, fragment: '#fragment')).must_equal '/foo?page=6#fragment'
      _(app.pagy_url_for(pagy, 6, absolute: true, fragment: '#fragment')).must_equal 'http://example.com:3000/foo?page=6#fragment'
      pagy = Pagy.new count: 1000, page: 3, url: 'http://www.pagy-standalone.com/subdir'
      _(app.pagy_url_for(pagy, 6, fragment: '#fragment')).must_equal 'http://www.pagy-standalone.com/subdir?page=6#fragment'
      _(app.pagy_url_for(pagy, 6, absolute: true, fragment: '#fragment')).must_equal 'http://www.pagy-standalone.com/subdir?page=6#fragment'
      pagy = Pagy.new count: 1000, page: 3, url: ''
      _(app.pagy_url_for(pagy, 6, fragment: '#fragment')).must_equal '?page=6#fragment'
      _(app.pagy_url_for(pagy, 6, absolute: true, fragment: '#fragment')).must_equal '?page=6#fragment'
    end
    it 'renders url with params and fragment' do
      pagy = Pagy.new count: 1000, page: 3, params: { a: 3, b: 4 }
      _(app.pagy_url_for(pagy, 5, fragment: '#fragment')).must_equal '/foo?page=5&a=3&b=4#fragment'
      _(app.pagy_url_for(pagy, 5, absolute: true, fragment: '#fragment')).must_equal 'http://example.com:3000/foo?page=5&a=3&b=4#fragment'
      pagy = Pagy.new count: 1000, page: 3, params: { a: [1, 2, 3] }, url: 'http://www.pagy-standalone.com/subdir'
      _(app.pagy_url_for(pagy, 5, fragment: '#fragment')).must_equal "http://www.pagy-standalone.com/subdir?a%5B%5D=1&a%5B%5D=2&a%5B%5D=3&page=5#fragment"
      _(app.pagy_url_for(pagy, 5, absolute: true, fragment: '#fragment')).must_equal "http://www.pagy-standalone.com/subdir?a%5B%5D=1&a%5B%5D=2&a%5B%5D=3&page=5#fragment"
      pagy = Pagy.new count: 1000, page: 3, params: { a: nil }, url: ''
      _(app.pagy_url_for(pagy, 5, fragment: '#fragment')).must_equal "?a&page=5#fragment"
      _(app.pagy_url_for(pagy, 5, absolute: true, fragment: '#fragment')).must_equal "?a&page=5#fragment"
    end
    it 'renders url with params lambda and fragment' do
      pagy = Pagy.new count: 1000, page: 3, params: ->(p) { p.merge(a: 3, b: 4) }
      _(app.pagy_url_for(pagy, 5, fragment: '#fragment')).must_equal '/foo?page=5&a=3&b=4#fragment'
      _(app.pagy_url_for(pagy, 5, absolute: true, fragment: '#fragment')).must_equal 'http://example.com:3000/foo?page=5&a=3&b=4#fragment'
      pagy = Pagy.new count: 1000, page: 3, params: ->(p) { p.merge(a: [1, 2, 3]) }, url: 'http://www.pagy-standalone.com/subdir'
      _(app.pagy_url_for(pagy, 5, fragment: '#fragment')).must_equal "http://www.pagy-standalone.com/subdir?page=5&a%5B%5D=1&a%5B%5D=2&a%5B%5D=3#fragment"
      _(app.pagy_url_for(pagy, 5, absolute: true, fragment: '#fragment')).must_equal "http://www.pagy-standalone.com/subdir?page=5&a%5B%5D=1&a%5B%5D=2&a%5B%5D=3#fragment"
      pagy = Pagy.new count: 1000, page: 3, params: ->(p) { p.merge(a: nil) }, url: ''
      _(app.pagy_url_for(pagy, 5, fragment: '#fragment')).must_equal "?page=5&a#fragment"
      _(app.pagy_url_for(pagy, 5, absolute: true, fragment: '#fragment')).must_equal "?page=5&a#fragment"
    end
  end
end

describe 'pagy/extras/standalone/query_utils' do
  it 'handles nested hashes' do
    _(Pagy::StandaloneExtra::QueryUtils.build_nested_query({ a: { b: 2 } })).must_equal "a%5Bb%5D=2" # "a[b]=2"
    _(Pagy::StandaloneExtra::QueryUtils.build_nested_query({ a: { b: { c: 3 } } })).must_equal "a%5Bb%5D%5Bc%5D=3" # "a[b][c]=3"
  end
  it 'raises for wrong params' do
    _ { Pagy::StandaloneExtra::QueryUtils.build_nested_query('just a string') }.must_raise ArgumentError
  end
end
