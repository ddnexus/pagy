# frozen_string_literal: true

require_relative '../../test_helper'
require 'pagy/extras/standalone'
require 'pagy/extras/items'

require_relative '../../mock_helpers/view'

describe 'pagy/extras/standalone_items' do
  let(:view) { MockView.new }

  describe '#pagy_url_for' do
    it 'renders url with params and fragment' do
      pagy = Pagy.new count: 1000, page: 3, params: { a: 3, b: 4 }, fragment: '#fragment'
      _(view.pagy_url_for(pagy, 5)).must_equal "/foo?page=5&a=3&b=4&items=20#fragment"
      _(view.pagy_url_for(pagy, 5, absolute: true)).must_equal "http://example.com:3000/foo?page=5&a=3&b=4&items=20#fragment"
      pagy = Pagy.new count: 1000, page: 3, params: { a: [1, 2, 3] }, fragment: '#fragment', url: 'http://www.pagy-standalone.com/subdir'
      _(view.pagy_url_for(pagy, 5)).must_equal "http://www.pagy-standalone.com/subdir?a[]=1&a[]=2&a[]=3&page=5&items=20#fragment"
      _(view.pagy_url_for(pagy, 5, absolute: true)).must_equal "http://www.pagy-standalone.com/subdir?a[]=1&a[]=2&a[]=3&page=5&items=20#fragment"
      pagy = Pagy.new count: 1000, page: 3, params: { a: nil }, fragment: '#fragment', url: ''
      _(view.pagy_url_for(pagy, 5)).must_equal "?a&page=5&items=20#fragment"
      _(view.pagy_url_for(pagy, 5, absolute: true)).must_equal "?a&page=5&items=20#fragment"
    end
  end
end
