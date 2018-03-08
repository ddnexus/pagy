require "test_helper"

class SeriesTest < Minitest::Test


  def setup

    @vars0 = { count:   103,
               items:   10,
               initial: 0,
               final:   0,
               before:  2,
               after:   2 }

    @vars1 = { count:   103,
               items:   10,
               initial: 3,
               final:   3,
               before:  0,
               after:   0 }

    @vars2 = { count:   103,
               items:   10,
               initial: 3,
               final:   0,
               before:  2,
               after:   0 }

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
