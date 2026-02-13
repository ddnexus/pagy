# frozen_string_literal: true

require 'unit/test_helper'

describe 'Pagy::Linkable Specs' do
  describe 'QueryUtils' do
    let(:utils) { Pagy::Linkable::QueryUtils }

    it 'escapes strings' do
      _(utils.escape('a b')).must_equal 'a+b'
      _(utils.escape('/?&')).must_equal '%2F%3F%26'
    end

    it 'builds simple queries' do
      _(utils.build_nested_query(a: 1, b: 'c')).must_equal 'a=1&b=c'
    end

    it 'builds nested queries' do
      hash = { a: { b: 1 }, c: [2, 3] }
      _(utils.build_nested_query(hash)).must_equal 'a%5Bb%5D=1&c%5B%5D=2&c%5B%5D=3'
    end

    it 'ignores empty hashes in recursion' do
      _(utils.build_nested_query(a: {})).must_equal ''
      _(utils.build_nested_query(a: { b: {} })).must_equal ''
      _(utils.build_nested_query(a: 1, b: {})).must_equal 'a=1'
    end

    it 'handles nil values' do
      # Triggers the 'when nil' branch
      _(utils.build_nested_query(a: nil)).must_equal 'a'
      _(utils.build_nested_query(a: { b: nil })).must_equal 'a%5Bb%5D'
    end

    it 'handles EscapedValue without escaping' do
      val = Pagy::EscapedValue.new('PAGE')
      _(utils.build_nested_query(page: val)).must_equal 'page=PAGE'
      # Normal string would be escaped
      val = Pagy::EscapedValue.new('P & L')
      _(utils.build_nested_query(a: val)).must_equal 'a=P & L'
    end

    it 'raises argument error for non-hash root' do
      _ { utils.build_nested_query('string') }.must_raise ArgumentError
    end
  end

  describe 'instance methods' do
    # Use an anonymous class to host the mixin and avoid namespace pollution
    let(:linkable_class) do
      Class.new do
        include Pagy::Linkable

        attr_reader :options, :request

        def initialize(request_params: {}, request_path: '/foo', options: {})
          # Define struct inline to avoid constant definition in block
          @request = Struct.new(:params, :path, :base_url, keyword_init: true).new(
            params: request_params,
            path: request_path,
            base_url: 'http://example.com'
          )
          @options = {
            page_key: 'page',
          limit_key: 'limit',
          limit: 20
          }.merge(options)
        end

        # Expose protected method
        def call_compose_page_url(page, **opts)
          compose_page_url(page, **opts)
        end
      end
    end

    let(:subject) { linkable_class.new(request_params: { 'a' => 'b' }) }

    it 'generates basic url' do
      url = subject.call_compose_page_url(2)
      _(url).must_equal_url '/foo?a=b&page=2'
    end

    it 'overrides parameters' do
      # Request has page=1, should be overwritten
      subject = linkable_class.new(request_params: { 'page' => '1' })
      url = subject.call_compose_page_url(2)
      _(url).must_equal_url '/foo?page=2'
    end

    it 'handles root_key (nested params)' do
      # If root_key is :search, page should go into search[page]
      # params[:search] is nil, so this hits the `|| {}` branch
      subject = linkable_class.new(options: { root_key: :search })
      url = subject.call_compose_page_url(2)
      _(url).must_equal_url '/foo?search%5Bpage%5D=2'
    end

    it 'handles root_key with existing nested params (hits clone)' do
      # We use string 'search' to match the request_params key
      # This ensures params['search'] is found and .clone is called
      subject = linkable_class.new(request_params: { 'search' => { 'term' => 'foo' } },
                                   options: { root_key: 'search' })
      url = subject.call_compose_page_url(3)
      _(url).must_equal_url '/foo?search%5Bterm%5D=foo&search%5Bpage%5D=3'
    end

    it 'does not modify original params with root_key' do
      params = { 'search' => { 'term' => 'foo' } }
      subject = linkable_class.new(request_params: params,
                                   options:        { root_key: 'search' })
      subject.call_compose_page_url(3)
      # Ensure original param hash is untouched
      _(params['search']).must_equal({ 'term' => 'foo' })
    end

    it 'handles absolute urls' do
      subject = linkable_class.new(options: { absolute: true })
      url = subject.call_compose_page_url(2)
      _(url).must_equal_url 'http://example.com/foo?page=2'
    end

    it 'handles fragments' do
      subject = linkable_class.new(options: { fragment: '#target' })
      url = subject.call_compose_page_url(2)
      _(url).must_equal_url '/foo?page=2#target'
    end

    it 'handles custom path' do
      subject = linkable_class.new(options: { path: '/bar' })
      url = subject.call_compose_page_url(2)
      _(url).must_equal_url '/bar?page=2'
    end

    it 'supports querify proc to modify params' do
      # querify proc that deletes 'a' param
      querify = ->(params) { params.delete('a') }
      subject = linkable_class.new(request_params: { 'a' => 'b', 'c' => 'd' },
                                   options:        { querify: querify })
      url = subject.call_compose_page_url(2)
      # 'a' should be gone
      _(url).must_equal_url '/foo?c=d&page=2'
    end

    it 'handles client_max_limit' do
      # If client_max_limit is set, the limit param is included
      subject = linkable_class.new(options: { client_max_limit: 50, limit: 10 })
      url = subject.call_compose_page_url(2)
      _(url).must_equal_url '/foo?limit=10&page=2'
    end
  end
end
