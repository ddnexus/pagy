# frozen_string_literal: true

require_relative '../test_helper'

describe 'pagy' do
  let(:pagy) { Pagy::Offset.new(count: 100, page: 4) }

  describe '#initialize' do
    before do
      @opts = { count: 103, limit: 10 }
    end
    it 'initializes' do
      _(pagy).must_be_instance_of Pagy::Offset
      _(Pagy::Offset.new(count: 100)).must_be_instance_of Pagy::Offset
      _(Pagy::Offset.new(count: '100')).must_be_instance_of Pagy::Offset
      _(Pagy::Offset.new(count: 100, page: '2')).must_be_instance_of Pagy::Offset
      _(Pagy::Offset.new(count: 100, page: '')).must_be_instance_of Pagy::Offset
      _(Pagy::Offset.new(count: 100, limit: '10')).must_be_instance_of Pagy::Offset
      _ { Pagy::Offset.new(count: 0, page: -1) }.must_raise Pagy::OptionError
      _ { Pagy::Offset.new(count: 100, page: 0) }.must_raise Pagy::OptionError
      _ { Pagy::Offset.new(count: 100, page: {}) }.must_raise Pagy::OptionError
      _ { Pagy::Offset.new(count: 100, page: 2, limit: 0) }.must_raise Pagy::OptionError
      _ { Pagy::Offset.new(count: 100, page: '11', raise_range_error: true) }.must_raise Pagy::RangeError
      _ { Pagy::Offset.new(count: 100, page: 12, raise_range_error: true) }.must_raise Pagy::RangeError
      begin
        Pagy::Offset.new(count: 100, page: 12)
      rescue Pagy::RangeError => e
        _(e.pagy).must_be_instance_of Pagy::Offset
      end
    end
    it 'initializes count 0' do
      pagy = Pagy::Offset.new(**@opts, count: 0)
      _(pagy.last).must_equal 1
      _(pagy.last).must_equal 1
      _(pagy.offset).must_equal 0
      _(pagy.in).must_equal 0
      _(pagy.from).must_equal 0
      _(pagy.to).must_equal 0
      _(pagy.prev).must_be_nil
      _(pagy.next).must_be_nil
    end
    it 'initializes single page' do
      pagy = Pagy::Offset.new(**@opts, count: 8)
      _(pagy.last).must_equal 1
      _(pagy.last).must_equal 1
      _(pagy.offset).must_equal 0
      _(pagy.in).must_equal 8
      _(pagy.from).must_equal 1
      _(pagy.to).must_equal 8
      _(pagy.prev).must_be_nil
      _(pagy.next).must_be_nil
    end
    it 'initializes page 1 of 2' do
      pagy = Pagy::Offset.new(**@opts, count: 15)
      _(pagy.last).must_equal 2
      _(pagy.last).must_equal 2
      _(pagy.offset).must_equal 0
      _(pagy.in).must_equal 10
      _(pagy.from).must_equal 1
      _(pagy.to).must_equal 10
      _(pagy.prev).must_be_nil
      _(pagy.next).must_equal 2
    end
    it 'initializes page 2 of 2' do
      pagy = Pagy::Offset.new(**@opts, count: 15, page: 2)
      _(pagy.last).must_equal 2
      _(pagy.last).must_equal 2
      _(pagy.offset).must_equal 10
      _(pagy.in).must_equal 5
      _(pagy.from).must_equal 11
      _(pagy.to).must_equal 15
      _(pagy.prev).must_equal 1
      _(pagy.page).must_equal 2
      _(pagy.next).must_be_nil
    end
    it 'initializes page 1' do
      pagy = Pagy::Offset.new(**@opts, page: 1)
      _(pagy.count).must_equal 103
      _(pagy.last).must_equal 11
      _(pagy.last).must_equal 11
      _(pagy.limit).must_equal 10
      _(pagy.offset).must_equal 0
      _(pagy.in).must_equal 10
      _(pagy.from).must_equal 1
      _(pagy.to).must_equal 10
      _(pagy.prev).must_be_nil
      _(pagy.page).must_equal 1
      _(pagy.next).must_equal 2
    end
    it 'initializes page 2' do
      pagy = Pagy::Offset.new(**@opts, page: 2)
      _(pagy.count).must_equal 103
      _(pagy.last).must_equal 11
      _(pagy.last).must_equal 11
      _(pagy.limit).must_equal 10
      _(pagy.offset).must_equal 10
      _(pagy.in).must_equal 10
      _(pagy.from).must_equal 11
      _(pagy.to).must_equal 20
      _(pagy.prev).must_equal 1
      _(pagy.page).must_equal 2
      _(pagy.next).must_equal 3
    end
    it 'initializes page 3' do
      pagy = Pagy::Offset.new(**@opts, page: 3)
      _(pagy.count).must_equal 103
      _(pagy.last).must_equal 11
      _(pagy.last).must_equal 11
      _(pagy.limit).must_equal 10
      _(pagy.offset).must_equal 20
      _(pagy.in).must_equal 10
      _(pagy.from).must_equal 21
      _(pagy.to).must_equal 30
      _(pagy.prev).must_equal 2
      _(pagy.page).must_equal 3
      _(pagy.next).must_equal 4
    end
    it 'initializes page 4' do
      pagy = Pagy::Offset.new(**@opts, page: 4)
      _(pagy.count).must_equal 103
      _(pagy.last).must_equal 11
      _(pagy.last).must_equal 11
      _(pagy.limit).must_equal 10
      _(pagy.offset).must_equal 30
      _(pagy.in).must_equal 10
      _(pagy.from).must_equal 31
      _(pagy.to).must_equal 40
      _(pagy.prev).must_equal 3
      _(pagy.page).must_equal 4
      _(pagy.next).must_equal 5
    end
    it 'initializes page 5' do
      pagy = Pagy::Offset.new(**@opts, page: 5)
      _(pagy.count).must_equal 103
      _(pagy.last).must_equal 11
      _(pagy.last).must_equal 11
      _(pagy.limit).must_equal 10
      _(pagy.offset).must_equal 40
      _(pagy.in).must_equal 10
      _(pagy.from).must_equal 41
      _(pagy.to).must_equal 50
      _(pagy.prev).must_equal 4
      _(pagy.page).must_equal 5
      _(pagy.next).must_equal 6
    end
    it 'initializes page 6' do
      pagy = Pagy::Offset.new(**@opts, page: 6)
      _(pagy.count).must_equal 103
      _(pagy.last).must_equal 11
      _(pagy.last).must_equal 11
      _(pagy.limit).must_equal 10
      _(pagy.offset).must_equal 50
      _(pagy.in).must_equal 10
      _(pagy.from).must_equal 51
      _(pagy.to).must_equal 60
      _(pagy.prev).must_equal 5
      _(pagy.page).must_equal 6
      _(pagy.next).must_equal 7
    end
    it 'initializes page 7' do
      pagy = Pagy::Offset.new(**@opts, page: 7)
      _(pagy.count).must_equal 103
      _(pagy.last).must_equal 11
      _(pagy.last).must_equal 11
      _(pagy.limit).must_equal 10
      _(pagy.offset).must_equal 60
      _(pagy.in).must_equal 10
      _(pagy.from).must_equal 61
      _(pagy.to).must_equal 70
      _(pagy.prev).must_equal 6
      _(pagy.page).must_equal 7
      _(pagy.next).must_equal 8
    end
    it 'initializes page 8' do
      pagy = Pagy::Offset.new(**@opts, page: 8)
      _(pagy.count).must_equal 103
      _(pagy.last).must_equal 11
      _(pagy.last).must_equal 11
      _(pagy.limit).must_equal 10
      _(pagy.offset).must_equal 70
      _(pagy.in).must_equal 10
      _(pagy.from).must_equal 71
      _(pagy.to).must_equal 80
      _(pagy.prev).must_equal 7
      _(pagy.page).must_equal 8
      _(pagy.next).must_equal 9
    end
    it 'initializes page 9' do
      pagy = Pagy::Offset.new(**@opts, page: 9)
      _(pagy.count).must_equal 103
      _(pagy.last).must_equal 11
      _(pagy.last).must_equal 11
      _(pagy.limit).must_equal 10
      _(pagy.offset).must_equal 80
      _(pagy.in).must_equal 10
      _(pagy.from).must_equal 81
      _(pagy.to).must_equal 90
      _(pagy.prev).must_equal 8
      _(pagy.page).must_equal 9
      _(pagy.next).must_equal 10
    end
    it 'initializes page 10' do
      pagy = Pagy::Offset.new(**@opts, page: 10)
      _(pagy.count).must_equal 103
      _(pagy.last).must_equal 11
      _(pagy.last).must_equal 11
      _(pagy.limit).must_equal 10
      _(pagy.offset).must_equal 90
      _(pagy.in).must_equal 10
      _(pagy.from).must_equal 91
      _(pagy.to).must_equal 100
      _(pagy.prev).must_equal 9
      _(pagy.page).must_equal 10
      _(pagy.next).must_equal 11
    end
    it 'initializes page 11' do
      pagy = Pagy::Offset.new(**@opts, page: 11)
      _(pagy.count).must_equal 103
      _(pagy.last).must_equal 11
      _(pagy.last).must_equal 11
      _(pagy.limit).must_equal 10
      _(pagy.offset).must_equal 100
      _(pagy.in).must_equal 3
      _(pagy.from).must_equal 101
      _(pagy.to).must_equal 103
      _(pagy.prev).must_equal 10
      _(pagy.page).must_equal 11
      _(pagy.next).must_be_nil
    end
    it 'handles the :max_pages option' do
      pagy = Pagy::Offset.new(count: 100, page: 3, limit: 10, max_pages: 8)
      _(pagy.count).must_equal 100
      _(pagy.last).must_equal 8
      _ { Pagy::Offset.new(count: 100, page: 9, limit: 10, max_pages: 8, raise_range_error: true) }.must_raise Pagy::RangeError
    end
    it 'initializes the request_path' do
      pagy = Pagy::Offset.new(count: 100, request_path: '/foo')
      _(pagy.opts[:request_path]).must_equal('/foo')
    end
  end

  describe 'accessors' do
    it 'has accessors' do
      [
        :count, :page, :limit, :opts, # input
        :offset, :pages, :last, :from, :to, :in, :prev, :next, :series # output
      ].each do |meth|
        _(pagy).must_respond_to meth
      end
    end
  end

  describe 'options' do
    it 'has opts defaults' do
      _(Pagy::DEFAULT[:page_sym]).must_equal :page
      _(Pagy::DEFAULT[:limit]).must_equal 20
      _(Pagy::Offset::DEFAULT[:page]).must_equal 1
      _(Pagy::Offset::DEFAULT[:size]).must_equal 7
    end
  end

  describe '#series (size = Integer)' do
    before do
      @opts0 = { count: 103,
                 limit: 10,
                 size:  3 }
      @opts1 = { count: 103,
                 limit: 10,
                 size: 6}
      @opts2 = { count: 103,
                 limit: 10,
                 size: 9 }
    end

    def series_for(page, *expected)
      expected.each_with_index do |value, index|
        opts = instance_variable_get(:"@opts#{index}").merge(page: page)
        _(Pagy::Offset.new(**opts).series).must_equal value
      end
    end

    it 'computes series for page 1' do
      series_for 1,
                 ["1", 2, 3],
                 ["1", 2, 3, 4, 5, 6],
                 ["1", 2, 3, 4, 5, 6, 7, :gap, 11]
    end
    it 'computes series for page 2' do
      series_for 2,
                 [1, "2", 3],
                 [1, "2", 3, 4, 5, 6],
                 [1, "2", 3, 4, 5, 6, 7, :gap, 11]
    end
    it 'computes series for page 3' do
      series_for 3,
                 [2, "3", 4],
                 [1, 2, "3", 4, 5, 6],
                 [1, 2, "3", 4, 5, 6, 7, :gap, 11]
    end
    it 'computes series for page 4' do
      series_for 4,
                 [3, "4", 5],
                 [2, 3, "4", 5, 6, 7],
                 [1, 2, 3, "4", 5, 6, 7, :gap, 11]
    end
    it 'computes series for page 5' do
      series_for 5,
                 [4, "5", 6],
                 [3, 4, "5", 6, 7, 8],
                 [1, 2, 3, 4, "5", 6, 7, :gap, 11]
    end
    it 'computes series for page 6' do
      series_for 6,
                 [5, "6", 7],
                 [4, 5, "6", 7, 8, 9],
                 [1, :gap, 4, 5, "6", 7, 8, :gap, 11]
    end
    it 'computes series for page 7' do
      series_for 7,
                 [6, "7", 8],
                 [5, 6, "7", 8, 9, 10],
                 [1, :gap, 5, 6, "7", 8, 9, 10, 11]
    end
    it 'computes series for page 8' do
      series_for 8,
                 [7, "8", 9],
                 [6, 7, "8", 9, 10, 11],
                 [1, :gap, 5, 6, 7, "8", 9, 10, 11]
    end
    it 'computes series for page 9' do
      series_for 9,
                 [8, "9", 10],
                 [6, 7, 8, "9", 10, 11],
                 [1, :gap, 5, 6, 7, 8, "9", 10, 11]
    end
    it 'computes series for page 10' do
      series_for 10,
                 [9, "10", 11],
                 [6, 7, 8, 9, "10", 11],
                 [1, :gap, 5, 6, 7, 8, 9, "10", 11]
    end
    it 'computes series for page 11' do
      series_for 11,
                 [9, 10, "11"],
                 [6, 7, 8, 9, 10, "11"],
                 [1, :gap, 5, 6, 7, 8, 9, 10, "11"]
    end
    it 'computes series for count 0' do
      _(Pagy::Offset.new(**@opts2, count: 0).series).must_equal ["1"]
    end
    it 'computes series for single page' do
      _(Pagy::Offset.new(**@opts2, count: 8).series).must_equal ["1"]
    end
    it 'computes series for 1 of 2 pages' do
      _(Pagy::Offset.new(**@opts2, count: 15).series).must_equal ["1", 2]
    end
    it 'computes series for 2 of 2 pages' do
      _(Pagy::Offset.new(**@opts2, count: 15, page: 2).series).must_equal [1, "2"]
    end
    it 'computes an empty series' do
      _(Pagy::Offset.new(**@opts2, count: 100, size: 0).series).must_equal []
    end
    it 'raises OptionError for invalid size' do
      _ { Pagy::Offset.new(count: 100, size: {}).series }.must_raise Pagy::OptionError
      _ { Pagy::Offset.new(count: 100, size: -3).series }.must_raise Pagy::OptionError
    end
  end

  describe 'labels' do
    it 'returns the current page label' do
      _(Pagy::Offset.new(count: 1000, page: 11).label).must_equal '11'
    end
    it 'returns any page label' do
      p = Pagy::Offset.new(count: 1000, page: 11)
      _(p.label(page: 3)).must_equal '3'
      _(p.label(page: 11)).must_equal '11'
    end
  end
end
