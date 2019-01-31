require_relative '../../test_helper'
require 'pagy/extras/plain'

SingleCov.covered!(uncovered: 1) unless ENV['SKIP_SINGLECOV'] # undefined TRIM for compact helper, tested in trim_test

describe Pagy::Frontend do

  let(:frontend) { TestView.new }
  let(:pagy_test_id) { 'test-id' }

  describe "#pagy_plain_compact_nav" do

    before do
      @array = (1..103).to_a.extend(Pagy::Array::PageMethod)
    end

    it 'renders page 1' do
      pagy, _  = @array.pagy(1)
      html = frontend.pagy_plain_compact_nav(pagy, pagy_test_id)
      html.must_equal \
        "<nav id=\"test-id\" class=\"pagy-plain-compact-nav pagination\" role=\"navigation\" aria-label=\"pager\"><a href=\"/foo?page=#{Pagy::Frontend::MARKER}\"   style=\"display: none;\" ></a><span class=\"page prev disabled\">&lsaquo;&nbsp;Prev</span> <span class=\"pagy-compact-input\" style=\"margin: 0 0.6rem;\">Page <input type=\"number\" min=\"1\" max=\"6\" value=\"1\" style=\"padding: 0; text-align: center; width: 2rem;\"> of 6</span> <span class=\"page next\"><a href=\"/foo?page=2\"   rel=\"next\" aria-label=\"next\">Next&nbsp;&rsaquo;</a></span></nav><script type=\"application/json\" class=\"pagy-json\">[\"compact\",\"test-id\",\"#{Pagy::Frontend::MARKER}\",1,false]</script>"
    end

    it 'renders page 3' do
      pagy, _  = @array.pagy(3)
      html = frontend.pagy_plain_compact_nav(pagy, pagy_test_id)
      html.must_equal \
        "<nav id=\"test-id\" class=\"pagy-plain-compact-nav pagination\" role=\"navigation\" aria-label=\"pager\"><a href=\"/foo?page=#{Pagy::Frontend::MARKER}\"   style=\"display: none;\" ></a><span class=\"page prev\"><a href=\"/foo?page=2\"   rel=\"prev\" aria-label=\"previous\">&lsaquo;&nbsp;Prev</a></span> <span class=\"pagy-compact-input\" style=\"margin: 0 0.6rem;\">Page <input type=\"number\" min=\"1\" max=\"6\" value=\"3\" style=\"padding: 0; text-align: center; width: 2rem;\"> of 6</span> <span class=\"page next\"><a href=\"/foo?page=4\"   rel=\"next\" aria-label=\"next\">Next&nbsp;&rsaquo;</a></span></nav><script type=\"application/json\" class=\"pagy-json\">[\"compact\",\"test-id\",\"#{Pagy::Frontend::MARKER}\",3,false]</script>"
    end

    it 'renders page 6' do
      pagy, _  = @array.pagy(6)
      html = frontend.pagy_plain_compact_nav(pagy, pagy_test_id)
      html.must_equal \
        "<nav id=\"test-id\" class=\"pagy-plain-compact-nav pagination\" role=\"navigation\" aria-label=\"pager\"><a href=\"/foo?page=#{Pagy::Frontend::MARKER}\"   style=\"display: none;\" ></a><span class=\"page prev\"><a href=\"/foo?page=5\"   rel=\"prev\" aria-label=\"previous\">&lsaquo;&nbsp;Prev</a></span> <span class=\"pagy-compact-input\" style=\"margin: 0 0.6rem;\">Page <input type=\"number\" min=\"1\" max=\"6\" value=\"6\" style=\"padding: 0; text-align: center; width: 2rem;\"> of 6</span> <span class=\"page next disabled\">Next&nbsp;&rsaquo;</span></nav><script type=\"application/json\" class=\"pagy-json\">[\"compact\",\"test-id\",\"#{Pagy::Frontend::MARKER}\",6,false]</script>"
    end

  end

  describe "#pagy_plain_responsive_nav" do

    before do
      @array = (1..103).to_a.extend(Pagy::Array::PageMethod)
    end

    it 'renders page 1' do
      pagy, _  = @array.pagy(1)
      html = frontend.pagy_plain_responsive_nav(pagy, pagy_test_id)
      html.must_equal \
        "<nav id=\"test-id\" class=\"pagy-plain-responsive-nav pagination\" role=\"navigation\" aria-label=\"pager\"></nav><script type=\"application/json\" class=\"pagy-json\">[\"responsive\",\"test-id\",{\"before\":\"<span class=\\\"page prev disabled\\\">&lsaquo;&nbsp;Prev</span> \",\"1\":\"<span class=\\\"page active\\\">1</span> \",\"2\":\"<span class=\\\"page\\\"><a href=\\\"/foo?page=2\\\"   rel=\\\"next\\\" >2</a></span> \",\"3\":\"<span class=\\\"page\\\"><a href=\\\"/foo?page=3\\\"   >3</a></span> \",\"4\":\"<span class=\\\"page\\\"><a href=\\\"/foo?page=4\\\"   >4</a></span> \",\"5\":\"<span class=\\\"page\\\"><a href=\\\"/foo?page=5\\\"   >5</a></span> \",\"6\":\"<span class=\\\"page\\\"><a href=\\\"/foo?page=6\\\"   >6</a></span> \",\"after\":\"<span class=\\\"page next\\\"><a href=\\\"/foo?page=2\\\"   rel=\\\"next\\\" aria-label=\\\"next\\\">Next&nbsp;&rsaquo;</a></span>\"},[0],{\"0\":[\"1\",2,3,4,5,6]}]</script>"
    end

    it 'renders page 3' do
      pagy, _  = @array.pagy(3)
      html = frontend.pagy_plain_responsive_nav(pagy, pagy_test_id)
      html.must_equal \
        "<nav id=\"test-id\" class=\"pagy-plain-responsive-nav pagination\" role=\"navigation\" aria-label=\"pager\"></nav><script type=\"application/json\" class=\"pagy-json\">[\"responsive\",\"test-id\",{\"before\":\"<span class=\\\"page prev\\\"><a href=\\\"/foo?page=2\\\"   rel=\\\"prev\\\" aria-label=\\\"previous\\\">&lsaquo;&nbsp;Prev</a></span> \",\"1\":\"<span class=\\\"page\\\"><a href=\\\"/foo?page=1\\\"   >1</a></span> \",\"2\":\"<span class=\\\"page\\\"><a href=\\\"/foo?page=2\\\"   rel=\\\"prev\\\" >2</a></span> \",\"3\":\"<span class=\\\"page active\\\">3</span> \",\"4\":\"<span class=\\\"page\\\"><a href=\\\"/foo?page=4\\\"   rel=\\\"next\\\" >4</a></span> \",\"5\":\"<span class=\\\"page\\\"><a href=\\\"/foo?page=5\\\"   >5</a></span> \",\"6\":\"<span class=\\\"page\\\"><a href=\\\"/foo?page=6\\\"   >6</a></span> \",\"after\":\"<span class=\\\"page next\\\"><a href=\\\"/foo?page=4\\\"   rel=\\\"next\\\" aria-label=\\\"next\\\">Next&nbsp;&rsaquo;</a></span>\"},[0],{\"0\":[1,2,\"3\",4,5,6]}]</script>"
    end

    it 'renders page 6' do
      pagy, _ = @array.pagy(6)
      html = frontend.pagy_plain_responsive_nav(pagy, pagy_test_id)
      html.must_equal \
        "<nav id=\"test-id\" class=\"pagy-plain-responsive-nav pagination\" role=\"navigation\" aria-label=\"pager\"></nav><script type=\"application/json\" class=\"pagy-json\">[\"responsive\",\"test-id\",{\"before\":\"<span class=\\\"page prev\\\"><a href=\\\"/foo?page=5\\\"   rel=\\\"prev\\\" aria-label=\\\"previous\\\">&lsaquo;&nbsp;Prev</a></span> \",\"1\":\"<span class=\\\"page\\\"><a href=\\\"/foo?page=1\\\"   >1</a></span> \",\"2\":\"<span class=\\\"page\\\"><a href=\\\"/foo?page=2\\\"   >2</a></span> \",\"3\":\"<span class=\\\"page\\\"><a href=\\\"/foo?page=3\\\"   >3</a></span> \",\"4\":\"<span class=\\\"page\\\"><a href=\\\"/foo?page=4\\\"   >4</a></span> \",\"5\":\"<span class=\\\"page\\\"><a href=\\\"/foo?page=5\\\"   rel=\\\"prev\\\" >5</a></span> \",\"6\":\"<span class=\\\"page active\\\">6</span> \",\"after\":\"<span class=\\\"page next disabled\\\">Next&nbsp;&rsaquo;</span>\"},[0],{\"0\":[1,2,3,4,5,\"6\"]}]</script>"    end

    it 'renders page 10' do
      @array   = (1..1000).to_a.extend(Pagy::Array::PageMethod)
      pagy, _  = @array.pagy(10)
      html = frontend.pagy_plain_responsive_nav(pagy, pagy_test_id)
      html.must_equal \
        "<nav id=\"test-id\" class=\"pagy-plain-responsive-nav pagination\" role=\"navigation\" aria-label=\"pager\"></nav><script type=\"application/json\" class=\"pagy-json\">[\"responsive\",\"test-id\",{\"before\":\"<span class=\\\"page prev\\\"><a href=\\\"/foo?page=9\\\"   rel=\\\"prev\\\" aria-label=\\\"previous\\\">&lsaquo;&nbsp;Prev</a></span> \",\"1\":\"<span class=\\\"page\\\"><a href=\\\"/foo?page=1\\\"   >1</a></span> \",\"gap\":\"<span class=\\\"page gap\\\">&hellip;</span> \",\"6\":\"<span class=\\\"page\\\"><a href=\\\"/foo?page=6\\\"   >6</a></span> \",\"7\":\"<span class=\\\"page\\\"><a href=\\\"/foo?page=7\\\"   >7</a></span> \",\"8\":\"<span class=\\\"page\\\"><a href=\\\"/foo?page=8\\\"   >8</a></span> \",\"9\":\"<span class=\\\"page\\\"><a href=\\\"/foo?page=9\\\"   rel=\\\"prev\\\" >9</a></span> \",\"10\":\"<span class=\\\"page active\\\">10</span> \",\"11\":\"<span class=\\\"page\\\"><a href=\\\"/foo?page=11\\\"   rel=\\\"next\\\" >11</a></span> \",\"12\":\"<span class=\\\"page\\\"><a href=\\\"/foo?page=12\\\"   >12</a></span> \",\"13\":\"<span class=\\\"page\\\"><a href=\\\"/foo?page=13\\\"   >13</a></span> \",\"14\":\"<span class=\\\"page\\\"><a href=\\\"/foo?page=14\\\"   >14</a></span> \",\"50\":\"<span class=\\\"page\\\"><a href=\\\"/foo?page=50\\\"   >50</a></span> \",\"after\":\"<span class=\\\"page next\\\"><a href=\\\"/foo?page=11\\\"   rel=\\\"next\\\" aria-label=\\\"next\\\">Next&nbsp;&rsaquo;</a></span>\"},[0],{\"0\":[1,\"gap\",6,7,8,9,\"10\",11,12,13,14,\"gap\",50]}]</script>"
    end

  end

end
