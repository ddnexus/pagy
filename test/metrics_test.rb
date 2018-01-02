require "test_helper"

class OutputTest < Minitest::Test

  def setup
    @options = { max_items_per_page: 10,
                 max_beginning_pages: 3,
                 max_ending_pages: 3,
                 max_before_pages: 2,
                 max_after_pages: 2 }
    @array   = (1..103).to_a.extend(Pagy::ArrayPageMethod)
  end

  def test_page_1
    paginated = @array.page(1, @options)
    assert_equal (1..10).to_a, paginated
    pagy = paginated.pagy
    content = Regexp.escape('x:10 page:1/11 pages:[][](1)[2-3]~[9-10-11] items:(1..10)/103')
    assert_match /#{content}/, pagy.inspect
    assert_instance_of Pagy, pagy
    assert_equal 1, pagy.from_item
    assert_equal 10, pagy.to_item
    assert pagy.first_page?
    assert_equal [], pagy.beginning_pages
    refute pagy.before_gap?
    assert_equal [], pagy.before_pages
    assert_nil pagy.previous_page
    assert_equal 1, pagy.page
    assert_equal 2, pagy.next_page
    assert_equal [2,3], pagy.after_pages
    assert pagy.after_gap?
    assert_equal [9,10,11], pagy.ending_pages
    refute pagy.last_page?
  end

  def test_page_2
    paginated = @array.page(2, @options)
    assert_equal (11..20).to_a, paginated
    pagy = paginated.pagy
    content = Regexp.escape('x:10 page:2/11 pages:[][1](2)[3-4]~[9-10-11] items:(11..20)/103')
    assert_match /#{content}/, pagy.inspect
    assert_instance_of Pagy, pagy
    assert_equal 11, pagy.from_item
    assert_equal 20, pagy.to_item
    refute pagy.first_page?
    assert_equal [], pagy.beginning_pages
    refute pagy.before_gap?
    assert_equal [1], pagy.before_pages
    assert_equal 1, pagy.previous_page
    assert_equal 2, pagy.page
    assert_equal 3, pagy.next_page
    assert_equal [3,4], pagy.after_pages
    assert pagy.after_gap?
    assert_equal [9,10,11], pagy.ending_pages
    refute pagy.last_page?
  end

  def test_page_3
    paginated = @array.page(3, @options)
    assert_equal (21..30).to_a, paginated
    pagy = paginated.pagy
    content = Regexp.escape('x:10 page:3/11 pages:[][1-2](3)[4-5]~[9-10-11] items:(21..30)/103')
    assert_match /#{content}/, pagy.inspect
    assert_instance_of Pagy, pagy
    assert_equal 21, pagy.from_item
    assert_equal 30, pagy.to_item
    refute pagy.first_page?
    assert_equal [], pagy.beginning_pages
    refute pagy.before_gap?
    assert_equal [1,2], pagy.before_pages
    assert_equal 2, pagy.previous_page
    assert_equal 3, pagy.page
    assert_equal 4, pagy.next_page
    assert_equal [4,5], pagy.after_pages
    assert pagy.after_gap?
    assert_equal [9,10,11], pagy.ending_pages
    refute pagy.last_page?
  end

  def test_page_4
    paginated = @array.page(4, @options)
    assert_equal (31..40).to_a, paginated
    pagy = paginated.pagy
    content = Regexp.escape('x:10 page:4/11 pages:[1][2-3](4)[5-6]~[9-10-11] items:(31..40)/103')
    assert_match /#{content}/, pagy.inspect
    assert_instance_of Pagy, pagy
    assert_equal 31, pagy.from_item
    assert_equal 40, pagy.to_item
    refute pagy.first_page?
    assert_equal [1], pagy.beginning_pages
    refute pagy.before_gap?
    assert_equal [2,3], pagy.before_pages
    assert_equal 3, pagy.previous_page
    assert_equal 4, pagy.page
    assert_equal 5, pagy.next_page
    assert_equal [5,6], pagy.after_pages
    assert pagy.after_gap?
    assert_equal [9,10,11], pagy.ending_pages
    refute pagy.last_page?
  end

  def test_page_5
    paginated = @array.page(5, @options)
    assert_equal (41..50).to_a, paginated
    pagy = paginated.pagy
    content = Regexp.escape('x:10 page:5/11 pages:[1-2][3-4](5)[6-7]~[9-10-11] items:(41..50)/103')
    assert_match /#{content}/, pagy.inspect
    assert_instance_of Pagy, pagy
    assert_equal 41, pagy.from_item
    assert_equal 50, pagy.to_item
    refute pagy.first_page?
    assert_equal [1,2], pagy.beginning_pages
    refute pagy.before_gap?
    assert_equal [3,4], pagy.before_pages
    assert_equal 4, pagy.previous_page
    assert_equal 5, pagy.page
    assert_equal 6, pagy.next_page
    assert_equal [6,7], pagy.after_pages
    assert pagy.after_gap?
    assert_equal [9,10,11], pagy.ending_pages
    refute pagy.last_page?
  end

  def test_page_6
    paginated = @array.page(6, @options)
    assert_equal (51..60).to_a, paginated
    pagy = paginated.pagy
    content = Regexp.escape('page:6/11 pages:[1-2-3][4-5](6)[7-8][9-10-11] items:(51..60)/103')
    assert_match /#{content}/, pagy.inspect
    assert_equal 51, pagy.from_item
    assert_equal 60, pagy.to_item
    refute pagy.first_page?
    assert_instance_of Pagy, pagy
    assert_equal [1,2,3], pagy.beginning_pages
    refute pagy.before_gap?
    assert_equal [4,5], pagy.before_pages
    assert_equal 5, pagy.previous_page
    assert_equal 6, pagy.page
    assert_equal 7, pagy.next_page
    assert_equal [7,8], pagy.after_pages
    refute pagy.after_gap?
    assert_equal [9,10,11], pagy.ending_pages
    refute pagy.last_page?
  end

  def test_page_7
    paginated = @array.page(7, @options)
    assert_equal (61..70).to_a, paginated
    pagy = paginated.pagy
    content = Regexp.escape('x:10 page:7/11 pages:[1-2-3]~[5-6](7)[8-9][10-11] items:(61..70)/103')
    assert_match /#{content}/, pagy.inspect
    assert_instance_of Pagy, pagy
    assert_equal 61, pagy.from_item
    assert_equal 70, pagy.to_item
    refute pagy.first_page?
    assert_equal [1,2,3], pagy.beginning_pages
    assert pagy.before_gap?
    assert_equal [5,6], pagy.before_pages
    assert_equal 6, pagy.previous_page
    assert_equal 7, pagy.page
    assert_equal 8, pagy.next_page
    assert_equal [8,9], pagy.after_pages
    refute pagy.after_gap?
    assert_equal [10,11], pagy.ending_pages
    refute pagy.last_page?
  end

  def test_page_8
    paginated = @array.page(8, @options)
    assert_equal (71..80).to_a, paginated
    pagy = paginated.pagy
    content = Regexp.escape('x:10 page:8/11 pages:[1-2-3]~[6-7](8)[9-10][11] items:(71..80)/103')
    assert_match /#{content}/, pagy.inspect
    assert_instance_of Pagy, pagy
    assert_equal 71, pagy.from_item
    assert_equal 80, pagy.to_item
    refute pagy.first_page?
    assert_equal [1,2,3], pagy.beginning_pages
    assert pagy.before_gap?
    assert_equal [6,7], pagy.before_pages
    assert_equal 7, pagy.previous_page
    assert_equal 8, pagy.page
    assert_equal 9, pagy.next_page
    assert_equal [9,10], pagy.after_pages
    refute pagy.after_gap?
    assert_equal [11], pagy.ending_pages
    refute pagy.last_page?
  end

  def test_page_9
    paginated = @array.page(9, @options)
    assert_equal (81..90).to_a, paginated
    pagy = paginated.pagy
    content = Regexp.escape('x:10 page:9/11 pages:[1-2-3]~[7-8](9)[10-11][] items:(81..90)/103')
    assert_match /#{content}/, pagy.inspect
    assert_instance_of Pagy, pagy
    assert_equal 81, pagy.from_item
    assert_equal 90, pagy.to_item
    refute pagy.first_page?
    assert_equal [1,2,3], pagy.beginning_pages
    assert pagy.before_gap?
    assert_equal [7,8], pagy.before_pages
    assert_equal 8, pagy.previous_page
    assert_equal 9, pagy.page
    assert_equal 10, pagy.next_page
    assert_equal [10,11], pagy.after_pages
    refute pagy.after_gap?
    assert_equal [], pagy.ending_pages
    refute pagy.last_page?
  end

  def test_page_10
    paginated = @array.page(10, @options)
    assert_equal (91..100).to_a, paginated
    pagy = paginated.pagy
    content = Regexp.escape('x:10 page:10/11 pages:[1-2-3]~[8-9](10)[11][] items:(91..100)/103')
    assert_match /#{content}/, pagy.inspect
    assert_instance_of Pagy, pagy
    assert_equal 91, pagy.from_item
    assert_equal 100, pagy.to_item
    refute pagy.first_page?
    assert_equal [1,2,3], pagy.beginning_pages
    assert pagy.before_gap?
    assert_equal [8,9], pagy.before_pages
    assert_equal 9, pagy.previous_page
    assert_equal 10, pagy.page
    assert_equal 11, pagy.next_page
    assert_equal [11], pagy.after_pages
    refute pagy.after_gap?
    assert_equal [], pagy.ending_pages
    refute pagy.last_page?
  end

  def test_page_11
    paginated = @array.page(11, @options)
    assert_equal (101..103).to_a, paginated
    pagy = paginated.pagy
    content = Regexp.escape('x:10 page:11/11 pages:[1-2-3]~[9-10](11)[][] items:(101..103)/103')
    assert_match /#{content}/, pagy.inspect
    assert_instance_of Pagy, pagy
    assert_equal 101, pagy.from_item
    assert_equal 103, pagy.to_item
    refute pagy.first_page?
    assert_equal [1,2,3], pagy.beginning_pages
    assert pagy.before_gap?
    assert_equal [9,10], pagy.before_pages
    assert_equal 10, pagy.previous_page
    assert_equal 11, pagy.page
    assert_nil pagy.next_page
    assert_equal [], pagy.after_pages
    refute pagy.after_gap?
    assert_equal [], pagy.ending_pages
    assert pagy.last_page?
  end

  def test_other_output
    pagy = Pagy.new 103, 2, @options
    assert_equal pagy.total_items, 103
    assert_equal pagy.max_items_per_page, 10
    assert_equal pagy.offset, 10
    assert_equal pagy.limit, pagy.max_items_per_page
    assert_equal pagy.total_pages, 11
    assert_equal pagy.first_page, 1
    assert_equal pagy.last_page, 11
  end

end




