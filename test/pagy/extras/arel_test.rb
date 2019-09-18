# encoding: utf-8
# frozen_string_literal: true

require_relative '../../test_helper'
require_relative '../../mock_helpers/arel'
require 'pagy/extras/arel'

describe Pagy::Backend do

  let(:controller) { MockController.new }

  describe "#pagy_arel" do

    before do
      @collection = MockCollection::Grouped.new((1..1000).to_a)
    end

    it 'paginates with defaults' do
      pagy, items = controller.send(:pagy_arel, @collection)
      pagy.must_be_instance_of Pagy
      pagy.count.must_equal 1000
      pagy.items.must_equal Pagy::VARS[:items]
      pagy.page.must_equal controller.params[:page]
      items.size.must_equal Pagy::VARS[:items]
      items.must_equal [41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60]
    end

    it 'paginates with vars' do
      pagy, items = controller.send(:pagy_arel, @collection, page: 2, items: 10, link_extra: 'X')
      pagy.must_be_instance_of Pagy
      pagy.count.must_equal 1000
      pagy.items.must_equal 10
      pagy.page.must_equal 2
      pagy.vars[:link_extra].must_equal 'X'
      items.size.must_equal 10
      items.must_equal [11, 12, 13, 14, 15, 16, 17, 18, 19, 20]
    end

  end

  describe "#pagy_arel_get_vars" do

    before do
      @collection = MockCollection.new
    end

    it 'gets defaults' do
      vars   = {}
      merged = controller.send :pagy_get_vars, @collection, vars
      merged.keys.must_include :count
      merged.keys.must_include :page
      merged[:count].must_equal 1000
      merged[:page].must_equal 3
    end

    it 'gets vars' do
      vars   = {page: 2, items: 10, link_extra: 'X'}
      merged = controller.send :pagy_get_vars, @collection, vars
      merged.keys.must_include :count
      merged.keys.must_include :page
      merged.keys.must_include :items
      merged.keys.must_include :link_extra
      merged[:count].must_equal 1000
      merged[:page].must_equal 2
      merged[:items].must_equal 10
      merged[:link_extra].must_equal 'X'
    end

    it 'works with grouped collections' do
      @collection = MockCollection::Grouped.new((1..1000).to_a)
      vars   = {page: 2, items: 10, link_extra: 'X'}
      merged = controller.send :pagy_get_vars, @collection, vars
      merged.keys.must_include :count
      merged.keys.must_include :page
      merged.keys.must_include :items
      merged.keys.must_include :link_extra
      merged[:count].must_equal 1000
      merged[:page].must_equal 2
      merged[:items].must_equal 10
      merged[:link_extra].must_equal 'X'
    end

    it 'overrides count and page' do
      vars   = {count: 10, page: 32}
      merged = controller.send :pagy_get_vars, @collection, vars
      merged.keys.must_include :count
      merged[:count].must_equal 10
      merged.keys.must_include :page
      merged[:page].must_equal 32
    end

  end

end
