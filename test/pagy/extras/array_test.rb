require_relative '../../test_helper'
require 'pagy/extras/array'

SingleCov.covered!

describe Pagy::Backend do


  let(:backend) { TestController.new }

  describe "#pagy_array" do
    before do
      @collection = (1..1000).to_a
    end

    def test_extra_pagy_array_with_default
      pagy, records = backend.send(:pagy_array, @collection)

      assert_instance_of Pagy, pagy
      assert_equal 1000, pagy.count
      assert_equal Pagy::VARS[:items], pagy.items
      assert_equal backend.params[:page], pagy.page

      assert_equal Pagy::VARS[:items], records.count
      assert_equal [41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60], records
    end

    def test_extra_pagy_array_with_vars
      pagy, records = backend.send(:pagy_array, @collection, page: 2, items: 10, link_extra: 'X')

      assert_instance_of Pagy, pagy
      assert_equal 1000, pagy.count
      assert_equal 10, pagy.items
      assert_equal 2, pagy.page
      assert_equal 'X', pagy.vars[:link_extra]

      assert_equal 10, records.count
      assert_equal [11, 12, 13, 14, 15, 16, 17, 18, 19, 20], records
    end

  end

  describe "#pagy_array_get_vars" do
    before do
      @collection = (1..1000).to_a
    end

    def test_extra_pagy_array_get_vars_with_default
      vars   = {}
      merged = backend.send :pagy_array_get_vars, @collection, vars
      assert_includes(merged.keys, :count)
      assert_includes(merged.keys, :page)
      assert_equal(1000, merged[:count])
      assert_equal(3, merged[:page])
    end

    def test_extra_pagy_array_get_vars_with_vars
      vars   = {page: 2, items: 10, link_extra: 'X'}
      merged = backend.send :pagy_array_get_vars, @collection, vars
      assert_includes(merged.keys, :count)
      assert_includes(merged.keys, :page)
      assert_includes(merged.keys, :items)
      assert_includes(merged.keys, :link_extra)
      assert_equal(1000, merged[:count])
      assert_equal(2, merged[:page])
      assert_equal(10, merged[:items])
      assert_equal('X', merged[:link_extra])
    end

  end

end
