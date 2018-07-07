require_relative '../../test_helper'
require 'pagy/extras/bulma'

SingleCov.covered!

describe Pagy::Frontend do

  let(:frontend) { TestView.new }

  describe '#pagy_nav_bulma' do

    before do
      @array = (1..103).to_a.extend(Pagy::Array::PageMethod)
    end

    it 'renders page 1' do
      pagy, _ = @array.pagy(1)
      frontend.pagy_nav_bulma(pagy).must_equal \
        '<nav class="pagy-nav-bulma pagination is-centered" role="navigation" aria-label="pagination">' \
          '<a class="pagination-previous" disabled>&lsaquo;&nbsp;Prev</a>' \
          '<a href="/foo?page=2"   rel="next" class="pagination-next" aria-label="next page">Next&nbsp;&rsaquo;</a>' \
          '<ul class="pagination-list">' \
            '<li><a href="/foo?page=1"   class="pagination-link is-current" area-label="page 1" area-current="page">1</a></li>' \
            '<li><a href="/foo?page=2"   rel="next" class="pagination-link" area-label="goto page 2">2</a></li>' \
            '<li><a href="/foo?page=3"   class="pagination-link" area-label="goto page 3">3</a></li>' \
            '<li><a href="/foo?page=4"   class="pagination-link" area-label="goto page 4">4</a></li>' \
            '<li><a href="/foo?page=5"   class="pagination-link" area-label="goto page 5">5</a></li>' \
            '<li><a href="/foo?page=6"   class="pagination-link" area-label="goto page 6">6</a></li>' \
          '</ul>' \
        '</nav>'
    end

    it 'renders page 3' do
      pagy, _ = @array.pagy(3)
      frontend.pagy_nav_bulma(pagy).must_equal \
        '<nav class="pagy-nav-bulma pagination is-centered" role="navigation" aria-label="pagination">' \
          '<a href="/foo?page=2"   rel="prev" class="pagination-previous" aria-label="previous page">&lsaquo;&nbsp;Prev</a>' \
          '<a href="/foo?page=4"   rel="next" class="pagination-next" aria-label="next page">Next&nbsp;&rsaquo;</a>' \
          '<ul class="pagination-list">' \
            '<li><a href="/foo?page=1"   class="pagination-link" area-label="goto page 1">1</a></li>' \
            '<li><a href="/foo?page=2"   rel="prev" class="pagination-link" area-label="goto page 2">2</a></li>' \
            '<li><a href="/foo?page=3"   class="pagination-link is-current" area-label="page 3" area-current="page">3</a></li>' \
            '<li><a href="/foo?page=4"   rel="next" class="pagination-link" area-label="goto page 4">4</a></li>' \
            '<li><a href="/foo?page=5"   class="pagination-link" area-label="goto page 5">5</a></li>' \
            '<li><a href="/foo?page=6"   class="pagination-link" area-label="goto page 6">6</a></li>' \
          '</ul>' \
        '</nav>'
    end


    it 'renders page 6' do
      pagy, _ = @array.pagy(6)
      frontend.pagy_nav_bulma(pagy).must_equal \
        '<nav class="pagy-nav-bulma pagination is-centered" role="navigation" aria-label="pagination">' \
          '<a href="/foo?page=5"   rel="prev" class="pagination-previous" aria-label="previous page">&lsaquo;&nbsp;Prev</a>' \
          '<a class="pagination-next" disabled>Next&nbsp;&rsaquo;</a>' \
          '<ul class="pagination-list">' \
            '<li><a href="/foo?page=1"   class="pagination-link" area-label="goto page 1">1</a></li>' \
            '<li><a href="/foo?page=2"   class="pagination-link" area-label="goto page 2">2</a></li>' \
            '<li><a href="/foo?page=3"   class="pagination-link" area-label="goto page 3">3</a></li>' \
            '<li><a href="/foo?page=4"   class="pagination-link" area-label="goto page 4">4</a></li>' \
            '<li><a href="/foo?page=5"   rel="prev" class="pagination-link" area-label="goto page 5">5</a></li>' \
            '<li><a href="/foo?page=6"   class="pagination-link is-current" area-label="page 6" area-current="page">6</a></li>' \
          '</ul>' \
        '</nav>'
    end

    it 'renders page 10' do
      @array = (1..1000).to_a.extend(Pagy::Array::PageMethod)
      pagy, _ = @array.pagy(10)
      frontend.pagy_nav_bulma(pagy).must_equal \
        '<nav class="pagy-nav-bulma pagination is-centered" role="navigation" aria-label="pagination">' \
          '<a href="/foo?page=9"   rel="prev" class="pagination-previous" aria-label="previous page">&lsaquo;&nbsp;Prev</a>' \
          '<a href="/foo?page=11"   rel="next" class="pagination-next" aria-label="next page">Next&nbsp;&rsaquo;</a>' \
          '<ul class="pagination-list">' \
            '<li><a href="/foo?page=1"   class="pagination-link" area-label="goto page 1">1</a></li>' \
            '<li><span class="pagination-ellipsis">&hellip;</span></li>' \
            '<li><a href="/foo?page=6"   class="pagination-link" area-label="goto page 6">6</a></li>' \
            '<li><a href="/foo?page=7"   class="pagination-link" area-label="goto page 7">7</a></li>' \
            '<li><a href="/foo?page=8"   class="pagination-link" area-label="goto page 8">8</a></li>' \
            '<li><a href="/foo?page=9"   rel="prev" class="pagination-link" area-label="goto page 9">9</a></li>' \
            '<li><a href="/foo?page=10"   class="pagination-link is-current" area-label="page 10" area-current="page">10</a></li>' \
            '<li><a href="/foo?page=11"   rel="next" class="pagination-link" area-label="goto page 11">11</a></li>' \
            '<li><a href="/foo?page=12"   class="pagination-link" area-label="goto page 12">12</a></li>' \
            '<li><a href="/foo?page=13"   class="pagination-link" area-label="goto page 13">13</a></li>' \
            '<li><a href="/foo?page=14"   class="pagination-link" area-label="goto page 14">14</a></li>' \
            '<li><span class="pagination-ellipsis">&hellip;</span></li>' \
            '<li><a href="/foo?page=50"   class="pagination-link" area-label="goto page 50">50</a></li>' \
          '</ul>' \
        '</nav>'
    end

  end

end
