require 'test_helper'
require 'rack'

class FrontendTest < Minitest::Test

  class TestView
    include Pagy::Frontend

    def request
      Rack::Request.new('SCRIPT_NAME' => '/foo')
    end
  end

  def setup
    @frontend = TestView.new
    @array = (1..103).to_a.extend(Pagy::Array::PageMethod)
  end

  def test_pagy_nav_page_1
    pagy, _ = @array.pagy(1)

    assert_equal(
      '<nav class="pagy-nav pagination" role="navigation" aria-label="pager">' \
      '<span class="page prev disabled">&lsaquo;&nbsp;Prev</span> ' \
      '<span class="page active">1</span> ' \
      '<span class="page"><a href="/foo?page=2" rel="next">2</a></span> ' \
      '<span class="page"><a href="/foo?page=3">3</a></span> ' \
      '<span class="page"><a href="/foo?page=4">4</a></span> ' \
      '<span class="page"><a href="/foo?page=5">5</a></span> ' \
      '<span class="page"><a href="/foo?page=6">6</a></span> ' \
      '<span class="page next"><a href="/foo?page=2" rel="next" aria-label="next">Next&nbsp;&rsaquo;</a></span>' \
      '</nav>',
      @frontend.pagy_nav(pagy)
    )
  end

  def test_pagy_nav_page_3
    pagy, _ = @array.pagy(3)

    assert_equal(
      '<nav class="pagy-nav pagination" role="navigation" aria-label="pager">' \
      '<span class="page prev"><a href="/foo?page=2" rel="prev" aria-label="previous">&lsaquo;&nbsp;Prev</a></span> ' \
      '<span class="page"><a href="/foo?page=1">1</a></span> ' \
      '<span class="page"><a href="/foo?page=2" rel="prev">2</a></span> ' \
      '<span class="page active">3</span> ' \
      '<span class="page"><a href="/foo?page=4" rel="next">4</a></span> ' \
      '<span class="page"><a href="/foo?page=5">5</a></span> ' \
      '<span class="page"><a href="/foo?page=6">6</a></span> ' \
      '<span class="page next"><a href="/foo?page=4" rel="next" aria-label="next">Next&nbsp;&rsaquo;</a></span>' \
      '</nav>',
      @frontend.pagy_nav(pagy)
    )
  end

  def test_pagy_nav_page_6
    pagy, _ = @array.pagy(6)

    assert_equal(
      '<nav class="pagy-nav pagination" role="navigation" aria-label="pager">' \
      '<span class="page prev"><a href="/foo?page=5" rel="prev" aria-label="previous">&lsaquo;&nbsp;Prev</a></span> ' \
      '<span class="page"><a href="/foo?page=1">1</a></span> ' \
      '<span class="page"><a href="/foo?page=2">2</a></span> ' \
      '<span class="page"><a href="/foo?page=3">3</a></span> ' \
      '<span class="page"><a href="/foo?page=4">4</a></span> ' \
      '<span class="page"><a href="/foo?page=5" rel="prev">5</a></span> ' \
      '<span class="page active">6</span> ' \
      '<span class="page next disabled">Next&nbsp;&rsaquo;</span>' \
      '</nav>',
      @frontend.pagy_nav(pagy)
    )
  end
end
