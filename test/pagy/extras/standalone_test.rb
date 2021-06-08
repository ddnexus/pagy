# frozen_string_literal: true

require_relative '../../test_helper'
require 'pagy/extras/standalone'

class EmptyController
  include Pagy::Backend
end
class FilledController
  def params
    {a: 'a', b: 'b'}
  end
  include Pagy::Backend
end

describe 'pagy/extras/standalone' do
  require_relative '../../mock_helpers/view'
  let(:view) { MockView.new }

  describe 'defines #params if missing' do
    it 'defines a dummy #params' do
      _(EmptyController.new.params).must_equal({})
    end
    it 'does not define a dummy #params' do
      _(FilledController.new.params).must_equal({a: 'a', b: 'b'})
    end
  end

  describe '#pagy_url_for' do

    it 'renders basic url' do
      pagy = Pagy.new count: 1000, page: 3
      _(view.pagy_url_for(pagy, 5)).must_equal '/foo?page=5'
      _(view.pagy_url_for(pagy, 5, absolute: true)).must_equal 'http://example.com:3000/foo?page=5'
      pagy = Pagy.new count: 1000, page: 3, url: 'http://www.pagy-standalone.com/subdir'
      _(view.pagy_url_for(pagy, 5)).must_equal 'http://www.pagy-standalone.com/subdir?page=5'
      _(view.pagy_url_for(pagy, 5, absolute: true)).must_equal 'http://www.pagy-standalone.com/subdir?page=5'
      pagy = Pagy.new count: 1000, page: 3, url: ''
      _(view.pagy_url_for(pagy, 5)).must_equal '?page=5'
      _(view.pagy_url_for(pagy, 5, absolute: true)).must_equal '?page=5'
    end

    it 'renders url with params' do
      pagy = Pagy.new count: 1000, page: 3, params: {a: 3, b: 4}
      _(view.pagy_url_for(pagy, 5)).must_equal '/foo?page=5&a=3&b=4'
      _(view.pagy_url_for(pagy, 5, absolute: true)).must_equal 'http://example.com:3000/foo?page=5&a=3&b=4'
      pagy = Pagy.new count: 1000, page: 3, params: {a: 3, b: 4}, url: 'http://www.pagy-standalone.com/subdir'
      _(view.pagy_url_for(pagy, 5)).must_equal "http://www.pagy-standalone.com/subdir?a=3&b=4&page=5"
      _(view.pagy_url_for(pagy, 5, absolute: true)).must_equal "http://www.pagy-standalone.com/subdir?a=3&b=4&page=5"
      pagy = Pagy.new count: 1000, page: 3, params: {a: 3, b: 4}, url: ''
      _(view.pagy_url_for(pagy, 5)).must_equal "?a=3&b=4&page=5"
      _(view.pagy_url_for(pagy, 5, absolute: true)).must_equal "?a=3&b=4&page=5"
    end
    it 'renders url with fragment' do
      pagy = Pagy.new count: 1000, page: 3, fragment: '#fragment'
      _(view.pagy_url_for(pagy, 6)).must_equal '/foo?page=6#fragment'
      _(view.pagy_url_for(pagy, 6, absolute: true)).must_equal 'http://example.com:3000/foo?page=6#fragment'
      pagy = Pagy.new count: 1000, page: 3, fragment: '#fragment', url: 'http://www.pagy-standalone.com/subdir'
      _(view.pagy_url_for(pagy, 6)).must_equal 'http://www.pagy-standalone.com/subdir?page=6#fragment'
      _(view.pagy_url_for(pagy, 6, absolute: true)).must_equal 'http://www.pagy-standalone.com/subdir?page=6#fragment'
      pagy = Pagy.new count: 1000, page: 3, fragment: '#fragment', url: ''
      _(view.pagy_url_for(pagy, 6)).must_equal '?page=6#fragment'
      _(view.pagy_url_for(pagy, 6, absolute: true)).must_equal '?page=6#fragment'
    end
    it 'renders url with params and fragment' do
      pagy = Pagy.new count: 1000, page: 3, params: {a: 3, b: 4}, fragment: '#fragment'
      _(view.pagy_url_for(pagy, 5)).must_equal '/foo?page=5&a=3&b=4#fragment'
      _(view.pagy_url_for(pagy, 5, absolute: true)).must_equal 'http://example.com:3000/foo?page=5&a=3&b=4#fragment'
      pagy = Pagy.new count: 1000, page: 3, params: {a: [1,2,3]}, fragment: '#fragment', url: 'http://www.pagy-standalone.com/subdir'
      _(view.pagy_url_for(pagy, 5)).must_equal "http://www.pagy-standalone.com/subdir?a[]=1&a[]=2&a[]=3&page=5#fragment"
      _(view.pagy_url_for(pagy, 5, absolute: true)).must_equal "http://www.pagy-standalone.com/subdir?a[]=1&a[]=2&a[]=3&page=5#fragment"
      pagy = Pagy.new count: 1000, page: 3, params: {a: nil}, fragment: '#fragment', url: ''
      _(view.pagy_url_for(pagy, 5)).must_equal "?a&page=5#fragment"
      _(view.pagy_url_for(pagy, 5, absolute: true)).must_equal "?a&page=5#fragment"
    end
  end
end
