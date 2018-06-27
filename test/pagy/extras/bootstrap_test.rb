require_relative '../../test_helper'
require 'pagy/extras/bootstrap'

SingleCov.covered!

describe Pagy::Frontend do

  let(:frontend) { TestView.new }

  describe "#pagy_nav_bootstrap" do
    before do
      @array = (1..103).to_a.extend(Pagy::Array::PageMethod)
    end

    def test_pagy_nav_bootstrap_page_1
      pagy, _ = @array.pagy(1)

      assert_equal(
      '<nav class="pagy-nav-bootstrap pagination" role="navigation" aria-label="pager">' \
        '<ul class="pagination">' \
          '<li class="page-item prev disabled"><a href="#" class="page-link">&lsaquo;&nbsp;Prev</a></li>' \
           '<li class="page-item active"><a href="/foo?page=1"  class="page-link" >1</a></li>'\
           '<li class="page-item"><a href="/foo?page=2"  class="page-link" rel="next" >2</a></li>' \
           '<li class="page-item"><a href="/foo?page=3"  class="page-link" >3</a></li>' \
           '<li class="page-item"><a href="/foo?page=4"  class="page-link" >4</a></li>' \
           '<li class="page-item"><a href="/foo?page=5"  class="page-link" >5</a></li>' \
           '<li class="page-item"><a href="/foo?page=6"  class="page-link" >6</a></li>' \
           '<li class="page-item next"><a href="/foo?page=2"  class="page-link" rel="next" aria-label="next">Next&nbsp;&rsaquo;</a></li>' \
         '</ul>' \
      '</nav>',
      frontend.pagy_nav_bootstrap(pagy)
      )
    end

    def test_pagy_nav_bootstrap_page_3
      pagy, _ = @array.pagy(3)

      assert_equal(
      '<nav class="pagy-nav-bootstrap pagination" role="navigation" aria-label="pager">' \
        '<ul class="pagination">' \
          '<li class="page-item prev"><a href="/foo?page=2"  class="page-link" rel="prev" aria-label="previous">&lsaquo;&nbsp;Prev</a></li>' \
          '<li class="page-item"><a href="/foo?page=1"  class="page-link" >1</a></li>' \
          '<li class="page-item"><a href="/foo?page=2"  class="page-link" rel="prev" >2</a></li>' \
          '<li class="page-item active"><a href="/foo?page=3"  class="page-link" >3</a></li>' \
          '<li class="page-item"><a href="/foo?page=4"  class="page-link" rel="next" >4</a></li>' \
          '<li class="page-item"><a href="/foo?page=5"  class="page-link" >5</a></li>' \
          '<li class="page-item"><a href="/foo?page=6"  class="page-link" >6</a></li>' \
          '<li class="page-item next"><a href="/foo?page=4"  class="page-link" rel="next" aria-label="next">Next&nbsp;&rsaquo;</a></li>' \
        '</ul>' \
      '</nav>',
      frontend.pagy_nav_bootstrap(pagy)
      )
    end


    def test_pagy_nav_bootstrap_page_6
      pagy, _ = @array.pagy(6)

      assert_equal(
      '<nav class="pagy-nav-bootstrap pagination" role="navigation" aria-label="pager">' \
        '<ul class="pagination">' \
          '<li class="page-item prev"><a href="/foo?page=5"  class="page-link" rel="prev" aria-label="previous">&lsaquo;&nbsp;Prev</a></li>' \
          '<li class="page-item"><a href="/foo?page=1"  class="page-link" >1</a></li>' \
          '<li class="page-item"><a href="/foo?page=2"  class="page-link" >2</a></li>' \
          '<li class="page-item"><a href="/foo?page=3"  class="page-link" >3</a></li>' \
          '<li class="page-item"><a href="/foo?page=4"  class="page-link" >4</a></li>' \
          '<li class="page-item"><a href="/foo?page=5"  class="page-link" rel="prev" >5</a></li>' \
          '<li class="page-item active"><a href="/foo?page=6"  class="page-link" >6</a></li>' \
          '<li class="page-item next disabled"><a href="#" class="page-link">Next&nbsp;&rsaquo;</a></li>' \
        '</ul>' \
      '</nav>',
      frontend.pagy_nav_bootstrap(pagy)
      )
    end

    def test_pagy_nav_bootstrap_page_10
      @array = (1..1000).to_a.extend(Pagy::Array::PageMethod)
      pagy, _ = @array.pagy(10)

      assert_equal(
        '<nav class="pagy-nav-bootstrap pagination" role="navigation" aria-label="pager">' \
          '<ul class="pagination">' \
            '<li class="page-item prev"><a href="/foo?page=9"  class="page-link" rel="prev" aria-label="previous">&lsaquo;&nbsp;Prev</a></li>' \
            '<li class="page-item"><a href="/foo?page=1"  class="page-link" >1</a></li>' \
            '<li class="page-item gap disabled"><a href="#" class="page-link">&hellip;</a></li>' \
            '<li class="page-item"><a href="/foo?page=6"  class="page-link" >6</a></li>' \
            '<li class="page-item"><a href="/foo?page=7"  class="page-link" >7</a></li>' \
            '<li class="page-item"><a href="/foo?page=8"  class="page-link" >8</a></li>' \
            '<li class="page-item"><a href="/foo?page=9"  class="page-link" rel="prev" >9</a></li>' \
            '<li class="page-item active"><a href="/foo?page=10"  class="page-link" >10</a></li>' \
            '<li class="page-item"><a href="/foo?page=11"  class="page-link" rel="next" >11</a></li>' \
            '<li class="page-item"><a href="/foo?page=12"  class="page-link" >12</a></li>' \
            '<li class="page-item"><a href="/foo?page=13"  class="page-link" >13</a></li>' \
            '<li class="page-item"><a href="/foo?page=14"  class="page-link" >14</a></li>' \
            '<li class="page-item gap disabled"><a href="#" class="page-link">&hellip;</a></li>' \
            '<li class="page-item"><a href="/foo?page=50"  class="page-link" >50</a></li>' \
            '<li class="page-item next"><a href="/foo?page=11"  class="page-link" rel="next" aria-label="next">Next&nbsp;&rsaquo;</a></li>' \
          '</ul>' \
        '</nav>',
        frontend.pagy_nav_bootstrap(pagy)
      )
    end


  end
end
