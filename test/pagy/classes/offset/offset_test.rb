# frozen_string_literal: true

require_relative '../../../test_helper'
require_relative '../../../../gem/lib/pagy/toolbox/helpers/support/series' # just to check the series

OPTIONS = { count: 103, limit: 10 }.freeze
OPTS_WITH_LENGTH = [3, 6, 9].map { |l| OPTIONS.merge(slots: l) }.freeze

describe 'pagy offset' do
  let(:pagy) { Pagy::Offset.new(count: 100, page: 4) }

  describe 'initialize' do
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
      pagy = Pagy::Offset.new(**OPTIONS, count: 0)
      _(pagy.last).must_equal 1
      _(pagy.offset).must_equal 0
      _(pagy.in).must_equal 0
      _(pagy.from).must_equal 0
      _(pagy.to).must_equal 0
      _(pagy.previous).must_be_nil
      _(pagy.next).must_be_nil
    end
    it 'initializes single page' do
      pagy = Pagy::Offset.new(**OPTIONS, count: 8)
      _(pagy.last).must_equal 1
      _(pagy.offset).must_equal 0
      _(pagy.in).must_equal 8
      _(pagy.from).must_equal 1
      _(pagy.to).must_equal 8
      _(pagy.previous).must_be_nil
      _(pagy.next).must_be_nil
    end
    it 'initializes page 1 of 2' do
      pagy = Pagy::Offset.new(**OPTIONS, count: 15)
      _(pagy.last).must_equal 2
      _(pagy.offset).must_equal 0
      _(pagy.in).must_equal 10
      _(pagy.from).must_equal 1
      _(pagy.to).must_equal 10
      _(pagy.previous).must_be_nil
      _(pagy.next).must_equal 2
    end
    it 'initializes page 2 of 2' do
      pagy = Pagy::Offset.new(**OPTIONS, count: 15, page: 2)
      _(pagy.last).must_equal 2
      _(pagy.offset).must_equal 10
      _(pagy.in).must_equal 5
      _(pagy.from).must_equal 11
      _(pagy.to).must_equal 15
      _(pagy.previous).must_equal 1
      _(pagy.page).must_equal 2
      _(pagy.next).must_be_nil
    end
    it 'initializes page 1' do
      pagy = Pagy::Offset.new(**OPTIONS, page: 1)
      _(pagy.count).must_equal 103
      _(pagy.last).must_equal 11
      _(pagy.limit).must_equal 10
      _(pagy.offset).must_equal 0
      _(pagy.in).must_equal 10
      _(pagy.from).must_equal 1
      _(pagy.to).must_equal 10
      _(pagy.previous).must_be_nil
      _(pagy.page).must_equal 1
      _(pagy.next).must_equal 2
    end
    it 'initializes page 2' do
      pagy = Pagy::Offset.new(**OPTIONS, page: 2)
      _(pagy.count).must_equal 103
      _(pagy.last).must_equal 11
      _(pagy.limit).must_equal 10
      _(pagy.offset).must_equal 10
      _(pagy.in).must_equal 10
      _(pagy.from).must_equal 11
      _(pagy.to).must_equal 20
      _(pagy.previous).must_equal 1
      _(pagy.page).must_equal 2
      _(pagy.next).must_equal 3
    end
    it 'initializes page 3' do
      pagy = Pagy::Offset.new(**OPTIONS, page: 3)
      _(pagy.count).must_equal 103
      _(pagy.last).must_equal 11
      _(pagy.limit).must_equal 10
      _(pagy.offset).must_equal 20
      _(pagy.in).must_equal 10
      _(pagy.from).must_equal 21
      _(pagy.to).must_equal 30
      _(pagy.previous).must_equal 2
      _(pagy.page).must_equal 3
      _(pagy.next).must_equal 4
    end
    it 'initializes page 4' do
      pagy = Pagy::Offset.new(**OPTIONS, page: 4)
      _(pagy.count).must_equal 103
      _(pagy.last).must_equal 11
      _(pagy.limit).must_equal 10
      _(pagy.offset).must_equal 30
      _(pagy.in).must_equal 10
      _(pagy.from).must_equal 31
      _(pagy.to).must_equal 40
      _(pagy.previous).must_equal 3
      _(pagy.page).must_equal 4
      _(pagy.next).must_equal 5
    end
    it 'initializes page 5' do
      pagy = Pagy::Offset.new(**OPTIONS, page: 5)
      _(pagy.count).must_equal 103
      _(pagy.last).must_equal 11
      _(pagy.limit).must_equal 10
      _(pagy.offset).must_equal 40
      _(pagy.in).must_equal 10
      _(pagy.from).must_equal 41
      _(pagy.to).must_equal 50
      _(pagy.previous).must_equal 4
      _(pagy.page).must_equal 5
      _(pagy.next).must_equal 6
    end
    it 'initializes page 6' do
      pagy = Pagy::Offset.new(**OPTIONS, page: 6)
      _(pagy.count).must_equal 103
      _(pagy.last).must_equal 11
      _(pagy.limit).must_equal 10
      _(pagy.offset).must_equal 50
      _(pagy.in).must_equal 10
      _(pagy.from).must_equal 51
      _(pagy.to).must_equal 60
      _(pagy.previous).must_equal 5
      _(pagy.page).must_equal 6
      _(pagy.next).must_equal 7
    end
    it 'initializes page 7' do
      pagy = Pagy::Offset.new(**OPTIONS, page: 7)
      _(pagy.count).must_equal 103
      _(pagy.last).must_equal 11
      _(pagy.limit).must_equal 10
      _(pagy.offset).must_equal 60
      _(pagy.in).must_equal 10
      _(pagy.from).must_equal 61
      _(pagy.to).must_equal 70
      _(pagy.previous).must_equal 6
      _(pagy.page).must_equal 7
      _(pagy.next).must_equal 8
    end
    it 'initializes page 8' do
      pagy = Pagy::Offset.new(**OPTIONS, page: 8)
      _(pagy.count).must_equal 103
      _(pagy.last).must_equal 11
      _(pagy.limit).must_equal 10
      _(pagy.offset).must_equal 70
      _(pagy.in).must_equal 10
      _(pagy.from).must_equal 71
      _(pagy.to).must_equal 80
      _(pagy.previous).must_equal 7
      _(pagy.page).must_equal 8
      _(pagy.next).must_equal 9
    end
    it 'initializes page 9' do
      pagy = Pagy::Offset.new(**OPTIONS, page: 9)
      _(pagy.count).must_equal 103
      _(pagy.last).must_equal 11
      _(pagy.limit).must_equal 10
      _(pagy.offset).must_equal 80
      _(pagy.in).must_equal 10
      _(pagy.from).must_equal 81
      _(pagy.to).must_equal 90
      _(pagy.previous).must_equal 8
      _(pagy.page).must_equal 9
      _(pagy.next).must_equal 10
    end
    it 'initializes page 10' do
      pagy = Pagy::Offset.new(**OPTIONS, page: 10)
      _(pagy.count).must_equal 103
      _(pagy.last).must_equal 11
      _(pagy.limit).must_equal 10
      _(pagy.offset).must_equal 90
      _(pagy.in).must_equal 10
      _(pagy.from).must_equal 91
      _(pagy.to).must_equal 100
      _(pagy.previous).must_equal 9
      _(pagy.page).must_equal 10
      _(pagy.next).must_equal 11
    end
    it 'initializes page 11' do
      pagy = Pagy::Offset.new(**OPTIONS, page: 11)
      _(pagy.count).must_equal 103
      _(pagy.last).must_equal 11
      _(pagy.limit).must_equal 10
      _(pagy.offset).must_equal 100
      _(pagy.in).must_equal 3
      _(pagy.from).must_equal 101
      _(pagy.to).must_equal 103
      _(pagy.previous).must_equal 10
      _(pagy.page).must_equal 11
      _(pagy.next).must_be_nil
    end
    it 'handles the :max_pages option' do
      pagy = Pagy::Offset.new(count: 100, page: 3, limit: 10, max_pages: 8)
      _(pagy.count).must_equal 100
      _(pagy.last).must_equal 8
      _ { Pagy::Offset.new(count: 100, page: 9, limit: 10, max_pages: 8, raise_range_error: true) }.must_raise Pagy::RangeError
    end
    it 'initializes the path' do
      pagy = Pagy::Offset.new(count: 100, path: '/foo')
      _(pagy.options[:path]).must_equal('/foo')
    end
  end

  describe 'accessors' do
    it 'has accessors' do
      %i[count page limit options offset last from to in previous next].each do |meth|
        _(pagy).must_respond_to meth
      end
    end
  end

  describe 'options' do
    it 'has options defaults' do
      _(Pagy::DEFAULT[:page_key]).must_equal 'page'
      _(Pagy::DEFAULT[:limit]).must_equal 20
      _(Pagy::Offset::DEFAULT[:page]).must_equal 1
    end
  end

  describe 'series' do
    [[1,
      ["1", 2, 3],
      ["1", 2, 3, 4, 5, 6],
      ["1", 2, 3, 4, 5, 6, 7, :gap, 11]],
     [2,
      [1, "2", 3],
      [1, "2", 3, 4, 5, 6],
      [1, "2", 3, 4, 5, 6, 7, :gap, 11]],
     [3,
      [2, "3", 4],
      [1, 2, "3", 4, 5, 6],
      [1, 2, "3", 4, 5, 6, 7, :gap, 11]],
     [4,
      [3, "4", 5],
      [2, 3, "4", 5, 6, 7],
      [1, 2, 3, "4", 5, 6, 7, :gap, 11]],
     [5,
      [4, "5", 6],
      [3, 4, "5", 6, 7, 8],
      [1, 2, 3, 4, "5", 6, 7, :gap, 11]],
     [6,
      [5, "6", 7],
      [4, 5, "6", 7, 8, 9],
      [1, :gap, 4, 5, "6", 7, 8, :gap, 11]],
     [7,
      [6, "7", 8],
      [5, 6, "7", 8, 9, 10],
      [1, :gap, 5, 6, "7", 8, 9, 10, 11]],
     [8,
      [7, "8", 9],
      [6, 7, "8", 9, 10, 11],
      [1, :gap, 5, 6, 7, "8", 9, 10, 11]],
     [9,
      [8, "9", 10],
      [6, 7, 8, "9", 10, 11],
      [1, :gap, 5, 6, 7, 8, "9", 10, 11]],
     [10,
      [9, "10", 11],
      [6, 7, 8, 9, "10", 11],
      [1, :gap, 5, 6, 7, 8, 9, "10", 11]],
     [11,
      [9, 10, "11"],
      [6, 7, 8, 9, 10, "11"],
      [1, :gap, 5, 6, 7, 8, 9, 10, "11"]]].each do |page, *expected|
      expected.each_with_index do |value, index|
        it "computes series for page #{page}, length #{OPTS_WITH_LENGTH[index][:slots]}" do
          _(Pagy::Offset.new(**OPTS_WITH_LENGTH[index], page:).send(:series)).must_equal value
        end
      end
    end

    it 'computes series for count 0' do
      _(Pagy::Offset.new(**OPTS_WITH_LENGTH[2], count: 0).send(:series)).must_equal ["1"]
    end
    it 'computes series for single page' do
      _(Pagy::Offset.new(**OPTS_WITH_LENGTH[2], count: 8).send(:series)).must_equal ["1"]
    end
    it 'computes series for 1 of 2 pages' do
      _(Pagy::Offset.new(**OPTS_WITH_LENGTH[2], count: 15).send(:series)).must_equal ["1", 2]
    end
    it 'computes series for 2 of 2 pages' do
      _(Pagy::Offset.new(**OPTS_WITH_LENGTH[2], count: 15, page: 2).send(:series)).must_equal [1, "2"]
      _(Pagy::Offset.new(**OPTS_WITH_LENGTH[2], count: 100).send(:series, slots: 0)).must_equal []
    end
    it 'raises OptionError for invalid length' do
      _ { Pagy::Offset.new(count: 100).send(:series, slots: {}) }.must_raise Pagy::OptionError
      _ { Pagy::Offset.new(count: 100).send(:series, slots: -3) }.must_raise Pagy::OptionError
    end
  end
end
