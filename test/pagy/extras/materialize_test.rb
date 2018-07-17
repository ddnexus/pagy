require_relative '../../test_helper'
require 'pagy/extras/materialize'

SingleCov.covered!

describe Pagy::Frontend do

  let(:frontend) { TestView.new }

  describe "#pagy_nav_materialize" do

    before do
      @array = (1..103).to_a.extend(Pagy::Array::PageMethod)
    end

    it 'renders page 1' do
      pagy, _ = @array.pagy(1)
      frontend.pagy_nav_materialize(pagy).must_equal \
        "<div class=\"pagy-nav-materialize pagination\" role=\"navigation\" aria-label=\"pager\"><ul class=\"pagination\"><li class=\"prev disabled\"><a href=\"#\"><i class=\"material-icons\">chevron_left</i></a></li><li class=\"active\"><a href=\"/foo?page=1\"   >1</a></li><li class=\"waves-effect\"><a href=\"/foo?page=2\"   rel=\"next\" >2</a></li><li class=\"waves-effect\"><a href=\"/foo?page=3\"   >3</a></li><li class=\"waves-effect\"><a href=\"/foo?page=4\"   >4</a></li><li class=\"waves-effect\"><a href=\"/foo?page=5\"   >5</a></li><li class=\"waves-effect\"><a href=\"/foo?page=6\"   >6</a></li><li class=\"waves-effect next\"><a href=\"/foo?page=2\"   rel=\"next\" aria-label=\"next\"><i class=\"material-icons\">chevron_right</i></a></li></ul></div>"
    end

    it 'renders page 3' do
      pagy, _ = @array.pagy(3)
      frontend.pagy_nav_materialize(pagy).must_equal \
        "<div class=\"pagy-nav-materialize pagination\" role=\"navigation\" aria-label=\"pager\"><ul class=\"pagination\"><li class=\"waves-effect prev\"><a href=\"/foo?page=2\"   rel=\"prev\" aria-label=\"previous\"><i class=\"material-icons\">chevron_left</i></a></li><li class=\"waves-effect\"><a href=\"/foo?page=1\"   >1</a></li><li class=\"waves-effect\"><a href=\"/foo?page=2\"   rel=\"prev\" >2</a></li><li class=\"active\"><a href=\"/foo?page=3\"   >3</a></li><li class=\"waves-effect\"><a href=\"/foo?page=4\"   rel=\"next\" >4</a></li><li class=\"waves-effect\"><a href=\"/foo?page=5\"   >5</a></li><li class=\"waves-effect\"><a href=\"/foo?page=6\"   >6</a></li><li class=\"waves-effect next\"><a href=\"/foo?page=4\"   rel=\"next\" aria-label=\"next\"><i class=\"material-icons\">chevron_right</i></a></li></ul></div>"
    end


    it 'renders page 6' do
      pagy, _ = @array.pagy(6)
      frontend.pagy_nav_materialize(pagy).must_equal \
        "<div class=\"pagy-nav-materialize pagination\" role=\"navigation\" aria-label=\"pager\"><ul class=\"pagination\"><li class=\"waves-effect prev\"><a href=\"/foo?page=5\"   rel=\"prev\" aria-label=\"previous\"><i class=\"material-icons\">chevron_left</i></a></li><li class=\"waves-effect\"><a href=\"/foo?page=1\"   >1</a></li><li class=\"waves-effect\"><a href=\"/foo?page=2\"   >2</a></li><li class=\"waves-effect\"><a href=\"/foo?page=3\"   >3</a></li><li class=\"waves-effect\"><a href=\"/foo?page=4\"   >4</a></li><li class=\"waves-effect\"><a href=\"/foo?page=5\"   rel=\"prev\" >5</a></li><li class=\"active\"><a href=\"/foo?page=6\"   >6</a></li><li class=\"next disabled\"><a href=\"#\"><i class=\"material-icons\">chevron_right</i></a></li></ul></div>"    end

    it 'renders page 10' do
      @array = (1..1000).to_a.extend(Pagy::Array::PageMethod)
      pagy, _ = @array.pagy(10)
      frontend.pagy_nav_materialize(pagy).must_equal \
        "<div class=\"pagy-nav-materialize pagination\" role=\"navigation\" aria-label=\"pager\"><ul class=\"pagination\"><li class=\"waves-effect prev\"><a href=\"/foo?page=9\"   rel=\"prev\" aria-label=\"previous\"><i class=\"material-icons\">chevron_left</i></a></li><li class=\"waves-effect\"><a href=\"/foo?page=1\"   >1</a></li><li class=\"gap disabled\"><a href=\"#\">&hellip;</a></li><li class=\"waves-effect\"><a href=\"/foo?page=6\"   >6</a></li><li class=\"waves-effect\"><a href=\"/foo?page=7\"   >7</a></li><li class=\"waves-effect\"><a href=\"/foo?page=8\"   >8</a></li><li class=\"waves-effect\"><a href=\"/foo?page=9\"   rel=\"prev\" >9</a></li><li class=\"active\"><a href=\"/foo?page=10\"   >10</a></li><li class=\"waves-effect\"><a href=\"/foo?page=11\"   rel=\"next\" >11</a></li><li class=\"waves-effect\"><a href=\"/foo?page=12\"   >12</a></li><li class=\"waves-effect\"><a href=\"/foo?page=13\"   >13</a></li><li class=\"waves-effect\"><a href=\"/foo?page=14\"   >14</a></li><li class=\"gap disabled\"><a href=\"#\">&hellip;</a></li><li class=\"waves-effect\"><a href=\"/foo?page=50\"   >50</a></li><li class=\"waves-effect next\"><a href=\"/foo?page=11\"   rel=\"next\" aria-label=\"next\"><i class=\"material-icons\">chevron_right</i></a></li></ul></div>"
    end

  end

end
