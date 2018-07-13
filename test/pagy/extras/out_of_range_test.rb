require 'pagy'
require_relative '../../test_helper'
require 'pagy/extras/out_of_range'

SingleCov.covered!

describe Pagy do

  let(:vars) {{ page: 100, count: 103, items: 10, size: [3, 2, 2, 3] }}
  let(:pagy) {Pagy.new(vars)}

  describe "variables" do

    it 'has vars defaults' do
      Pagy::VARS[:out_of_range_mode].must_equal :last_page
    end

  end

  describe "#out_of_range?" do

    it 'must be out_of_range?'  do
      pagy.must_be :out_of_range?
      Pagy.new(vars.merge(page:2)).wont_be :out_of_range?
    end

  end


  describe "#initialize" do

    it 'works in :last_page mode' do
      pagy.must_be_instance_of Pagy
      pagy.page.must_equal pagy.last
      pagy.vars[:page].must_equal 100
      pagy.offset.must_equal 100
      pagy.items.must_equal 3
      pagy.from.must_equal 101
      pagy.to.must_equal 103
      pagy.prev.must_equal 10
    end

    it 'raises OutOfRangeError in :exception mode' do
      proc { Pagy.new(vars.merge(out_of_range_mode: :exception)) }.must_raise Pagy::OutOfRangeError
    end

    it 'works in :empty_page mode' do
      pagy = Pagy.new(vars.merge(out_of_range_mode: :empty_page))
      pagy.page.must_equal 100
      pagy.offset.must_equal 0
      pagy.items.must_equal 0
      pagy.from.must_equal 0
      pagy.to.must_equal 0
      pagy.prev.must_equal pagy.last
    end

    it 'raises ArgumentError' do
      proc { Pagy.new(vars.merge(out_of_range_mode: :unknown)) }.must_raise ArgumentError
    end

  end

  describe "#series singleton for :empty_page mode" do

    it 'computes series for last page' do
      pagy = Pagy.new(vars.merge(out_of_range_mode: :empty_page))
      series = pagy.series
      series.must_equal [1, 2, 3, :gap, 9, 10, 11]
      pagy.page.must_equal 100
    end

  end

end
