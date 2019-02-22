# encoding: utf-8
# frozen_string_literal: true

require_relative '../../test_helper'
require 'pagy/extras/array'

SingleCov.covered! unless ENV['SKIP_SINGLECOV']

describe Pagy::Backend do

  let(:backend) { TestController.new }

  describe "#pagy_array" do

    before do
      @collection = (1..1000).to_a
    end

    it 'paginates with defaults' do
      pagy, items = backend.send(:pagy_array, @collection)
      pagy.must_be_instance_of Pagy
      pagy.count.must_equal 1000
      pagy.items.must_equal Pagy::VARS[:items]
      pagy.page.must_equal backend.params[:page]
      items.count.must_equal Pagy::VARS[:items]
      items.must_equal [41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60]
    end

    it 'paginates with vars' do
      pagy, items = backend.send(:pagy_array, @collection, page: 2, items: 10, link_extra: 'X')
      pagy.must_be_instance_of Pagy
      pagy.count.must_equal 1000
      pagy.items.must_equal 10
      pagy.page.must_equal 2
      pagy.vars[:link_extra].must_equal 'X'
      items.count.must_equal 10
      items.must_equal [11, 12, 13, 14, 15, 16, 17, 18, 19, 20]
    end

  end

  describe "#pagy_array_get_vars" do

    before do
      @collection = (1..1000).to_a
    end

    it 'gets defaults' do
      vars   = {}
      merged = backend.send :pagy_array_get_vars, @collection, vars
      merged.keys.must_include :count
      merged.keys.must_include :page
      merged[:count].must_equal 1000
      merged[:page].must_equal 3
    end

    it 'gets vars' do
      vars   = {page: 2, items: 10, link_extra: 'X'}
      merged = backend.send :pagy_array_get_vars, @collection, vars
      merged.keys.must_include :count
      merged.keys.must_include :page
      merged.keys.must_include :items
      merged.keys.must_include :link_extra
      merged[:count].must_equal 1000
      merged[:page].must_equal 2
      merged[:items].must_equal 10
      merged[:link_extra].must_equal 'X'
    end

  end

end
