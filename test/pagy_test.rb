# encoding: utf-8
# frozen_string_literal: true

require_relative 'test_helper'

SingleCov.covered! unless ENV['SKIP_SINGLECOV']

describe Pagy do

  let(:pagy) { Pagy.new count: 100, page: 4 }

  it 'has version' do
    Pagy::VERSION.wont_be_nil
  end

  describe "#initialize" do

    before do
      @vars  = { count: 103, items: 10, size: [3, 2, 2, 3] }
    end

    it 'initializes' do
      pagy.must_be_instance_of Pagy
      Pagy.new(count: 100).must_be_instance_of Pagy
      Pagy.new(count: '100').must_be_instance_of Pagy
      Pagy.new(count: 100, page: '2').must_be_instance_of Pagy
      Pagy.new(count: 100, page: '').must_be_instance_of Pagy
      Pagy.new(count: 100, items: '10').must_be_instance_of Pagy
      proc { Pagy.new({}) }.must_raise ArgumentError
      proc { Pagy.new(count: 100, page: 0) }.must_raise ArgumentError
      proc { Pagy.new(count: 100, page: 2, items: 0) }.must_raise ArgumentError
      proc { Pagy.new(count: 100, page: 2, size: [1, 2, 3]).series }.must_raise ArgumentError
      proc { Pagy.new(count: 100, page: 2, size: [1, 2, 3, '4']).series }.must_raise ArgumentError
      proc { Pagy.new(count: 100, page: '11') }.must_raise Pagy::OverflowError
      e = proc { Pagy.new(count: 100, page: 12) }.must_raise Pagy::OverflowError
      e.pagy.must_be_instance_of Pagy
    end

    it 'initializes count 0' do
      pagy = Pagy.new @vars.merge(count: 0)
      pagy.pages.must_equal 1
      pagy.last.must_equal 1
      pagy.offset.must_equal 0
      pagy.from.must_equal 0
      pagy.to.must_equal 0
      pagy.prev.must_be_nil
      pagy.next.must_be_nil
    end

    it 'initializes single page' do
      pagy = Pagy.new @vars.merge(count: 8)
      pagy.pages.must_equal 1
      pagy.last.must_equal 1
      pagy.offset.must_equal 0
      pagy.from.must_equal 1
      pagy.to.must_equal 8
      pagy.prev.must_be_nil
      pagy.next.must_be_nil
    end

    it 'initializes page 1 of 2' do
      pagy = Pagy.new @vars.merge(count: 15)
      pagy.pages.must_equal 2
      pagy.last.must_equal 2
      pagy.offset.must_equal 0
      pagy.from.must_equal 1
      pagy.to.must_equal 10
      pagy.prev.must_be_nil
      pagy.next.must_equal 2
    end

    it 'initializes page 2 of 2' do
      pagy = Pagy.new @vars.merge(count: 15, page: 2)
      pagy.pages.must_equal 2
      pagy.last.must_equal 2
      pagy.offset.must_equal 10
      pagy.from.must_equal 11
      pagy.to.must_equal 15
      pagy.prev.must_equal 1
      pagy.page.must_equal 2
      pagy.next.must_be_nil
    end

    it 'initializes page 1' do
      pagy = Pagy.new @vars.merge(page: 1)
      pagy.count.must_equal 103
      pagy.pages.must_equal 11
      pagy.last.must_equal 11
      pagy.items.must_equal 10
      pagy.offset.must_equal 0
      pagy.from.must_equal 1
      pagy.to.must_equal 10
      pagy.prev.must_be_nil
      pagy.page.must_equal 1
      pagy.next.must_equal 2
    end

    it 'initializes page 2' do
      pagy = Pagy.new @vars.merge(page: 2)
      pagy.count.must_equal 103
      pagy.pages.must_equal 11
      pagy.last.must_equal 11
      pagy.items.must_equal 10
      pagy.offset.must_equal 10
      pagy.from.must_equal 11
      pagy.to.must_equal 20
      pagy.prev.must_equal 1
      pagy.page.must_equal 2
      pagy.next.must_equal 3
    end

    it 'initializes page 3' do
      pagy = Pagy.new @vars.merge(page: 3)
      pagy.count.must_equal 103
      pagy.pages.must_equal 11
      pagy.last.must_equal 11
      pagy.items.must_equal 10
      pagy.offset.must_equal 20
      pagy.from.must_equal 21
      pagy.to.must_equal 30
      pagy.prev.must_equal 2
      pagy.page.must_equal 3
      pagy.next.must_equal 4
    end

    it 'initializes page 4' do
      pagy = Pagy.new @vars.merge(page: 4)
      pagy.count.must_equal 103
      pagy.pages.must_equal 11
      pagy.last.must_equal 11
      pagy.items.must_equal 10
      pagy.offset.must_equal 30
      pagy.from.must_equal 31
      pagy.to.must_equal 40
      pagy.prev.must_equal 3
      pagy.page.must_equal 4
      pagy.next.must_equal 5
    end

    it 'initializes page 5' do
      pagy = Pagy.new @vars.merge(page: 5)
      pagy.count.must_equal 103
      pagy.pages.must_equal 11
      pagy.last.must_equal 11
      pagy.items.must_equal 10
      pagy.offset.must_equal 40
      pagy.from.must_equal 41
      pagy.to.must_equal 50
      pagy.prev.must_equal 4
      pagy.page.must_equal 5
      pagy.next.must_equal 6
    end

    it 'initializes page 6' do
      pagy = Pagy.new @vars.merge(page: 6)
      pagy.count.must_equal 103
      pagy.pages.must_equal 11
      pagy.last.must_equal 11
      pagy.items.must_equal 10
      pagy.offset.must_equal 50
      pagy.from.must_equal 51
      pagy.to.must_equal 60
      pagy.prev.must_equal 5
      pagy.page.must_equal 6
      pagy.next.must_equal 7
    end

    it 'initializes page 7' do
      pagy = Pagy.new @vars.merge(page: 7)
      pagy.count.must_equal 103
      pagy.pages.must_equal 11
      pagy.last.must_equal 11
      pagy.items.must_equal 10
      pagy.offset.must_equal 60
      pagy.from.must_equal 61
      pagy.to.must_equal 70
      pagy.prev.must_equal 6
      pagy.page.must_equal 7
      pagy.next.must_equal 8
    end

    it 'initializes page 8' do
      pagy = Pagy.new @vars.merge(page: 8)
      pagy.count.must_equal 103
      pagy.pages.must_equal 11
      pagy.last.must_equal 11
      pagy.items.must_equal 10
      pagy.offset.must_equal 70
      pagy.from.must_equal 71
      pagy.to.must_equal 80
      pagy.prev.must_equal 7
      pagy.page.must_equal 8
      pagy.next.must_equal 9
    end

    it 'initializes page 9' do
      pagy = Pagy.new @vars.merge(page: 9)
      pagy.count.must_equal 103
      pagy.pages.must_equal 11
      pagy.last.must_equal 11
      pagy.items.must_equal 10
      pagy.offset.must_equal 80
      pagy.from.must_equal 81
      pagy.to.must_equal 90
      pagy.prev.must_equal 8
      pagy.page.must_equal 9
      pagy.next.must_equal 10
    end

    it 'initializes page 10' do
      pagy = Pagy.new @vars.merge(page: 10)
      pagy.count.must_equal 103
      pagy.pages.must_equal 11
      pagy.last.must_equal 11
      pagy.items.must_equal 10
      pagy.offset.must_equal 90
      pagy.from.must_equal 91
      pagy.to.must_equal 100
      pagy.prev.must_equal 9
      pagy.page.must_equal 10
      pagy.next.must_equal 11
    end

    it 'initializes page 11' do
      pagy = Pagy.new @vars.merge(page: 11)
      pagy.count.must_equal 103
      pagy.pages.must_equal 11
      pagy.last.must_equal 11
      pagy.items.must_equal 3
      pagy.offset.must_equal 100
      pagy.from.must_equal 101
      pagy.to.must_equal 103
      pagy.prev.must_equal 10
      pagy.page.must_equal 11
      pagy.next.must_be_nil
    end

    it 'initializes outset page 1' do
      pagy = Pagy.new(count: 87, page: 1, outset: 10, items: 10)
      pagy.offset.must_equal 10
      pagy.items.must_equal 10
      pagy.from.must_equal 1
      pagy.to.must_equal 10
      pagy.pages.must_equal 9
    end

    it 'initializes outset page 9' do
      pagy = Pagy.new(count: 87, page: 9, outset: 10, items: 10)
      pagy.offset.must_equal 90
      pagy.items.must_equal 7
      pagy.from.must_equal 81
      pagy.to.must_equal 87
      pagy.pages.must_equal 9
    end

    it 'initializes items of last page of one' do
      Pagy.new(items: 10, count: 0).items.must_equal 10
      Pagy.new(items: 10, count: 4).items.must_equal 4
      Pagy.new(items: 10, count: 10).items.must_equal 10
    end

    it 'initializes items of last page of many' do
      Pagy.new(items: 10, count: 14, page: 2).items.must_equal 4
      Pagy.new(items: 10, count: 20, page: 2).items.must_equal 10
    end

    it 'handles the :cycle variable' do
      pagy = Pagy.new(count: 100, page: 10, items: 10, cycle: true)
      pagy.prev.must_equal(9)
      pagy.next.must_equal 1
    end

  end

  describe "accessors" do

    it 'has accessors' do
      [
      :count, :page, :items, :vars, # input
      :offset, :pages, :last, :from, :to, :prev, :next, :series # output
      ].each do |meth|
        pagy.must_respond_to meth
      end
    end

  end

  describe "variables" do

    it 'has vars defaults' do
      Pagy::VARS[:page].must_equal 1
      Pagy::VARS[:items].must_equal 20
      Pagy::VARS[:outset].must_equal 0
      Pagy::VARS[:size].must_equal [1, 4, 4, 1]
      Pagy::VARS[:page_param].must_equal :page
      Pagy::VARS[:params].must_equal({})
    end

  end

  describe "#series" do

    before do
      @vars0 = { count: 103,
                 items: 10,
                 size:  [0, 2, 2, 0] }
      @vars1 = { count: 103,
                 items: 10,
                 size:  [3, 0, 0, 3] }
      @vars2 = { count: 103,
                 items: 10,
                 size:  [3, 2, 0, 0] }
      @vars3 = { count: 103,
                 items: 10,
                 size:  [3, 2, 2, 3] }
    end

    def series_for(page, *expected)
      expected.each_with_index do |value, index|
        vars = instance_variable_get(:"@vars#{index}").merge(page: page)
        Pagy.new(vars).series.must_equal value
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
      Pagy.new(@vars3.merge(count: 0)).series.must_equal ["1"]
    end

    it 'computes series for single page' do
      Pagy.new(@vars3.merge(count: 8)).series.must_equal ["1"]
    end

    it 'computes series for 1 of 2 pages' do
      Pagy.new(@vars3.merge(count: 15)).series.must_equal ["1", 2]
    end

    it 'computes series for 2 of 2 pages' do
      Pagy.new(@vars3.merge(count: 15, page: 2)).series.must_equal [1, "2"]
    end

    it 'computes an empty series' do
      Pagy.new(@vars3.merge(count: 100, size: [])).series.must_equal []
    end

  end

end
