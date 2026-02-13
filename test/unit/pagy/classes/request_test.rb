# frozen_string_literal: true

require 'unit/test_helper'
require 'pagy/classes/request'

describe 'Pagy::Request Specs' do
  let(:default_options) { { page_key: 'page', limit_key: 'limit' } }

  describe 'initialization' do
    it 'handles Hash request' do
      req_hash = { base_url: 'http://example.com', path: '/foo', params: { 'a' => 1 }, cookie: 'cookie' }
      request = Pagy::Request.new(default_options.merge(request: req_hash))

      _(request.base_url).must_equal 'http://example.com'
      _(request.path).must_equal '/foo'
      _(request.params).must_equal({ 'a' => 1 })
      _(request.cookie).must_equal 'cookie'
    end

    it 'handles Rack-like request' do
      # Mocking a Rack Request object
      # GET and POST are usually hashes, cookies is a hash-like object
      mock_rack = Struct.new(:base_url, :path, :GET, :POST, :cookies, keyword_init: true)  # rubocop:disable Naming/MethodName

      rack_req = mock_rack.new(
        base_url: 'http://rack.com',
        path: '/bar',
        GET: { 'a' => '1' },
        POST: { 'b' => '2' },
        cookies: { 'pagy' => 'stored_cookie' }
      )

      request = Pagy::Request.new(default_options.merge(request: rack_req))

      _(request.base_url).must_equal 'http://rack.com'
      _(request.path).must_equal '/bar'
      # Merges GET and POST
      _(request.params).must_equal({ 'a' => '1', 'b' => '2' })
      _(request.cookie).must_equal 'stored_cookie'
    end

    it 'freezes the request and params' do
      mock_rack = Struct.new(:base_url, :path, :GET, :POST, :cookies, keyword_init: true) # rubocop:disable Naming/MethodName
      rack_req = mock_rack.new(
        base_url: 'http://rack.com',
        path: '/bar',
        GET: { 'a' => '1' },
        POST: { 'b' => '2' },
        cookies: { 'pagy' => 'stored_cookie' }
      )
      request = Pagy::Request.new(default_options.merge(request: rack_req))

      _(request).must_be :frozen?
      _(request.params).must_be :frozen?
    end
  end

  describe '#resolve_page' do
    it 'returns 1 by default when missing' do
      req = Pagy::Request.new(default_options.merge(request: { params: {} }))
      _(req.resolve_page).must_equal 1
    end

    it 'returns 1 when page is empty string' do
      req = Pagy::Request.new(default_options.merge(request: { params: { 'page' => '' } }))
      _(req.resolve_page).must_equal 1
    end

    it 'returns 1 when page is 0' do
      req = Pagy::Request.new(default_options.merge(request: { params: { 'page' => '0' } }))
      _(req.resolve_page).must_equal 1
    end

    it 'extracts page from flat params' do
      req = Pagy::Request.new(default_options.merge(request: { params: { 'page' => '5' } }))
      _(req.resolve_page).must_equal 5
    end

    it 'extracts page from nested params (root_key)' do
      opts = default_options.merge(root_key: 'search', request: { params: { 'search' => { 'page' => '10' } } })
      req = Pagy::Request.new(opts)
      _(req.resolve_page).must_equal 10
    end

    it 'returns raw value if force_integer is false' do
      req = Pagy::Request.new(default_options.merge(request: { params: { 'page' => '5' } }))
      _(req.resolve_page(force_integer: false)).must_equal '5'
    end

    it 'returns nil if missing and force_integer is false' do
      req = Pagy::Request.new(default_options.merge(request: { params: {} }))
      _(req.resolve_page(force_integer: false)).must_be_nil
    end
    it 'returns nil if empty and force_integer is false' do
      req = Pagy::Request.new(default_options.merge(request: { params: { 'page' => '' } }))
      _(req.resolve_page(force_integer: false)).must_be_nil
    end
  end

  describe '#resolve_limit' do
    it 'returns default limit when client_max_limit is not set' do
      # Uses Pagy::DEFAULT or options[:limit]
      req = Pagy::Request.new(default_options.merge(limit: 25, request: { params: { 'limit' => '100' } }))
      # Should ignore params because client_max_limit is not set
      _(req.resolve_limit).must_equal 25
    end

    describe 'with client_max_limit' do
      let(:opts) { default_options.merge(client_max_limit: 50, request: { params: {} }) }

      it 'returns params limit if within max' do
        opts[:request][:params] = { 'limit' => '30' }
        req = Pagy::Request.new(opts)
        _(req.resolve_limit).must_equal 30
      end

      it 'clamps params limit to max' do
        opts[:request][:params] = { 'limit' => '100' }
        req = Pagy::Request.new(opts)
        _(req.resolve_limit).must_equal 50
      end

      it 'extracts limit from nested params' do
        opts[:root_key] = 'search'
        opts[:request][:params] = { 'search' => { 'limit' => 40 } }
        req = Pagy::Request.new(opts)
        _(req.resolve_limit).must_equal 40
      end

      it 'returns options limit if params missing' do
        opts[:limit] = 20
        # No limit in params
        req = Pagy::Request.new(opts)
        _(req.resolve_limit).must_equal 20
      end
    end
  end
end
