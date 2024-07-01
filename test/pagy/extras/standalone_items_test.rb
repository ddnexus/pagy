# frozen_string_literal: true

require_relative '../../test_helper'
require 'pagy/extras/standalone'
require 'pagy/extras/items'

require_relative '../../mock_helpers/app'

describe 'pagy/extras/standalone_items' do
  let(:app) { MockApp.new }

  describe '#pagy_url_for' do
    it 'renders url with params and fragment' do
      pagy = Pagy.new count: 1000, page: 3, params: { a: 3, b: 4 }
      _(app.pagy_url_for(pagy, 5, fragment: '#fragment')).must_equal "/foo?page=5&a=3&b=4&items=20#fragment"
      _(app.pagy_url_for(pagy, 5, absolute: true, fragment: '#fragment')).must_equal "http://example.com:3000/foo?page=5&a=3&b=4&items=20#fragment"
      pagy = Pagy.new count: 1000, page: 3, params: { a: [1, 2, 3] }, url: 'http://www.pagy-standalone.com/subdir'
      _(app.pagy_url_for(pagy, 5, fragment: '#fragment')).must_equal "http://www.pagy-standalone.com/subdir?a%5B%5D=1&a%5B%5D=2&a%5B%5D=3&page=5&items=20#fragment"
      _(app.pagy_url_for(pagy, 5, absolute: true, fragment: '#fragment')).must_equal "http://www.pagy-standalone.com/subdir?a%5B%5D=1&a%5B%5D=2&a%5B%5D=3&page=5&items=20#fragment"
      pagy = Pagy.new count: 1000, page: 3, params: { a: nil }, url: ''
      _(app.pagy_url_for(pagy, 5, fragment: '#fragment')).must_equal "?a&page=5&items=20#fragment"
      _(app.pagy_url_for(pagy, 5, absolute: true, fragment: '#fragment')).must_equal "?a&page=5&items=20#fragment"
    end
  end
end
