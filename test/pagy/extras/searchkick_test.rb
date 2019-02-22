# encoding: utf-8
# frozen_string_literal: true

require_relative '../../test_helper'
require 'pagy/extras/searchkick'

SingleCov.covered! unless ENV['SKIP_SINGLECOV']

describe Pagy::Backend do

  let(:backend) { TestController.new }

  class Searchkick
    class Results
      def initialize(params); @params = params; end
      def total_count; 1000; end
      def options
        {
          page: @params[:page] || 1,
          per_page: 25
        }
      end
    end
  end

  describe "#pagy_searchkick" do

    before do
      @collection = Searchkick::Results.new(backend.params)
    end

    it 'paginates with defaults' do
      pagy, _items = backend.send(:pagy_searchkick, @collection)
      pagy.must_be_instance_of Pagy
      pagy.count.must_equal 1000
      pagy.items.must_equal 25
      pagy.page.must_equal backend.params[:page]
    end

    it 'paginates with vars' do
      pagy, _items = backend.send(:pagy_searchkick, @collection, link_extra: 'X')
      pagy.must_be_instance_of Pagy
      pagy.count.must_equal 1000
      pagy.items.must_equal 25
      pagy.vars[:link_extra].must_equal 'X'
    end

  end

  describe "#pagy_searchkick_get_vars" do

    before do
      @collection = Searchkick::Results.new(backend.params)
    end

    it 'gets defaults' do
      vars   = {}
      merged = backend.send :pagy_searchkick_get_vars, @collection, vars
      merged.keys.must_include :count
      merged.keys.must_include :page
      merged[:count].must_equal 1000
      merged[:items].must_equal 25
      merged[:page].must_equal 3
    end

    it 'gets vars' do
      vars   = {link_extra: 'X'}
      merged = backend.send :pagy_searchkick_get_vars, @collection, vars
      merged.keys.must_include :count
      merged.keys.must_include :page
      merged.keys.must_include :link_extra
      merged[:count].must_equal 1000
      merged[:items].must_equal 25
      merged[:link_extra].must_equal 'X'
    end

  end

end
