# frozen_string_literal: true

require 'unit/test_helper'
require 'pagy/toolbox/helpers/urls_hash'

describe 'Pagy#urls_hash' do
  let(:pagy_class) do
    Class.new(Pagy) do
      attr_accessor :previous, :next, :count, :last

      def initialize(vars = {})
        @previous = vars[:previous]
        @next     = vars[:next]
        @count    = vars[:count]
        @last     = vars[:last]
      end

      # Mock Linkable#compose_page_url behavior
      def compose_page_url(page, **_opts)
        # Simple mock: "url/page" (handle nil for first page case)
        "https://example.com/#{page || 1}"
      end

      public :urls_hash
    end
  end

  it 'returns full hash when all pages exist' do
    pagy = pagy_class.new(previous: 1, next: 3, count: 100, last: 5)

    # PAGE_TOKEN is 'P ' (escaped value)
    # The real compose_page_url handles the token.
    # Our mock just puts it in the string: "https://example.com/P "
    # Then sub replaces it.

    hash = pagy.urls_hash

    _(hash[:first]).must_equal "https://example.com/1"
    _(hash[:previous]).must_equal "https://example.com/1"
    _(hash[:next]).must_equal "https://example.com/3"
    _(hash[:last]).must_equal "https://example.com/5"
  end

  it 'omits previous when nil (first page)' do
    pagy = pagy_class.new(previous: nil, next: 2, count: 10, last: 5)
    hash = pagy.urls_hash

    _(hash.keys).wont_include :previous
    _(hash[:first]).must_equal "https://example.com/1"
    _(hash[:next]).must_equal "https://example.com/2"
  end

  it 'omits next when nil (last page)' do
    pagy = pagy_class.new(previous: 4, next: nil, count: 10, last: 5)
    hash = pagy.urls_hash

    _(hash.keys).wont_include :next
    _(hash[:previous]).must_equal "https://example.com/4"
  end

  it 'omits last when count is nil (unknown count)' do
    pagy = pagy_class.new(previous: 1, next: 3, count: nil, last: 5)
    hash = pagy.urls_hash

    _(hash.keys).wont_include :last
    _(hash[:next]).must_equal "https://example.com/3"
  end
end
