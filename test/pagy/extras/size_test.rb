# frozen_string_literal: true

require_relative '../../test_helper'
require 'pagy/extras/size'

describe 'pagy/extras/size' do
  describe '#series (size = Array)' do
    before do
      @vars0 = { count: 103,
                 limit: 10,
                 size: [0, 2, 2, 0] }
      @vars1 = { count: 103,
                 limit: 10,
                 size: [3, 0, 0, 3] }
      @vars2 = { count: 103,
                 limit: 10,
                 size: [3, 2, 0, 0] }
      @vars3 = { count: 103,
                 limit: 10,
                 size: [3, 2, 2, 3] }
    end

    def series_for(page, *expected)
      expected.each_with_index do |value, index|
        vars = instance_variable_get(:"@vars#{index}").merge(page: page)

        _(Pagy.new(**vars).series).must_equal value
      end
    end

    it 'computes series for page 1' do
      series_for 1,
                 ["1", 2, 3, :gap],
                 ["1", 2, 3, :gap, 9, 10, 11],
                 ["1", 2, 3, :gap],
                 ["1", 2, 3, :gap, 9, 10, 11]
    end
    it 'computes series for page 2' do
      series_for 2,
                 [1, "2", 3, 4, :gap],
                 [1, "2", 3, :gap, 9, 10, 11],
                 [1, "2", 3, :gap],
                 [1, "2", 3, 4, :gap, 9, 10, 11]
    end
    it 'computes series for page 3' do
      series_for 3,
                 [1, 2, "3", 4, 5, :gap],
                 [1, 2, "3", :gap, 9, 10, 11],
                 [1, 2, "3", :gap],
                 [1, 2, "3", 4, 5, :gap, 9, 10, 11]
    end
    it 'computes series for page 4' do
      series_for 4,
                 [1, 2, 3, "4", 5, 6, :gap],
                 [1, 2, 3, "4", :gap, 9, 10, 11],
                 [1, 2, 3, "4", :gap],
                 [1, 2, 3, "4", 5, 6, :gap, 9, 10, 11]
    end
    it 'computes series for page 5' do
      series_for 5,
                 [:gap, 3, 4, "5", 6, 7, :gap],
                 [1, 2, 3, 4, "5", :gap, 9, 10, 11],
                 [1, 2, 3, 4, "5", :gap],
                 [1, 2, 3, 4, "5", 6, 7, 8, 9, 10, 11]
    end
    it 'computes series for page 6' do
      series_for 6,
                 [:gap, 4, 5, "6", 7, 8, :gap],
                 [1, 2, 3, :gap, "6", :gap, 9, 10, 11],
                 [1, 2, 3, 4, 5, "6", :gap],
                 [1, 2, 3, 4, 5, "6", 7, 8, 9, 10, 11]
    end
    it 'computes series for page 7' do
      series_for 7,
                 [:gap, 5, 6, "7", 8, 9, :gap],
                 [1, 2, 3, :gap, "7", 8, 9, 10, 11],
                 [1, 2, 3, 4, 5, 6, "7", :gap],
                 [1, 2, 3, 4, 5, 6, "7", 8, 9, 10, 11]
    end
    it 'computes series for page 8' do
      series_for 8,
                 [:gap, 6, 7, "8", 9, 10, 11],
                 [1, 2, 3, :gap, "8", 9, 10, 11],
                 [1, 2, 3, :gap, 6, 7, "8", :gap],
                 [1, 2, 3, :gap, 6, 7, "8", 9, 10, 11]
    end
    it 'computes series for page 9' do
      series_for 9,
                 [:gap, 7, 8, "9", 10, 11],
                 [1, 2, 3, :gap, "9", 10, 11],
                 [1, 2, 3, :gap, 7, 8, "9", :gap],
                 [1, 2, 3, :gap, 7, 8, "9", 10, 11]
    end
    it 'computes series for page 10' do
      series_for 10,
                 [:gap, 8, 9, "10", 11],
                 [1, 2, 3, :gap, 9, "10", 11],
                 [1, 2, 3, :gap, 8, 9, "10", 11],
                 [1, 2, 3, :gap, 8, 9, "10", 11]
    end
    it 'computes series for page 11' do
      series_for 11,
                 [:gap, 9, 10, "11"],
                 [1, 2, 3, :gap, 9, 10, "11"],
                 [1, 2, 3, :gap, 9, 10, "11"],
                 [1, 2, 3, :gap, 9, 10, "11"]
    end

    it 'computes series for count 0' do
      _(Pagy.new(**@vars3, count: 0).series).must_equal ["1"]
    end
    it 'computes series for single page' do
      _(Pagy.new(**@vars3, count: 8).series).must_equal ["1"]
    end
    it 'computes series for 1 of 2 pages' do
      _(Pagy.new(**@vars3, count: 15).series).must_equal ["1", 2]
    end
    it 'computes series for 2 of 2 pages' do
      _(Pagy.new(**@vars3, count: 15, page: 2).series).must_equal [1, "2"]
    end
    it 'computes an empty series' do
      _(Pagy.new(**@vars3, count: 100, size: []).series).must_equal []
    end
    it 'use super for non array size' do
      _(Pagy.new(**@vars3, count: 100, size: 0).series).must_equal []
      _(Pagy.new(**@vars3, count: 103, size: 7, page: 6).series).must_equal [1, :gap, 5, "6", 7, :gap, 11]
    end
    it 'raises Pagy::Variable errors for wrong size' do
      _ { Pagy.new(count: 100, page: 2, size: [1, 2, 3]).series }.must_raise Pagy::VariableError
      _ { Pagy.new(count: 100, page: 2, size: [1, 2, 3, '4']).series }.must_raise Pagy::VariableError
    end
  end
end
