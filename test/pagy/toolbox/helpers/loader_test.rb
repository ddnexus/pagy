# frozen_string_literal: true

require 'test_helper'

describe Pagy::Loader do
  let(:loader) { Pagy::Loader }
  # Use an anonymous class to avoid namespace pollution and linting errors
  let(:pagy_class) do
    Class.new(Pagy) do
      def initialize(**vars)
        assign_options(**vars)
      end
    end
  end

  it 'defines public methods' do
    # From paths[:public] in source
    public_methods = %i[page_url data_hash headers_hash urls_hash next_tag previous_tag
                        input_nav_js info_tag limit_tag_js series_nav series_nav_js]

    public_methods.each do |method|
      _(loader.public_instance_methods).must_include method
    end
  end

  it 'defines protected methods' do
    # From paths[:protected] in source
    protected_methods = %i[bootstrap_series_nav bootstrap_series_nav_js bootstrap_input_nav_js
                           bulma_series_nav bulma_series_nav_js bulma_input_nav_js]

    protected_methods.each do |method|
      _(loader.protected_instance_methods).must_include method
    end
  end

  it 'aliases methods to the loader' do
    # Verify that the methods are initially aliased to the loader logic
    m = loader.instance_method(:page_url)
    _(m.original_name).must_equal :load_public

    m = loader.instance_method(:bootstrap_series_nav)
    _(m.original_name).must_equal :load_protected
  end

  it 'loads and executes the method (smoke test)' do
    # Mock a request object compatible with Linkable
    mock_request = Struct.new(:params, :path, :base_url, keyword_init: true).new(
      params: {}, path: '/path', base_url: 'http://example.com'
    )

    # Initialize the anonymous subclass with the mock request
    pagy = pagy_class.new(count: 100, request: mock_request)

    # Calling page_url(1) should trigger the loader, require 'page_url.rb',
    # and execute the real page_url method which calls compose_page_url
    url = pagy.page_url(1)

    _(url).must_equal_url '/path?page=1'
  end
end
