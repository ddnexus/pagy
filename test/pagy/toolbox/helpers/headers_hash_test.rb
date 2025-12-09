# frozen_string_literal: true

require 'test_helper'
require 'pagy/toolbox/helpers/headers_hash'

describe 'Pagy#headers_hash' do
  let(:pagy_class) do
    Class.new(Pagy) do
      attr_accessor :page, :limit, :last, :count, :options

      def initialize(vars = {})
        @options = vars[:options] || {}
        @page    = vars[:page]
        @limit   = vars[:limit]
        @last    = vars[:last]
        @count   = vars[:count]
      end

      def calendar?
        @options[:calendar]
      end

      # Mock urls_hash to avoid dependency on Linkable/UrlsHash logic
      def urls_hash(absolute: false, **_opts) # rubocop:disable Lint/UnusedMethodArgument
        { 'first' => 'http://example.com/1', 'next' => 'http://example.com/3' }
      end

      public :headers_hash
    end
  end

  it 'returns default headers' do
    pagy = pagy_class.new(page: 2, limit: 20, last: 5, count: 100)
    headers = pagy.headers_hash

    _(headers['link']).must_equal '<http://example.com/1>; rel="first", <http://example.com/3>; rel="next"'
    _(headers['current-page']).must_equal '2'
    _(headers['page-limit']).must_equal '20'
    _(headers['total-pages']).must_equal '5'
    _(headers['total-count']).must_equal '100'
  end

  it 'omits limit if calendar' do
    pagy = pagy_class.new(page: 1, limit: 20, count: 100, options: { calendar: true })
    headers = pagy.headers_hash

    _(headers.keys).wont_include 'page-limit'
    _(headers['total-count']).must_equal '100'
  end

  it 'omits total-pages and total-count if count is nil' do
    pagy = pagy_class.new(page: 1, limit: 20, last: 5, count: nil)
    headers = pagy.headers_hash

    _(headers.keys).wont_include 'total-pages'
    _(headers.keys).wont_include 'total-count'
  end

  it 'uses custom headers map' do
    pagy = pagy_class.new(page: 2, limit: 20)
    custom_map = { page: 'X-Page', limit: 'X-Limit' }
    headers = pagy.headers_hash(headers_map: custom_map)

    _(headers['X-Page']).must_equal '2'
    _(headers['X-Limit']).must_equal '20'
    _(headers.keys).wont_include 'current-page'
  end

  it 'ignores nil names in headers map' do
    pagy = pagy_class.new(page: 2)
    custom_map = { page: nil }
    headers = pagy.headers_hash(headers_map: custom_map)

    # Link header is always present because urls_hash mock returns links
    _(headers.keys).must_equal ['link']
  end
end
