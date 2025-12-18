# frozen_string_literal: true

require 'test_helper'

describe Pagy::Loader do
  let(:loader) { Pagy::Loader }

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
end
