require_relative '../../test_helper'
require 'pagy/extras/bulma'

SingleCov.covered!(uncovered: 1) unless ENV['SKIP_SINGLECOV'] # undefined TRIM for compact helper, tested in trim_test

describe Pagy::Frontend do

  let(:frontend) { TestView.new }
  let(:pagy_test_id) { 'test-id' }

  describe '#pagy_bulma_nav' do

    before do
      @array = (1..103).to_a.extend(Pagy::Array::PageMethod)
    end

    it 'renders page 1' do
      pagy, _ = @array.pagy(1)
      frontend.pagy_bulma_nav(pagy).must_equal \
        '<nav class="pagy-bulma-nav pagination is-centered" role="navigation" aria-label="pagination">' \
          '<a class="pagination-previous" disabled>&lsaquo;&nbsp;Prev</a>' \
          '<a href="/foo?page=2"   rel="next" class="pagination-next" aria-label="next page">Next&nbsp;&rsaquo;</a>' \
          '<ul class="pagination-list">' \
            '<li><a href="/foo?page=1"   class="pagination-link is-current" aria-label="page 1" aria-current="page">1</a></li>' \
            '<li><a href="/foo?page=2"   rel="next" class="pagination-link" aria-label="goto page 2">2</a></li>' \
            '<li><a href="/foo?page=3"   class="pagination-link" aria-label="goto page 3">3</a></li>' \
            '<li><a href="/foo?page=4"   class="pagination-link" aria-label="goto page 4">4</a></li>' \
            '<li><a href="/foo?page=5"   class="pagination-link" aria-label="goto page 5">5</a></li>' \
            '<li><a href="/foo?page=6"   class="pagination-link" aria-label="goto page 6">6</a></li>' \
          '</ul>' \
        '</nav>'
    end

    it 'renders page 3' do
      pagy, _ = @array.pagy(3)
      frontend.pagy_bulma_nav(pagy).must_equal \
        '<nav class="pagy-bulma-nav pagination is-centered" role="navigation" aria-label="pagination">' \
          '<a href="/foo?page=2"   rel="prev" class="pagination-previous" aria-label="previous page">&lsaquo;&nbsp;Prev</a>' \
          '<a href="/foo?page=4"   rel="next" class="pagination-next" aria-label="next page">Next&nbsp;&rsaquo;</a>' \
          '<ul class="pagination-list">' \
            '<li><a href="/foo?page=1"   class="pagination-link" aria-label="goto page 1">1</a></li>' \
            '<li><a href="/foo?page=2"   rel="prev" class="pagination-link" aria-label="goto page 2">2</a></li>' \
            '<li><a href="/foo?page=3"   class="pagination-link is-current" aria-label="page 3" aria-current="page">3</a></li>' \
            '<li><a href="/foo?page=4"   rel="next" class="pagination-link" aria-label="goto page 4">4</a></li>' \
            '<li><a href="/foo?page=5"   class="pagination-link" aria-label="goto page 5">5</a></li>' \
            '<li><a href="/foo?page=6"   class="pagination-link" aria-label="goto page 6">6</a></li>' \
          '</ul>' \
        '</nav>'
    end


    it 'renders page 6' do
      pagy, _ = @array.pagy(6)
      frontend.pagy_bulma_nav(pagy).must_equal \
        '<nav class="pagy-bulma-nav pagination is-centered" role="navigation" aria-label="pagination">' \
          '<a href="/foo?page=5"   rel="prev" class="pagination-previous" aria-label="previous page">&lsaquo;&nbsp;Prev</a>' \
          '<a class="pagination-next" disabled>Next&nbsp;&rsaquo;</a>' \
          '<ul class="pagination-list">' \
            '<li><a href="/foo?page=1"   class="pagination-link" aria-label="goto page 1">1</a></li>' \
            '<li><a href="/foo?page=2"   class="pagination-link" aria-label="goto page 2">2</a></li>' \
            '<li><a href="/foo?page=3"   class="pagination-link" aria-label="goto page 3">3</a></li>' \
            '<li><a href="/foo?page=4"   class="pagination-link" aria-label="goto page 4">4</a></li>' \
            '<li><a href="/foo?page=5"   rel="prev" class="pagination-link" aria-label="goto page 5">5</a></li>' \
            '<li><a href="/foo?page=6"   class="pagination-link is-current" aria-label="page 6" aria-current="page">6</a></li>' \
          '</ul>' \
        '</nav>'
    end

    it 'renders page 10' do
      @array = (1..1000).to_a.extend(Pagy::Array::PageMethod)
      pagy, _ = @array.pagy(10)
      frontend.pagy_bulma_nav(pagy).must_equal \
        '<nav class="pagy-bulma-nav pagination is-centered" role="navigation" aria-label="pagination">' \
          '<a href="/foo?page=9"   rel="prev" class="pagination-previous" aria-label="previous page">&lsaquo;&nbsp;Prev</a>' \
          '<a href="/foo?page=11"   rel="next" class="pagination-next" aria-label="next page">Next&nbsp;&rsaquo;</a>' \
          '<ul class="pagination-list">' \
            '<li><a href="/foo?page=1"   class="pagination-link" aria-label="goto page 1">1</a></li>' \
            '<li><span class="pagination-ellipsis">&hellip;</span></li>' \
            '<li><a href="/foo?page=6"   class="pagination-link" aria-label="goto page 6">6</a></li>' \
            '<li><a href="/foo?page=7"   class="pagination-link" aria-label="goto page 7">7</a></li>' \
            '<li><a href="/foo?page=8"   class="pagination-link" aria-label="goto page 8">8</a></li>' \
            '<li><a href="/foo?page=9"   rel="prev" class="pagination-link" aria-label="goto page 9">9</a></li>' \
            '<li><a href="/foo?page=10"   class="pagination-link is-current" aria-label="page 10" aria-current="page">10</a></li>' \
            '<li><a href="/foo?page=11"   rel="next" class="pagination-link" aria-label="goto page 11">11</a></li>' \
            '<li><a href="/foo?page=12"   class="pagination-link" aria-label="goto page 12">12</a></li>' \
            '<li><a href="/foo?page=13"   class="pagination-link" aria-label="goto page 13">13</a></li>' \
            '<li><a href="/foo?page=14"   class="pagination-link" aria-label="goto page 14">14</a></li>' \
            '<li><span class="pagination-ellipsis">&hellip;</span></li>' \
            '<li><a href="/foo?page=50"   class="pagination-link" aria-label="goto page 50">50</a></li>' \
          '</ul>' \
        '</nav>'
    end

  end

  describe "#pagy_bulma_compact_nav" do

    before do
      @array = (1..103).to_a.extend(Pagy::Array::PageMethod)
    end

    it 'renders page 1 for bulma' do
      pagy, _  = @array.pagy(1)
      html = frontend.pagy_bulma_compact_nav(pagy, pagy_test_id)
      html.must_equal \
        "<nav id=\"test-id\" class=\"pagy-bulma-compact-nav\" role=\"navigation\" aria-label=\"pagination\"><a href=\"/foo?page=#{Pagy::Frontend::MARKER}\"   style=\"display: none;\"></a><div class=\"field is-grouped is-grouped-centered\" role=\"group\"><p class=\"control\"><a class=\"button\" disabled>&lsaquo;&nbsp;Prev</a></p><div class=\"pagy-compact-input control level is-mobile\">Page <input class=\"input\" type=\"number\" min=\"1\" max=\"6\" value=\"1\" style=\"padding: 0; text-align: center; width: 2rem; margin:0 0.3rem;\"> of 6</div><p class=\"control\"><a href=\"/foo?page=2\"   rel=\"next\" class=\"button\" aria-label=\"next page\">Next&nbsp;&rsaquo;</a></p></div></nav><script type=\"application/json\" class=\"pagy-json\">[\"compact\",\"test-id\",\"#{Pagy::Frontend::MARKER}\",1,false]</script>"
    end

    it 'renders page 3 for bulma' do
      pagy, _  = @array.pagy(3)
      html = frontend.pagy_bulma_compact_nav(pagy, pagy_test_id)
      html.must_equal \
        "<nav id=\"test-id\" class=\"pagy-bulma-compact-nav\" role=\"navigation\" aria-label=\"pagination\"><a href=\"/foo?page=#{Pagy::Frontend::MARKER}\"   style=\"display: none;\"></a><div class=\"field is-grouped is-grouped-centered\" role=\"group\"><p class=\"control\"><a href=\"/foo?page=2\"   rel=\"prev\" class=\"button\" aria-label=\"previous page\">&lsaquo;&nbsp;Prev</a></p><div class=\"pagy-compact-input control level is-mobile\">Page <input class=\"input\" type=\"number\" min=\"1\" max=\"6\" value=\"3\" style=\"padding: 0; text-align: center; width: 2rem; margin:0 0.3rem;\"> of 6</div><p class=\"control\"><a href=\"/foo?page=4\"   rel=\"next\" class=\"button\" aria-label=\"next page\">Next&nbsp;&rsaquo;</a></p></div></nav><script type=\"application/json\" class=\"pagy-json\">[\"compact\",\"test-id\",\"#{Pagy::Frontend::MARKER}\",3,false]</script>"
    end

    it 'renders page 6 for bulma' do
      pagy, _  = @array.pagy(6)
      html = frontend.pagy_bulma_compact_nav(pagy, pagy_test_id)
      html.must_equal \
        "<nav id=\"test-id\" class=\"pagy-bulma-compact-nav\" role=\"navigation\" aria-label=\"pagination\"><a href=\"/foo?page=#{Pagy::Frontend::MARKER}\"   style=\"display: none;\"></a><div class=\"field is-grouped is-grouped-centered\" role=\"group\"><p class=\"control\"><a href=\"/foo?page=5\"   rel=\"prev\" class=\"button\" aria-label=\"previous page\">&lsaquo;&nbsp;Prev</a></p><div class=\"pagy-compact-input control level is-mobile\">Page <input class=\"input\" type=\"number\" min=\"1\" max=\"6\" value=\"6\" style=\"padding: 0; text-align: center; width: 2rem; margin:0 0.3rem;\"> of 6</div><p class=\"control\"><a class=\"button\" disabled>Next&nbsp;&rsaquo;</a></p></div></nav><script type=\"application/json\" class=\"pagy-json\">[\"compact\",\"test-id\",\"#{Pagy::Frontend::MARKER}\",6,false]</script>"
    end

  end

  describe "#pagy_bulma_responsive_nav" do

    before do
      @array = (1..103).to_a.extend(Pagy::Array::PageMethod)
    end

    it 'renders page 1 for bulma' do
      pagy, _  = @array.pagy(1)
      html = frontend.pagy_bulma_responsive_nav(pagy, pagy_test_id)
      html.must_equal \
        "<nav id=\"test-id\" class=\"pagy-bulma-responsive-nav pagination is-centered\" role=\"navigation\" aria-label=\"pagination\"></nav><script type=\"application/json\" class=\"pagy-json\">[\"responsive\",\"test-id\",{\"before\":\"<a class=\\\"pagination-previous\\\" disabled>&lsaquo;&nbsp;Prev</a><a href=\\\"/foo?page=2\\\"   rel=\\\"next\\\" class=\\\"pagination-next\\\" aria-label=\\\"next page\\\">Next&nbsp;&rsaquo;</a><ul class=\\\"pagination-list\\\">\",\"1\":\"<li><a href=\\\"/foo?page=1\\\"   class=\\\"pagination-link is-current\\\" aria-current=\\\"page\\\" aria-label=\\\"page 1\\\">1</a></li>\",\"2\":\"<li><a href=\\\"/foo?page=2\\\"   rel=\\\"next\\\" class=\\\"pagination-link\\\" aria-label=\\\"goto page 2\\\">2</a></li>\",\"3\":\"<li><a href=\\\"/foo?page=3\\\"   class=\\\"pagination-link\\\" aria-label=\\\"goto page 3\\\">3</a></li>\",\"4\":\"<li><a href=\\\"/foo?page=4\\\"   class=\\\"pagination-link\\\" aria-label=\\\"goto page 4\\\">4</a></li>\",\"5\":\"<li><a href=\\\"/foo?page=5\\\"   class=\\\"pagination-link\\\" aria-label=\\\"goto page 5\\\">5</a></li>\",\"6\":\"<li><a href=\\\"/foo?page=6\\\"   class=\\\"pagination-link\\\" aria-label=\\\"goto page 6\\\">6</a></li>\",\"after\":\"</ul>\"},[0],{\"0\":[\"1\",2,3,4,5,6]}]</script>"
    end

    it 'renders page 3 for bulma' do
      pagy, _  = @array.pagy(3)
      html = frontend.pagy_bulma_responsive_nav(pagy, pagy_test_id)
      html.must_equal \
        "<nav id=\"test-id\" class=\"pagy-bulma-responsive-nav pagination is-centered\" role=\"navigation\" aria-label=\"pagination\"></nav><script type=\"application/json\" class=\"pagy-json\">[\"responsive\",\"test-id\",{\"before\":\"<a href=\\\"/foo?page=2\\\"   rel=\\\"prev\\\" class=\\\"pagination-previous\\\" aria-label=\\\"previous page\\\">&lsaquo;&nbsp;Prev</a><a href=\\\"/foo?page=4\\\"   rel=\\\"next\\\" class=\\\"pagination-next\\\" aria-label=\\\"next page\\\">Next&nbsp;&rsaquo;</a><ul class=\\\"pagination-list\\\">\",\"1\":\"<li><a href=\\\"/foo?page=1\\\"   class=\\\"pagination-link\\\" aria-label=\\\"goto page 1\\\">1</a></li>\",\"2\":\"<li><a href=\\\"/foo?page=2\\\"   rel=\\\"prev\\\" class=\\\"pagination-link\\\" aria-label=\\\"goto page 2\\\">2</a></li>\",\"3\":\"<li><a href=\\\"/foo?page=3\\\"   class=\\\"pagination-link is-current\\\" aria-current=\\\"page\\\" aria-label=\\\"page 3\\\">3</a></li>\",\"4\":\"<li><a href=\\\"/foo?page=4\\\"   rel=\\\"next\\\" class=\\\"pagination-link\\\" aria-label=\\\"goto page 4\\\">4</a></li>\",\"5\":\"<li><a href=\\\"/foo?page=5\\\"   class=\\\"pagination-link\\\" aria-label=\\\"goto page 5\\\">5</a></li>\",\"6\":\"<li><a href=\\\"/foo?page=6\\\"   class=\\\"pagination-link\\\" aria-label=\\\"goto page 6\\\">6</a></li>\",\"after\":\"</ul>\"},[0],{\"0\":[1,2,\"3\",4,5,6]}]</script>"
    end

    it 'renders page 6 for bulma' do
      pagy, _  = @array.pagy(6)
      html = frontend.pagy_bulma_responsive_nav(pagy, pagy_test_id)
      html.must_equal \
        "<nav id=\"test-id\" class=\"pagy-bulma-responsive-nav pagination is-centered\" role=\"navigation\" aria-label=\"pagination\"></nav><script type=\"application/json\" class=\"pagy-json\">[\"responsive\",\"test-id\",{\"before\":\"<a href=\\\"/foo?page=5\\\"   rel=\\\"prev\\\" class=\\\"pagination-previous\\\" aria-label=\\\"previous page\\\">&lsaquo;&nbsp;Prev</a><a class=\\\"pagination-next\\\" disabled>Next&nbsp;&rsaquo;</a><ul class=\\\"pagination-list\\\">\",\"1\":\"<li><a href=\\\"/foo?page=1\\\"   class=\\\"pagination-link\\\" aria-label=\\\"goto page 1\\\">1</a></li>\",\"2\":\"<li><a href=\\\"/foo?page=2\\\"   class=\\\"pagination-link\\\" aria-label=\\\"goto page 2\\\">2</a></li>\",\"3\":\"<li><a href=\\\"/foo?page=3\\\"   class=\\\"pagination-link\\\" aria-label=\\\"goto page 3\\\">3</a></li>\",\"4\":\"<li><a href=\\\"/foo?page=4\\\"   class=\\\"pagination-link\\\" aria-label=\\\"goto page 4\\\">4</a></li>\",\"5\":\"<li><a href=\\\"/foo?page=5\\\"   rel=\\\"prev\\\" class=\\\"pagination-link\\\" aria-label=\\\"goto page 5\\\">5</a></li>\",\"6\":\"<li><a href=\\\"/foo?page=6\\\"   class=\\\"pagination-link is-current\\\" aria-current=\\\"page\\\" aria-label=\\\"page 6\\\">6</a></li>\",\"after\":\"</ul>\"},[0],{\"0\":[1,2,3,4,5,\"6\"]}]</script>"
    end

    it 'renders page 10 for bulma' do
      @array   = (1..1000).to_a.extend(Pagy::Array::PageMethod)
      pagy, _  = @array.pagy(10)
      html = frontend.pagy_bulma_responsive_nav(pagy, pagy_test_id)
      html.must_equal \
        "<nav id=\"test-id\" class=\"pagy-bulma-responsive-nav pagination is-centered\" role=\"navigation\" aria-label=\"pagination\"></nav><script type=\"application/json\" class=\"pagy-json\">[\"responsive\",\"test-id\",{\"before\":\"<a href=\\\"/foo?page=9\\\"   rel=\\\"prev\\\" class=\\\"pagination-previous\\\" aria-label=\\\"previous page\\\">&lsaquo;&nbsp;Prev</a><a href=\\\"/foo?page=11\\\"   rel=\\\"next\\\" class=\\\"pagination-next\\\" aria-label=\\\"next page\\\">Next&nbsp;&rsaquo;</a><ul class=\\\"pagination-list\\\">\",\"1\":\"<li><a href=\\\"/foo?page=1\\\"   class=\\\"pagination-link\\\" aria-label=\\\"goto page 1\\\">1</a></li>\",\"gap\":\"<li><span class=\\\"pagination-ellipsis\\\">&hellip;</span></li>\",\"6\":\"<li><a href=\\\"/foo?page=6\\\"   class=\\\"pagination-link\\\" aria-label=\\\"goto page 6\\\">6</a></li>\",\"7\":\"<li><a href=\\\"/foo?page=7\\\"   class=\\\"pagination-link\\\" aria-label=\\\"goto page 7\\\">7</a></li>\",\"8\":\"<li><a href=\\\"/foo?page=8\\\"   class=\\\"pagination-link\\\" aria-label=\\\"goto page 8\\\">8</a></li>\",\"9\":\"<li><a href=\\\"/foo?page=9\\\"   rel=\\\"prev\\\" class=\\\"pagination-link\\\" aria-label=\\\"goto page 9\\\">9</a></li>\",\"10\":\"<li><a href=\\\"/foo?page=10\\\"   class=\\\"pagination-link is-current\\\" aria-current=\\\"page\\\" aria-label=\\\"page 10\\\">10</a></li>\",\"11\":\"<li><a href=\\\"/foo?page=11\\\"   rel=\\\"next\\\" class=\\\"pagination-link\\\" aria-label=\\\"goto page 11\\\">11</a></li>\",\"12\":\"<li><a href=\\\"/foo?page=12\\\"   class=\\\"pagination-link\\\" aria-label=\\\"goto page 12\\\">12</a></li>\",\"13\":\"<li><a href=\\\"/foo?page=13\\\"   class=\\\"pagination-link\\\" aria-label=\\\"goto page 13\\\">13</a></li>\",\"14\":\"<li><a href=\\\"/foo?page=14\\\"   class=\\\"pagination-link\\\" aria-label=\\\"goto page 14\\\">14</a></li>\",\"50\":\"<li><a href=\\\"/foo?page=50\\\"   class=\\\"pagination-link\\\" aria-label=\\\"goto page 50\\\">50</a></li>\",\"after\":\"</ul>\"},[0],{\"0\":[1,\"gap\",6,7,8,9,\"10\",11,12,13,14,\"gap\",50]}]</script>"
    end

  end

end
