require_relative '../../test_helper'
require 'pagy/extras/semantic'

SingleCov.covered!

describe Pagy::Frontend do

  let(:frontend) { TestView.new }

  describe "#pagy_nav_semantic" do

    before do
      @array = (1..103).to_a.extend(Pagy::Array::PageMethod)
    end

    it 'renders page 1' do
      pagy, _ = @array.pagy(1, link_extra: 'class="item"')
      frontend.pagy_nav_semantic(pagy).must_equal \
        "<div class=\"ui pagination menu\" aria-label=\"pager\"><div class=\"item disabled\"><i class=\"left small chevron icon\"></i></div> <a class=\"item active\">1</a> <a href=\"/foo?page=2\" class=\"item\"  rel=\"next\" >2</a> <a href=\"/foo?page=3\" class=\"item\"  >3</a> <a href=\"/foo?page=4\" class=\"item\"  >4</a> <a href=\"/foo?page=5\" class=\"item\"  >5</a> <a href=\"/foo?page=6\" class=\"item\"  >6</a> <a href=\"/foo?page=2\" class=\"item\"  rel=\"next\" aria-label=\"next\"><i class=\"right small chevron icon\"></i></a></div>"
    end

    it 'renders page 3' do
      pagy, _ = @array.pagy(3, link_extra: 'class="item"')
      frontend.pagy_nav_semantic(pagy).must_equal \
        "<div class=\"ui pagination menu\" aria-label=\"pager\"><a href=\"/foo?page=2\" class=\"item\"  rel=\"prev\" aria-label=\"previous\"><i class=\"left small chevron icon\"></i></a><a href=\"/foo?page=1\" class=\"item\"  >1</a> <a href=\"/foo?page=2\" class=\"item\"  rel=\"prev\" >2</a> <a class=\"item active\">3</a> <a href=\"/foo?page=4\" class=\"item\"  rel=\"next\" >4</a> <a href=\"/foo?page=5\" class=\"item\"  >5</a> <a href=\"/foo?page=6\" class=\"item\"  >6</a> <a href=\"/foo?page=4\" class=\"item\"  rel=\"next\" aria-label=\"next\"><i class=\"right small chevron icon\"></i></a></div>"
    end

    it 'renders page 6' do
      pagy, _ = @array.pagy(6, link_extra: 'class="item"')
      frontend.pagy_nav_semantic(pagy).must_equal \
        "<div class=\"ui pagination menu\" aria-label=\"pager\"><a href=\"/foo?page=5\" class=\"item\"  rel=\"prev\" aria-label=\"previous\"><i class=\"left small chevron icon\"></i></a><a href=\"/foo?page=1\" class=\"item\"  >1</a> <a href=\"/foo?page=2\" class=\"item\"  >2</a> <a href=\"/foo?page=3\" class=\"item\"  >3</a> <a href=\"/foo?page=4\" class=\"item\"  >4</a> <a href=\"/foo?page=5\" class=\"item\"  rel=\"prev\" >5</a> <a class=\"item active\">6</a> <div class=\"item disabled\"><i class=\"right small chevron icon\"></i></div></div>"
    end

    it 'renders page 10' do
      @array = (1..1000).to_a.extend(Pagy::Array::PageMethod)
      pagy, _ = @array.pagy(10, link_extra: 'class="item"')
      frontend.pagy_nav_semantic(pagy).must_equal \
        "<div class=\"ui pagination menu\" aria-label=\"pager\"><a href=\"/foo?page=9\" class=\"item\"  rel=\"prev\" aria-label=\"previous\"><i class=\"left small chevron icon\"></i></a><a href=\"/foo?page=1\" class=\"item\"  >1</a> <div class=\"disabled item\">...</div> <a href=\"/foo?page=6\" class=\"item\"  >6</a> <a href=\"/foo?page=7\" class=\"item\"  >7</a> <a href=\"/foo?page=8\" class=\"item\"  >8</a> <a href=\"/foo?page=9\" class=\"item\"  rel=\"prev\" >9</a> <a class=\"item active\">10</a> <a href=\"/foo?page=11\" class=\"item\"  rel=\"next\" >11</a> <a href=\"/foo?page=12\" class=\"item\"  >12</a> <a href=\"/foo?page=13\" class=\"item\"  >13</a> <a href=\"/foo?page=14\" class=\"item\"  >14</a> <div class=\"disabled item\">...</div> <a href=\"/foo?page=50\" class=\"item\"  >50</a> <a href=\"/foo?page=11\" class=\"item\"  rel=\"next\" aria-label=\"next\"><i class=\"right small chevron icon\"></i></a></div>"
    end

  end

end
