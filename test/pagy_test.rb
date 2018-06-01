require_relative 'test_helper'

SingleCov.covered!

describe Pagy do
  let(:pagy) { Pagy.new count: 100, page: 4 }

  def test_version_number
    refute_nil Pagy::VERSION
  end

  describe "#initialize" do
    def test_initialization
      assert_instance_of Pagy, pagy
      assert_instance_of Pagy, Pagy.new(count: 100)
      assert_instance_of Pagy, Pagy.new(count: '100')
      assert_instance_of Pagy, Pagy.new(count: 100, page: '2')
      assert_instance_of Pagy, Pagy.new(count: 100, page: '')
      assert_instance_of Pagy, Pagy.new(count: 100, items: '10')
      assert_raises(ArgumentError) { Pagy.new({}) }
      assert_raises(ArgumentError) { Pagy.new(count: 100, page: 0) }
      assert_raises(ArgumentError) { Pagy.new(count: 100, page: 2, items: 0) }
      assert_raises(ArgumentError) { Pagy.new(count: 100, page: 2, size: [1, 2, 3]).series }
      assert_raises(ArgumentError) { Pagy.new(count: 100, page: 2, size: [1, 2, 3, '4']).series }
      assert_raises(Pagy::OutOfRangeError) { Pagy.new(count: 100, page: '11') }
      assert_raises(Pagy::OutOfRangeError) { Pagy.new(count: 100, page: 12) }
    end
  end

  describe "accessors" do
    def test_respond_to_accessors
      [
      :count, :page, :items, :vars, # input
      :offset, :pages, :last, :from, :to, :prev, :next, :series # output
      ].each do |meth|
        assert_respond_to pagy, meth
      end
    end
  end

  describe "variables" do
    def test_check_variable_defaults
      assert_equal 1, Pagy::VARS[:page]
      assert_equal 20, Pagy::VARS[:items]
      assert_equal 0, Pagy::VARS[:outset]
      assert_equal [1,4,4,1], Pagy::VARS[:size]
      assert_equal :page, Pagy::VARS[:page_param]
      assert_equal({}, Pagy::VARS[:params])
    end
  end

  describe "#series" do
    def setup
      @vars0 = { count: 103,
                 items: 10,
                 size:  [0, 2, 2, 0] }

      @vars1 = { count: 103,
                 items: 10,
                 size:  [3, 0, 0, 3] }

      @vars2 = { count: 103,
                 items: 10,
                 size:  [3, 2, 0, 0] }

    end

    def series_tests(page, *expected)
      expected.each_with_index do |e, i|
        vars = instance_variable_get(:"@vars#{i}").merge(page: page)
        assert_equal e, Pagy.new(vars).series
      end
    end

    def test_page_1
      series_tests 1,
                   ["1", 2, 3, :gap],
                   ["1", 2, 3, :gap, 9, 10, 11],
                   ["1", 2, 3, :gap]
    end

    def test_page_2
      series_tests 2,
                   [1, "2", 3, 4, :gap],
                   [1, "2", 3, :gap, 9, 10, 11],
                   [1, "2", 3, :gap]
    end

    def test_page_3
      series_tests 3,
                   [1, 2, "3", 4, 5, :gap],
                   [1, 2, "3", :gap, 9, 10, 11],
                   [1, 2, "3", :gap]
    end

    def test_page_4
      series_tests 4,
                   [1, 2, 3, "4", 5, 6, :gap],
                   [1, 2, 3, "4", :gap, 9, 10, 11],
                   [1, 2, 3, "4", :gap]
    end

    def test_page_5
      series_tests 5,
                   [:gap, 3, 4, "5", 6, 7, :gap],
                   [1, 2, 3, 4, "5", :gap, 9, 10, 11],
                   [1, 2, 3, 4, "5", :gap]
    end

    def test_page_6
      series_tests 6,
                   [:gap, 4, 5, "6", 7, 8, :gap],
                   [1, 2, 3, :gap, "6", :gap, 9, 10, 11],
                   [1, 2, 3, 4, 5, "6", :gap]
    end

    def test_page_7
      series_tests 7,
                   [:gap, 5, 6, "7", 8, 9, :gap],
                   [1, 2, 3, :gap, "7", 8, 9, 10, 11],
                   [1, 2, 3, 4, 5, 6, "7", :gap]
    end

    def test_page_8
      series_tests 8,
                   [:gap, 6, 7, "8", 9, 10, 11],
                   [1, 2, 3, :gap, "8", 9, 10, 11],
                   [1, 2, 3, :gap, 6, 7, "8", :gap]
    end

    def test_page_9
      series_tests 9,
                   [:gap, 7, 8, "9", 10, 11],
                   [1, 2, 3, :gap, "9", 10, 11],
                   [1, 2, 3, :gap, 7, 8, "9", :gap]
    end

    def test_page_10
      series_tests 10,
                   [:gap, 8, 9, "10", 11],
                   [1, 2, 3, :gap, 9, "10", 11],
                   [1, 2, 3, :gap, 8, 9, "10", 11]
    end

    def test_page_11
      series_tests 11,
                   [:gap, 9, 10, "11"],
                   [1, 2, 3, :gap, 9, 10, "11"],
                   [1, 2, 3, :gap, 9, 10, "11"]
    end
  end

  # TODO: split these into #initialize or #series
  describe "metrics" do
    def setup
      @vars  = { items: 10, size: [3, 2, 2, 3] }
      @array = (1..103).to_a.extend(Pagy::Array::PageMethod)
    end

    def test_count_0
      pagy = Pagy.new @vars.merge(count: 0)
      assert_equal 1, pagy.pages
      assert_equal 1, pagy.last
      assert_equal 0, pagy.offset
      assert_equal 0, pagy.from
      assert_equal 0, pagy.to
      assert_nil pagy.prev
      assert_nil pagy.next
      assert_equal ["1"], pagy.series
    end

    def test_single_page
      pagy = Pagy.new @vars.merge(count: 8)
      assert_equal 1, pagy.pages
      assert_equal 1, pagy.last
      assert_equal 0, pagy.offset
      assert_equal 1, pagy.from
      assert_equal 8, pagy.to
      assert_nil pagy.prev
      assert_nil pagy.next
      assert_equal ["1"], pagy.series
    end

    def test_1_of_2_pages
      pagy = Pagy.new @vars.merge(count: 15)
      assert_equal 2, pagy.pages
      assert_equal 2, pagy.last
      assert_equal 0, pagy.offset
      assert_equal 1, pagy.from
      assert_equal 10, pagy.to
      assert_nil pagy.prev
      assert_equal 2, pagy.next
      assert_equal ["1", 2], pagy.series
    end

    def test_2_of_2_pages
      pagy = Pagy.new @vars.merge(count: 15, page: 2)
      assert_equal 2, pagy.pages
      assert_equal 2, pagy.last
      assert_equal 10, pagy.offset
      assert_equal 11, pagy.from
      assert_equal 15, pagy.to
      assert_equal 1, pagy.prev
      assert_nil pagy.next
      assert_equal [1, "2"], pagy.series
    end

    def test_page_1
      pagy, paged = @array.pagy(1, @vars)
      assert_equal (1..10).to_a, paged
      assert_instance_of Pagy, pagy
      assert_equal 1, pagy.from
      assert_equal 10, pagy.to
      assert_nil pagy.prev
      assert_equal 1, pagy.page
      assert_equal 2, pagy.next
      assert_equal ["1", 2, 3, :gap, 9, 10, 11], pagy.series
    end

    def test_page_2
      pagy, paged = @array.pagy(2, @vars)
      assert_equal (11..20).to_a, paged
      assert_instance_of Pagy, pagy
      assert_equal 11, pagy.from
      assert_equal 20, pagy.to
      assert_equal 1, pagy.prev
      assert_equal 2, pagy.page
      assert_equal 3, pagy.next
      assert_equal [1, "2", 3, 4, :gap, 9, 10, 11], pagy.series
    end

    def test_page_3
      pagy, paged = @array.pagy(3, @vars)
      assert_equal (21..30).to_a, paged
      assert_instance_of Pagy, pagy
      assert_equal 21, pagy.from
      assert_equal 30, pagy.to
      assert_equal 2, pagy.prev
      assert_equal 3, pagy.page
      assert_equal 4, pagy.next
      assert_equal [1, 2, "3", 4, 5, :gap, 9, 10, 11], pagy.series
    end

    def test_page_4
      pagy, paged = @array.pagy(4, @vars)
      assert_equal (31..40).to_a, paged
      assert_instance_of Pagy, pagy
      assert_equal 31, pagy.from
      assert_equal 40, pagy.to
      assert_equal 3, pagy.prev
      assert_equal 4, pagy.page
      assert_equal 5, pagy.next
      assert_equal [1, 2, 3, "4", 5, 6, :gap, 9, 10, 11], pagy.series
    end

    def test_page_5
      pagy, paged = @array.pagy(5, @vars)
      assert_equal (41..50).to_a, paged
      assert_instance_of Pagy, pagy
      assert_equal 41, pagy.from
      assert_equal 50, pagy.to
      assert_equal 4, pagy.prev
      assert_equal 5, pagy.page
      assert_equal 6, pagy.next
      assert_equal [1, 2, 3, 4, "5", 6, 7, 8, 9, 10, 11], pagy.series
    end

    def test_page_6
      pagy, paged = @array.pagy(6, @vars)
      assert_equal (51..60).to_a, paged
      assert_equal 51, pagy.from
      assert_equal 60, pagy.to
      assert_instance_of Pagy, pagy
      assert_equal 5, pagy.prev
      assert_equal 6, pagy.page
      assert_equal 7, pagy.next
      assert_equal [1, 2, 3, 4, 5, "6", 7, 8, 9, 10, 11], pagy.series
    end

    def test_page_7
      pagy, paged = @array.pagy(7, @vars)
      assert_equal (61..70).to_a, paged
      assert_instance_of Pagy, pagy
      assert_equal 61, pagy.from
      assert_equal 70, pagy.to
      assert_equal 6, pagy.prev
      assert_equal 7, pagy.page
      assert_equal 8, pagy.next
      assert_equal [1, 2, 3, 4, 5, 6, "7", 8, 9, 10, 11], pagy.series
    end

    def test_page_8
      pagy, paged = @array.pagy(8, @vars)
      assert_equal (71..80).to_a, paged
      assert_instance_of Pagy, pagy
      assert_equal 71, pagy.from
      assert_equal 80, pagy.to
      assert_equal 7, pagy.prev
      assert_equal 8, pagy.page
      assert_equal 9, pagy.next
      assert_equal [1, 2, 3, :gap, 6, 7, "8", 9, 10, 11], pagy.series
    end

    def test_page_9
      pagy, paged = @array.pagy(9, @vars)
      assert_equal (81..90).to_a, paged
      assert_instance_of Pagy, pagy
      assert_equal 81, pagy.from
      assert_equal 90, pagy.to
      assert_equal 8, pagy.prev
      assert_equal 9, pagy.page
      assert_equal 10, pagy.next
      assert_equal [1, 2, 3, :gap, 7, 8, "9", 10, 11], pagy.series
    end

    def test_page_10
      pagy, paged = @array.pagy(10, @vars)
      assert_equal (91..100).to_a, paged
      assert_instance_of Pagy, pagy
      assert_equal 91, pagy.from
      assert_equal 100, pagy.to
      assert_equal 9, pagy.prev
      assert_equal 10, pagy.page
      assert_equal 11, pagy.next
      assert_equal [1, 2, 3, :gap, 8, 9, "10", 11], pagy.series
    end

    def test_page_11
      pagy, paged = @array.pagy(11, @vars)
      assert_equal (101..103).to_a, paged
      assert_instance_of Pagy, pagy
      assert_equal 101, pagy.from
      assert_equal 103, pagy.to
      assert_equal 10, pagy.prev
      assert_equal 11, pagy.page
      assert_nil pagy.next
      assert_equal [1, 2, 3, :gap, 9, 10, "11"], pagy.series
    end

    def test_other_output
      pagy = Pagy.new @vars.merge(count: 103, page: 2)
      assert_equal 103, pagy.count
      assert_equal 10, pagy.items
      assert_equal 10, pagy.offset
      assert_equal 11, pagy.pages
      assert_equal 11, pagy.last
    end

    def test_initial_offset_page_1
      pagy = Pagy.new(count: 87, page: 1, outset: 10, items: 10)
      assert_equal 10, pagy.offset
      assert_equal 10, pagy.items
      assert_equal 1, pagy.from
      assert_equal 10, pagy.to
      assert_equal 9, pagy.pages
    end

    def test_initial_offset_page_9
      pagy = Pagy.new(count: 87, page: 9, outset: 10, items: 10)
      assert_equal 90, pagy.offset
      assert_equal 7, pagy.items
      assert_equal 81, pagy.from
      assert_equal 87, pagy.to
      assert_equal 9, pagy.pages
    end

    def test_items_of_last_page_of_one
      pagy = Pagy.new items: 10, count: 0
      assert_equal 0, pagy.items
      pagy = Pagy.new items: 10, count: 4
      assert_equal 4, pagy.items
      pagy = Pagy.new items: 10, count: 10
      assert_equal 10, pagy.items
    end

    def test_items_of_last_page_of_many
      pagy = Pagy.new items: 10, count: 14, page: 2
      assert_equal 4, pagy.items
      pagy = Pagy.new items: 10, count: 20, page: 2
      assert_equal 10, pagy.items
    end
  end
end
