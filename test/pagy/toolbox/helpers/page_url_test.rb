# frozen_string_literal: true

require 'test_helper'
require 'pagy/toolbox/helpers/page_url'

describe 'Pagy#page_url' do
  let(:pagy_class) do
    Class.new(Pagy) do
      attr_accessor :page, :previous, :next, :last

      def initialize(vars = {})
        @page     = vars[:page]
        @previous = vars[:previous]
        @next     = vars[:next]
        @last     = vars[:last]
      end

      # Mock Linkable#compose_page_url
      def compose_page_url(page, **_opts)
        "https://example.com/foo?page=#{page || 1}"
      end

      public :page_url
    end
  end

  let(:pagy) { pagy_class.new(page: 3, previous: 2, next: 4, last: 10) }

  it 'returns url for :first' do
    # :first sets target to nil, which calls compose_page_url(nil) -> page=1
    _(pagy.page_url(:first)).must_equal "https://example.com/foo?page=1"
  end

  it 'returns url for :previous' do
    _(pagy.page_url(:previous)).must_equal "https://example.com/foo?page=2"
  end

  it 'returns nil for :previous if previous is nil' do
    pagy.previous = nil
    _(pagy.page_url(:previous)).must_be_nil
  end

  it 'returns url for :current' do
    _(pagy.page_url(:current)).must_equal "https://example.com/foo?page=3"
  end

  it 'returns url for :next' do
    _(pagy.page_url(:next)).must_equal "https://example.com/foo?page=4"
  end

  it 'returns nil for :next if next is nil' do
    pagy.next = nil
    _(pagy.page_url(:next)).must_be_nil
  end

  it 'returns url for :last' do
    _(pagy.page_url(:last)).must_equal "https://example.com/foo?page=10"
  end

  it 'returns nil for :last if last is nil' do
    pagy.last = nil
    _(pagy.page_url(:last)).must_be_nil
  end

  it 'returns url for specific page number' do
    _(pagy.page_url(5)).must_equal "https://example.com/foo?page=5"
  end
end
