# frozen_string_literal: true

require_relative '../../test_helper'
require 'pagy/extras/standalone'
require 'pagy/extras/items'

require_relative '../../mock_helpers/app'

describe 'pagy/extras/standalone_items' do
  let(:app) { MockApp.new }

  describe '#pagy_url_for' do
    it 'renders url with params and fragment' do
      pagy = Pagy.new count: 1000, page: 3, params: { a: 3, b: 4 }, fragment: '#fragment'
      _(app.pagy_url_for(pagy, 5)).must_equal "/foo?page=5&amp;a=3&amp;b=4&amp;items=20#fragment"
      _(app.pagy_url_for(pagy, 5, absolute: true)).must_equal "http://example.com:3000/foo?page=5&amp;a=3&amp;b=4&amp;items=20#fragment"
      pagy = Pagy.new count: 1000, page: 3, params: { a: [1, 2, 3] }, fragment: '#fragment', url: 'http://www.pagy-standalone.com/subdir'
      _(app.pagy_url_for(pagy, 5)).must_equal "http://www.pagy-standalone.com/subdir?a[]=1&amp;a[]=2&amp;a[]=3&amp;page=5&amp;items=20#fragment"
      _(app.pagy_url_for(pagy, 5, absolute: true)).must_equal "http://www.pagy-standalone.com/subdir?a[]=1&amp;a[]=2&amp;a[]=3&amp;page=5&amp;items=20#fragment"
      pagy = Pagy.new count: 1000, page: 3, params: { a: nil }, fragment: '#fragment', url: ''
      _(app.pagy_url_for(pagy, 5)).must_equal "?a&amp;page=5&amp;items=20#fragment"
      _(app.pagy_url_for(pagy, 5, absolute: true)).must_equal "?a&amp;page=5&amp;items=20#fragment"
    end
  end
end
