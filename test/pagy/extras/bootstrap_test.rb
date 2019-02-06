# encoding: utf-8
# frozen_string_literal: true

require_relative '../../test_helper'
require 'pagy/extras/bootstrap'

SingleCov.covered!(uncovered: 1) unless ENV['SKIP_SINGLECOV'] # undefined TRIM for compact helper, tested in trim_test

describe Pagy::Frontend do

  let(:frontend) { TestView.new }
  let(:pagy_test_id) { 'test-id' }

  describe "#pagy_bootstrap_nav" do

    before do
      @array = (1..103).to_a.extend(Pagy::Array::PageMethod)
    end

    it 'renders page 1' do
      pagy, _ = @array.pagy(1)
      frontend.pagy_bootstrap_nav(pagy).must_equal \
        '<nav class="pagy-bootstrap-nav pagination" role="navigation" aria-label="pager">' \
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
        '</nav>'
    end

    it 'renders page 3' do
      pagy, _ = @array.pagy(3)
      frontend.pagy_bootstrap_nav(pagy).must_equal \
      '<nav class="pagy-bootstrap-nav pagination" role="navigation" aria-label="pager">' \
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
      '</nav>'
    end


    it 'renders page 6' do
      pagy, _ = @array.pagy(6)
      frontend.pagy_bootstrap_nav(pagy).must_equal \
       '<nav class="pagy-bootstrap-nav pagination" role="navigation" aria-label="pager">' \
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
      '</nav>'
    end

    it 'renders page 10' do
      @array = (1..1000).to_a.extend(Pagy::Array::PageMethod)
      pagy, _ = @array.pagy(10)
      frontend.pagy_bootstrap_nav(pagy).must_equal \
        '<nav class="pagy-bootstrap-nav pagination" role="navigation" aria-label="pager">' \
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
        '</nav>'
    end

  end

  describe "#pagy_bootstrap_compact_nav" do

    before do
      @array = (1..103).to_a.extend(Pagy::Array::PageMethod)
    end

    it 'renders page 1 for bootstrap' do
      pagy, _  = @array.pagy(1)
      html = frontend.pagy_bootstrap_compact_nav(pagy, pagy_test_id)
      html.must_equal \
        "<nav id=\"test-id\" class=\"pagy-bootstrap-compact-nav pagination\" role=\"navigation\" aria-label=\"pager\"><a href=\"/foo?page=#{Pagy::Frontend::MARKER}\"   style=\"display: none;\" ></a><div class=\"btn-group\" role=\"group\"><a class=\"prev btn btn-primary disabled\" href=\"#\">&lsaquo;&nbsp;Prev</a><div class=\"pagy-compact-input btn btn-primary disabled\">Page <input type=\"number\" min=\"1\" max=\"6\" value=\"1\" class=\"text-primary\" style=\"padding: 0; border: none; text-align: center; width: 2rem;\"> of 6</div><a href=\"/foo?page=2\"   rel=\"next\" aria-label=\"next\" class=\"next btn btn-primary\">Next&nbsp;&rsaquo;</a></div></nav><script type=\"application/json\" class=\"pagy-json\">[\"compact\",\"test-id\",\"#{Pagy::Frontend::MARKER}\",1,false]</script>"
    end

    it 'renders page 3 for bootstrap' do
      pagy, _  = @array.pagy(3)
      html = frontend.pagy_bootstrap_compact_nav(pagy, pagy_test_id)
      html.must_equal \
        "<nav id=\"test-id\" class=\"pagy-bootstrap-compact-nav pagination\" role=\"navigation\" aria-label=\"pager\"><a href=\"/foo?page=#{Pagy::Frontend::MARKER}\"   style=\"display: none;\" ></a><div class=\"btn-group\" role=\"group\"><a href=\"/foo?page=2\"   rel=\"prev\" aria-label=\"previous\" class=\"prev btn btn-primary\">&lsaquo;&nbsp;Prev</a><div class=\"pagy-compact-input btn btn-primary disabled\">Page <input type=\"number\" min=\"1\" max=\"6\" value=\"3\" class=\"text-primary\" style=\"padding: 0; border: none; text-align: center; width: 2rem;\"> of 6</div><a href=\"/foo?page=4\"   rel=\"next\" aria-label=\"next\" class=\"next btn btn-primary\">Next&nbsp;&rsaquo;</a></div></nav><script type=\"application/json\" class=\"pagy-json\">[\"compact\",\"test-id\",\"#{Pagy::Frontend::MARKER}\",3,false]</script>"
    end

    it 'renders page 6 for bootstrap' do
      pagy, _  = @array.pagy(6)
      html = frontend.pagy_bootstrap_compact_nav(pagy, pagy_test_id)
      html.must_equal \
        "<nav id=\"test-id\" class=\"pagy-bootstrap-compact-nav pagination\" role=\"navigation\" aria-label=\"pager\"><a href=\"/foo?page=#{Pagy::Frontend::MARKER}\"   style=\"display: none;\" ></a><div class=\"btn-group\" role=\"group\"><a href=\"/foo?page=5\"   rel=\"prev\" aria-label=\"previous\" class=\"prev btn btn-primary\">&lsaquo;&nbsp;Prev</a><div class=\"pagy-compact-input btn btn-primary disabled\">Page <input type=\"number\" min=\"1\" max=\"6\" value=\"6\" class=\"text-primary\" style=\"padding: 0; border: none; text-align: center; width: 2rem;\"> of 6</div><a class=\"next btn btn-primary disabled\" href=\"#\">Next&nbsp;&rsaquo;</a></div></nav><script type=\"application/json\" class=\"pagy-json\">[\"compact\",\"test-id\",\"#{Pagy::Frontend::MARKER}\",6,false]</script>"
    end

  end

  describe "#pagy_bootstrap_responsive_nav" do

    before do
      @array = (1..103).to_a.extend(Pagy::Array::PageMethod)
    end

    it 'renders page 1 for bootstrap' do
      pagy, _  = @array.pagy(1)
      html = frontend.pagy_bootstrap_responsive_nav(pagy, pagy_test_id)
      html.must_equal \
        "<nav id=\"test-id\" class=\"pagy-bootstrap-responsive-nav pagination\" role=\"navigation\" aria-label=\"pager\"></nav><script type=\"application/json\" class=\"pagy-json\">[\"responsive\",\"test-id\",{\"before\":\"<ul class=\\\"pagination\\\"><li class=\\\"page-item prev disabled\\\"><a href=\\\"#\\\" class=\\\"page-link\\\">&lsaquo;&nbsp;Prev</a></li>\",\"1\":\"<li class=\\\"page-item active\\\"><a href=\\\"/foo?page=1\\\"  class=\\\"page-link\\\" >1</a></li>\",\"2\":\"<li class=\\\"page-item\\\"><a href=\\\"/foo?page=2\\\"  class=\\\"page-link\\\" rel=\\\"next\\\" >2</a></li>\",\"3\":\"<li class=\\\"page-item\\\"><a href=\\\"/foo?page=3\\\"  class=\\\"page-link\\\" >3</a></li>\",\"4\":\"<li class=\\\"page-item\\\"><a href=\\\"/foo?page=4\\\"  class=\\\"page-link\\\" >4</a></li>\",\"5\":\"<li class=\\\"page-item\\\"><a href=\\\"/foo?page=5\\\"  class=\\\"page-link\\\" >5</a></li>\",\"6\":\"<li class=\\\"page-item\\\"><a href=\\\"/foo?page=6\\\"  class=\\\"page-link\\\" >6</a></li>\",\"after\":\"<li class=\\\"page-item next\\\"><a href=\\\"/foo?page=2\\\"  class=\\\"page-link\\\" rel=\\\"next\\\" aria-label=\\\"next\\\">Next&nbsp;&rsaquo;</a></li></ul>\"},[0],{\"0\":[\"1\",2,3,4,5,6]}]</script>"
    end

    it 'renders page 3 for bootstrap' do
      pagy, _  = @array.pagy(3)
      html = frontend.pagy_bootstrap_responsive_nav(pagy, pagy_test_id)
      html.must_equal \
        "<nav id=\"test-id\" class=\"pagy-bootstrap-responsive-nav pagination\" role=\"navigation\" aria-label=\"pager\"></nav><script type=\"application/json\" class=\"pagy-json\">[\"responsive\",\"test-id\",{\"before\":\"<ul class=\\\"pagination\\\"><li class=\\\"page-item prev\\\"><a href=\\\"/foo?page=2\\\"  class=\\\"page-link\\\" rel=\\\"prev\\\" aria-label=\\\"previous\\\">&lsaquo;&nbsp;Prev</a></li>\",\"1\":\"<li class=\\\"page-item\\\"><a href=\\\"/foo?page=1\\\"  class=\\\"page-link\\\" >1</a></li>\",\"2\":\"<li class=\\\"page-item\\\"><a href=\\\"/foo?page=2\\\"  class=\\\"page-link\\\" rel=\\\"prev\\\" >2</a></li>\",\"3\":\"<li class=\\\"page-item active\\\"><a href=\\\"/foo?page=3\\\"  class=\\\"page-link\\\" >3</a></li>\",\"4\":\"<li class=\\\"page-item\\\"><a href=\\\"/foo?page=4\\\"  class=\\\"page-link\\\" rel=\\\"next\\\" >4</a></li>\",\"5\":\"<li class=\\\"page-item\\\"><a href=\\\"/foo?page=5\\\"  class=\\\"page-link\\\" >5</a></li>\",\"6\":\"<li class=\\\"page-item\\\"><a href=\\\"/foo?page=6\\\"  class=\\\"page-link\\\" >6</a></li>\",\"after\":\"<li class=\\\"page-item next\\\"><a href=\\\"/foo?page=4\\\"  class=\\\"page-link\\\" rel=\\\"next\\\" aria-label=\\\"next\\\">Next&nbsp;&rsaquo;</a></li></ul>\"},[0],{\"0\":[1,2,\"3\",4,5,6]}]</script>"
    end

    it 'renders page 6 for bootstrap' do
      pagy, _  = @array.pagy(6)
      html = frontend.pagy_bootstrap_responsive_nav(pagy, pagy_test_id)
      html.must_equal \
        "<nav id=\"test-id\" class=\"pagy-bootstrap-responsive-nav pagination\" role=\"navigation\" aria-label=\"pager\"></nav><script type=\"application/json\" class=\"pagy-json\">[\"responsive\",\"test-id\",{\"before\":\"<ul class=\\\"pagination\\\"><li class=\\\"page-item prev\\\"><a href=\\\"/foo?page=5\\\"  class=\\\"page-link\\\" rel=\\\"prev\\\" aria-label=\\\"previous\\\">&lsaquo;&nbsp;Prev</a></li>\",\"1\":\"<li class=\\\"page-item\\\"><a href=\\\"/foo?page=1\\\"  class=\\\"page-link\\\" >1</a></li>\",\"2\":\"<li class=\\\"page-item\\\"><a href=\\\"/foo?page=2\\\"  class=\\\"page-link\\\" >2</a></li>\",\"3\":\"<li class=\\\"page-item\\\"><a href=\\\"/foo?page=3\\\"  class=\\\"page-link\\\" >3</a></li>\",\"4\":\"<li class=\\\"page-item\\\"><a href=\\\"/foo?page=4\\\"  class=\\\"page-link\\\" >4</a></li>\",\"5\":\"<li class=\\\"page-item\\\"><a href=\\\"/foo?page=5\\\"  class=\\\"page-link\\\" rel=\\\"prev\\\" >5</a></li>\",\"6\":\"<li class=\\\"page-item active\\\"><a href=\\\"/foo?page=6\\\"  class=\\\"page-link\\\" >6</a></li>\",\"after\":\"<li class=\\\"page-item next disabled\\\"><a href=\\\"#\\\" class=\\\"page-link\\\">Next&nbsp;&rsaquo;</a></li></ul>\"},[0],{\"0\":[1,2,3,4,5,\"6\"]}]</script>"
    end

    it 'renders page 10 for bootstrap' do
      @array   = (1..1000).to_a.extend(Pagy::Array::PageMethod)
      pagy, _  = @array.pagy(10)
      html = frontend.pagy_bootstrap_responsive_nav(pagy, pagy_test_id)
      html.must_equal \
        "<nav id=\"test-id\" class=\"pagy-bootstrap-responsive-nav pagination\" role=\"navigation\" aria-label=\"pager\"></nav><script type=\"application/json\" class=\"pagy-json\">[\"responsive\",\"test-id\",{\"before\":\"<ul class=\\\"pagination\\\"><li class=\\\"page-item prev\\\"><a href=\\\"/foo?page=9\\\"  class=\\\"page-link\\\" rel=\\\"prev\\\" aria-label=\\\"previous\\\">&lsaquo;&nbsp;Prev</a></li>\",\"1\":\"<li class=\\\"page-item\\\"><a href=\\\"/foo?page=1\\\"  class=\\\"page-link\\\" >1</a></li>\",\"gap\":\"<li class=\\\"page-item gap disabled\\\"><a href=\\\"#\\\" class=\\\"page-link\\\">&hellip;</a></li>\",\"6\":\"<li class=\\\"page-item\\\"><a href=\\\"/foo?page=6\\\"  class=\\\"page-link\\\" >6</a></li>\",\"7\":\"<li class=\\\"page-item\\\"><a href=\\\"/foo?page=7\\\"  class=\\\"page-link\\\" >7</a></li>\",\"8\":\"<li class=\\\"page-item\\\"><a href=\\\"/foo?page=8\\\"  class=\\\"page-link\\\" >8</a></li>\",\"9\":\"<li class=\\\"page-item\\\"><a href=\\\"/foo?page=9\\\"  class=\\\"page-link\\\" rel=\\\"prev\\\" >9</a></li>\",\"10\":\"<li class=\\\"page-item active\\\"><a href=\\\"/foo?page=10\\\"  class=\\\"page-link\\\" >10</a></li>\",\"11\":\"<li class=\\\"page-item\\\"><a href=\\\"/foo?page=11\\\"  class=\\\"page-link\\\" rel=\\\"next\\\" >11</a></li>\",\"12\":\"<li class=\\\"page-item\\\"><a href=\\\"/foo?page=12\\\"  class=\\\"page-link\\\" >12</a></li>\",\"13\":\"<li class=\\\"page-item\\\"><a href=\\\"/foo?page=13\\\"  class=\\\"page-link\\\" >13</a></li>\",\"14\":\"<li class=\\\"page-item\\\"><a href=\\\"/foo?page=14\\\"  class=\\\"page-link\\\" >14</a></li>\",\"50\":\"<li class=\\\"page-item\\\"><a href=\\\"/foo?page=50\\\"  class=\\\"page-link\\\" >50</a></li>\",\"after\":\"<li class=\\\"page-item next\\\"><a href=\\\"/foo?page=11\\\"  class=\\\"page-link\\\" rel=\\\"next\\\" aria-label=\\\"next\\\">Next&nbsp;&rsaquo;</a></li></ul>\"},[0],{\"0\":[1,\"gap\",6,7,8,9,\"10\",11,12,13,14,\"gap\",50]}]</script>"
    end

  end

end
