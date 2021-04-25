# frozen_string_literal: true

require_relative 'test_helper'

def series_for(page, *expected)
  expected.each_with_index do |value, index|
    vars = instance_variable_get(:"@vars#{index}").merge(page: page)
    _(Pagy.new(vars).series).must_equal value
  end
end

describe 'pagy' do
  let(:pagy) { Pagy.new count: 100, page: 4 }

  describe 'version match' do
    it 'has version' do
      _(Pagy::VERSION).wont_be_nil
    end
    it 'defines the same version in config/pagy.rb' do
      _(File.read(Pagy.root.join('config', 'pagy.rb'))).must_match "# Pagy initializer file (#{Pagy::VERSION})"
    end
    it 'defines the same version in javascripts/pagy.js' do
      _(File.read(Pagy.root.join('javascripts', 'pagy.js'))).must_match "Pagy.version = '#{Pagy::VERSION}'"
    end
    it 'defines the same version in CHANGELOG.md' do
      _(File.read(Pagy.root.parent.join('CHANGELOG.md'))).must_match "## Version #{Pagy::VERSION}"
    end
  end

  describe '#initialize' do
    before do
      @vars  = { count: 103, items: 10, size: [3, 2, 2, 3] }
    end
    it 'initializes' do
      _(pagy).must_be_instance_of Pagy
      _(Pagy.new(count: 100)).must_be_instance_of Pagy
      _(Pagy.new(count: '100')).must_be_instance_of Pagy
      _(Pagy.new(count: 100, page: '2')).must_be_instance_of Pagy
      _(Pagy.new(count: 100, page: '')).must_be_instance_of Pagy
      _(Pagy.new(count: 100, items: '10')).must_be_instance_of Pagy
      _ { Pagy.new({}) }.must_raise Pagy::VariableError
      _ { Pagy.new(count: 0, page: -1) }.must_raise Pagy::VariableError
      _ { Pagy.new(count: 100, page: 0) }.must_raise Pagy::VariableError
      _ { Pagy.new(count: 100, page: 2, items: 0) }.must_raise Pagy::VariableError
      _ { Pagy.new(count: 100, page: 2, size: [1, 2, 3]).series }.must_raise Pagy::VariableError
      _ { Pagy.new(count: 100, page: 2, size: [1, 2, 3, '4']).series }.must_raise Pagy::VariableError
      _ { Pagy.new(count: 100, page: '11') }.must_raise Pagy::OverflowError
      _ { Pagy.new(count: 100, page: 12) }.must_raise Pagy::OverflowError
      begin
        Pagy.new(count: 100, page: 12)
      rescue Pagy::OverflowError => e
        _(e.pagy).must_be_instance_of Pagy
      end
    end
    it 'initializes count 0' do
      pagy = Pagy.new @vars.merge(count: 0)
      _(pagy.pages).must_equal 1
      _(pagy.last).must_equal 1
      _(pagy.offset).must_equal 0
      _(pagy.from).must_equal 0
      _(pagy.to).must_equal 0
      _(pagy.prev).must_be_nil
      _(pagy.next).must_be_nil
    end
    it 'initializes single page' do
      pagy = Pagy.new @vars.merge(count: 8)
      _(pagy.pages).must_equal 1
      _(pagy.last).must_equal 1
      _(pagy.offset).must_equal 0
      _(pagy.from).must_equal 1
      _(pagy.to).must_equal 8
      _(pagy.prev).must_be_nil
      _(pagy.next).must_be_nil
    end
    it 'initializes page 1 of 2' do
      pagy = Pagy.new @vars.merge(count: 15)
      _(pagy.pages).must_equal 2
      _(pagy.last).must_equal 2
      _(pagy.offset).must_equal 0
      _(pagy.from).must_equal 1
      _(pagy.to).must_equal 10
      _(pagy.prev).must_be_nil
      _(pagy.next).must_equal 2
    end
    it 'initializes page 2 of 2' do
      pagy = Pagy.new @vars.merge(count: 15, page: 2)
      _(pagy.pages).must_equal 2
      _(pagy.last).must_equal 2
      _(pagy.offset).must_equal 10
      _(pagy.from).must_equal 11
      _(pagy.to).must_equal 15
      _(pagy.prev).must_equal 1
      _(pagy.page).must_equal 2
      _(pagy.next).must_be_nil
    end
    it 'initializes page 1' do
      pagy = Pagy.new @vars.merge(page: 1)
      _(pagy.count).must_equal 103
      _(pagy.pages).must_equal 11
      _(pagy.last).must_equal 11
      _(pagy.items).must_equal 10
      _(pagy.offset).must_equal 0
      _(pagy.from).must_equal 1
      _(pagy.to).must_equal 10
      _(pagy.prev).must_be_nil
      _(pagy.page).must_equal 1
      _(pagy.next).must_equal 2
    end
    it 'initializes page 2' do
      pagy = Pagy.new @vars.merge(page: 2)
      _(pagy.count).must_equal 103
      _(pagy.pages).must_equal 11
      _(pagy.last).must_equal 11
      _(pagy.items).must_equal 10
      _(pagy.offset).must_equal 10
      _(pagy.from).must_equal 11
      _(pagy.to).must_equal 20
      _(pagy.prev).must_equal 1
      _(pagy.page).must_equal 2
      _(pagy.next).must_equal 3
    end
    it 'initializes page 3' do
      pagy = Pagy.new @vars.merge(page: 3)
      _(pagy.count).must_equal 103
      _(pagy.pages).must_equal 11
      _(pagy.last).must_equal 11
      _(pagy.items).must_equal 10
      _(pagy.offset).must_equal 20
      _(pagy.from).must_equal 21
      _(pagy.to).must_equal 30
      _(pagy.prev).must_equal 2
      _(pagy.page).must_equal 3
      _(pagy.next).must_equal 4
    end
    it 'initializes page 4' do
      pagy = Pagy.new @vars.merge(page: 4)
      _(pagy.count).must_equal 103
      _(pagy.pages).must_equal 11
      _(pagy.last).must_equal 11
      _(pagy.items).must_equal 10
      _(pagy.offset).must_equal 30
      _(pagy.from).must_equal 31
      _(pagy.to).must_equal 40
      _(pagy.prev).must_equal 3
      _(pagy.page).must_equal 4
      _(pagy.next).must_equal 5
    end
    it 'initializes page 5' do
      pagy = Pagy.new @vars.merge(page: 5)
      _(pagy.count).must_equal 103
      _(pagy.pages).must_equal 11
      _(pagy.last).must_equal 11
      _(pagy.items).must_equal 10
      _(pagy.offset).must_equal 40
      _(pagy.from).must_equal 41
      _(pagy.to).must_equal 50
      _(pagy.prev).must_equal 4
      _(pagy.page).must_equal 5
      _(pagy.next).must_equal 6
    end
    it 'initializes page 6' do
      pagy = Pagy.new @vars.merge(page: 6)
      _(pagy.count).must_equal 103
      _(pagy.pages).must_equal 11
      _(pagy.last).must_equal 11
      _(pagy.items).must_equal 10
      _(pagy.offset).must_equal 50
      _(pagy.from).must_equal 51
      _(pagy.to).must_equal 60
      _(pagy.prev).must_equal 5
      _(pagy.page).must_equal 6
      _(pagy.next).must_equal 7
    end
    it 'initializes page 7' do
      pagy = Pagy.new @vars.merge(page: 7)
      _(pagy.count).must_equal 103
      _(pagy.pages).must_equal 11
      _(pagy.last).must_equal 11
      _(pagy.items).must_equal 10
      _(pagy.offset).must_equal 60
      _(pagy.from).must_equal 61
      _(pagy.to).must_equal 70
      _(pagy.prev).must_equal 6
      _(pagy.page).must_equal 7
      _(pagy.next).must_equal 8
    end
    it 'initializes page 8' do
      pagy = Pagy.new @vars.merge(page: 8)
      _(pagy.count).must_equal 103
      _(pagy.pages).must_equal 11
      _(pagy.last).must_equal 11
      _(pagy.items).must_equal 10
      _(pagy.offset).must_equal 70
      _(pagy.from).must_equal 71
      _(pagy.to).must_equal 80
      _(pagy.prev).must_equal 7
      _(pagy.page).must_equal 8
      _(pagy.next).must_equal 9
    end
    it 'initializes page 9' do
      pagy = Pagy.new @vars.merge(page: 9)
      _(pagy.count).must_equal 103
      _(pagy.pages).must_equal 11
      _(pagy.last).must_equal 11
      _(pagy.items).must_equal 10
      _(pagy.offset).must_equal 80
      _(pagy.from).must_equal 81
      _(pagy.to).must_equal 90
      _(pagy.prev).must_equal 8
      _(pagy.page).must_equal 9
      _(pagy.next).must_equal 10
    end
    it 'initializes page 10' do
      pagy = Pagy.new @vars.merge(page: 10)
      _(pagy.count).must_equal 103
      _(pagy.pages).must_equal 11
      _(pagy.last).must_equal 11
      _(pagy.items).must_equal 10
      _(pagy.offset).must_equal 90
      _(pagy.from).must_equal 91
      _(pagy.to).must_equal 100
      _(pagy.prev).must_equal 9
      _(pagy.page).must_equal 10
      _(pagy.next).must_equal 11
    end
    it 'initializes page 11' do
      pagy = Pagy.new @vars.merge(page: 11)
      _(pagy.count).must_equal 103
      _(pagy.pages).must_equal 11
      _(pagy.last).must_equal 11
      _(pagy.items).must_equal 3
      _(pagy.offset).must_equal 100
      _(pagy.from).must_equal 101
      _(pagy.to).must_equal 103
      _(pagy.prev).must_equal 10
      _(pagy.page).must_equal 11
      _(pagy.next).must_be_nil
    end
    it 'initializes outset page 1' do
      pagy = Pagy.new(count: 87, page: 1, outset: 10, items: 10)
      _(pagy.offset).must_equal 10
      _(pagy.items).must_equal 10
      _(pagy.from).must_equal 1
      _(pagy.to).must_equal 10
      _(pagy.pages).must_equal 9
    end
    it 'initializes outset page 9' do
      pagy = Pagy.new(count: 87, page: 9, outset: 10, items: 10)
      _(pagy.offset).must_equal 90
      _(pagy.items).must_equal 7
      _(pagy.from).must_equal 81
      _(pagy.to).must_equal 87
      _(pagy.pages).must_equal 9
    end
    it 'initializes items of last page of one' do
      _(Pagy.new(items: 10, count: 0).items).must_equal 10
      _(Pagy.new(items: 10, count: 4).items).must_equal 4
      _(Pagy.new(items: 10, count: 10).items).must_equal 10
    end
    it 'initializes items of last page of many' do
      _(Pagy.new(items: 10, count: 14, page: 2).items).must_equal 4
      _(Pagy.new(items: 10, count: 20, page: 2).items).must_equal 10
    end
    it 'handles the :cycle variable' do
      pagy = Pagy.new(count: 100, page: 10, items: 10, cycle: true)
      _(pagy.prev).must_equal(9)
      _(pagy.next).must_equal 1
    end
  end

  describe 'accessors' do
    it 'has accessors' do
      [
      :count, :page, :items, :vars, # input
      :offset, :pages, :last, :from, :to, :prev, :next, :series # output
      ].each do |meth|
        _(pagy).must_respond_to meth
      end
    end
  end

  describe 'variables' do
    it 'has vars defaults' do
      _(Pagy::VARS[:page]).must_equal 1
      _(Pagy::VARS[:items]).must_equal 20
      _(Pagy::VARS[:outset]).must_equal 0
      _(Pagy::VARS[:size]).must_equal [1, 4, 4, 1]
      _(Pagy::VARS[:page_param]).must_equal :page
      _(Pagy::VARS[:params]).must_equal({})
    end
  end

  describe '#series' do
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
      _(Pagy.new(@vars3.merge(count: 0)).series).must_equal ["1"]
    end
    it 'computes series for single page' do
      _(Pagy.new(@vars3.merge(count: 8)).series).must_equal ["1"]
    end
    it 'computes series for 1 of 2 pages' do
      _(Pagy.new(@vars3.merge(count: 15)).series).must_equal ["1", 2]
    end
    it 'computes series for 2 of 2 pages' do
      _(Pagy.new(@vars3.merge(count: 15, page: 2)).series).must_equal [1, "2"]
    end
    it 'computes an empty series' do
      _(Pagy.new(@vars3.merge(count: 100, size: [])).series).must_equal []
    end
  end
end
