require_relative '../../test_helper'
require 'pagy/extras/foundation'

SingleCov.covered!

describe Pagy::Frontend do

  let(:frontend) { TestView.new }

  describe "#pagy_nav_foundation" do

    before do
      @array = (1..103).to_a.extend(Pagy::Array::PageMethod)
    end

    it 'renders page 1' do
      pagy, _ = @array.pagy(1)
      frontend.pagy_nav_foundation(pagy).must_equal \
        '<nav class="pagy-nav-foundation" aria-label="Pagination">' \
          '<ul class="pagination">' \
            '<li class="prev disabled">&lsaquo;&nbsp;Prev</li>' \
            '<li class="current"><span class="show-for-sr">You\'re on page</span><a href="/foo?page=1"   >1</a></li>'\
            '<li><a href="/foo?page=2"   rel="next" >2</a></li>' \
            '<li><a href="/foo?page=3"   >3</a></li>' \
            '<li><a href="/foo?page=4"   >4</a></li>' \
            '<li><a href="/foo?page=5"   >5</a></li>' \
            '<li><a href="/foo?page=6"   >6</a></li>' \
            '<li class="next"><a href="/foo?page=2"   rel="next" aria-label="next">Next&nbsp;&rsaquo;</a></li>' \
          '</ul>' \
        '</nav>'
    end

    it 'renders page 3' do
      pagy, _ = @array.pagy(3)
      frontend.pagy_nav_foundation(pagy).must_equal \
      '<nav class="pagy-nav-foundation" aria-label="Pagination">' \
        '<ul class="pagination">' \
          '<li class="prev"><a href="/foo?page=2"   rel="prev" aria-label="previous">&lsaquo;&nbsp;Prev</a></li>' \
          '<li><a href="/foo?page=1"   >1</a></li>' \
          '<li><a href="/foo?page=2"   rel="prev" >2</a></li>' \
          '<li class="current"><span class="show-for-sr">You\'re on page</span><a href="/foo?page=3"   >3</a></li>' \
          '<li><a href="/foo?page=4"   rel="next" >4</a></li>' \
          '<li><a href="/foo?page=5"   >5</a></li>' \
          '<li><a href="/foo?page=6"   >6</a></li>' \
          '<li class="next"><a href="/foo?page=4"   rel="next" aria-label="next">Next&nbsp;&rsaquo;</a></li>' \
        '</ul>' \
      '</nav>'
    end

    it 'renders page 6' do
      pagy, _ = @array.pagy(6)
      frontend.pagy_nav_foundation(pagy).must_equal \
       '<nav class="pagy-nav-foundation" aria-label="Pagination">' \
        '<ul class="pagination">' \
          '<li class="prev"><a href="/foo?page=5"   rel="prev" aria-label="previous">&lsaquo;&nbsp;Prev</a></li>' \
          '<li><a href="/foo?page=1"   >1</a></li>' \
          '<li><a href="/foo?page=2"   >2</a></li>' \
          '<li><a href="/foo?page=3"   >3</a></li>' \
          '<li><a href="/foo?page=4"   >4</a></li>' \
          '<li><a href="/foo?page=5"   rel="prev" >5</a></li>' \
          '<li class="current"><span class="show-for-sr">You\'re on page</span><a href="/foo?page=6"   >6</a></li>' \
          '<li class="next disabled">Next&nbsp;&rsaquo;</li>' \
        '</ul>' \
      '</nav>'
    end

    it 'renders page 10' do
      @array = (1..1000).to_a.extend(Pagy::Array::PageMethod)
      pagy, _ = @array.pagy(10)
      frontend.pagy_nav_foundation(pagy).must_equal \
        '<nav class="pagy-nav-foundation" aria-label="Pagination">' \
          '<ul class="pagination">' \
            '<li class="prev"><a href="/foo?page=9"   rel="prev" aria-label="previous">&lsaquo;&nbsp;Prev</a></li>' \
            '<li><a href="/foo?page=1"   >1</a></li>' \
            '<li class="ellipsis" aria-hidden="true"></li><li><a href="/foo?page=6"   >6</a></li>' \
            '<li><a href="/foo?page=7"   >7</a></li>' \
            '<li><a href="/foo?page=8"   >8</a></li>' \
            '<li><a href="/foo?page=9"   rel="prev" >9</a></li>' \
            '<li class="current"><span class="show-for-sr">You\'re on page</span><a href="/foo?page=10"   >10</a></li>' \
            '<li><a href="/foo?page=11"   rel="next" >11</a></li>' \
            '<li><a href="/foo?page=12"   >12</a></li>' \
            '<li><a href="/foo?page=13"   >13</a></li>' \
            '<li><a href="/foo?page=14"   >14</a></li>' \
            '<li class="ellipsis" aria-hidden="true"></li>' \
            '<li><a href="/foo?page=50"   >50</a></li>' \
            '<li class="next"><a href="/foo?page=11"   rel="next" aria-label="next">Next&nbsp;&rsaquo;</a></li>' \
          '</ul>' \
        '</nav>'
    end

  end

end
