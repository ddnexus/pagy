require 'byebug'
require_relative '../../test_helper'
require 'pagy/extras/infinite'

SingleCov.covered!

describe Pagy::Backend do

  let(:backend) { TestController.new }

  describe "#pagy_infinite" do
    before do
      @collection = TestCollection.new((1..1000).to_a)
    end

    it 'gets vars on not last page' do
      TestCollection.define_method(:exists?) { true }

      vars = {page: 2, items: 10, link_extra: 'X'}
      merged = backend.send :pagy_infinite_get_vars, @collection, vars
      pagy = Pagy.new(merged)

      merged.keys.must_include :count
      merged.keys.must_include :page
      merged.keys.must_include :items
      merged.keys.must_include :link_extra
      merged[:count].must_equal 21
      merged[:page].must_equal 2
      merged[:items].must_equal 10
      merged[:link_extra].must_equal 'X'
      pagy.series.must_equal []
    end

    it 'gets vars with gaps' do
      TestCollection.define_method(:exists?) { true }

      vars = {page: 25, items: 10, link_extra: 'X'}
      merged = backend.send :pagy_infinite_get_vars, @collection, vars
      pagy = Pagy.new(merged)

      merged[:count].must_equal 251
      pagy.series.must_equal []
    end

    it 'gets vars on last page' do
      TestCollection.define_method(:exists?) { false }

      vars = {page: 2, items: 10, link_extra: 'X'}
      merged = backend.send :pagy_infinite_get_vars, @collection, vars
      pagy = Pagy.new(merged)

      merged[:count].must_equal 20
      pagy.series.must_equal []
    end


    it 'pagy_infinite call' do
      TestCollection.define_method(:exists?) { true }
      pagy, scope = backend.send :pagy_infinite, @collection, { page: 2, items: 2 }
      pagy.must_be_kind_of ::Pagy
      scope.must_equal [3,4]
    end

  end

end
