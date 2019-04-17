# encoding: utf-8
# frozen_string_literal: true

require_relative '../../test_helper'
require 'pagy/extras/bootstrap'

describe Pagy::Frontend do

  let(:frontend) { TestView.new }
  let(:pagy_test_id) { 'test-id' }

  describe "#pagy_bootstrap_nav" do

    it 'renders first page' do
      pagy = Pagy.new(count: 1000, page: 1)
      frontend.pagy_bootstrap_nav(pagy).must_equal \
        "<nav class=\"pagy-bootstrap-nav pagination\" role=\"navigation\" aria-label=\"pager\"><ul class=\"pagination\"><li class=\"page-item prev disabled\"><a href=\"#\" class=\"page-link\">&lsaquo;&nbsp;Prev</a></li><li class=\"page-item active\"><a href=\"/foo?page=1\"  class=\"page-link\" >1</a></li><li class=\"page-item\"><a href=\"/foo?page=2\"  class=\"page-link\" rel=\"next\" >2</a></li><li class=\"page-item\"><a href=\"/foo?page=3\"  class=\"page-link\" >3</a></li><li class=\"page-item\"><a href=\"/foo?page=4\"  class=\"page-link\" >4</a></li><li class=\"page-item\"><a href=\"/foo?page=5\"  class=\"page-link\" >5</a></li><li class=\"page-item gap disabled\"><a href=\"#\" class=\"page-link\">&hellip;</a></li><li class=\"page-item\"><a href=\"/foo?page=50\"  class=\"page-link\" >50</a></li><li class=\"page-item next\"><a href=\"/foo?page=2\"  class=\"page-link\" rel=\"next\" aria-label=\"next\">Next&nbsp;&rsaquo;</a></li></ul></nav>"
    end

    it 'renders intermediate page' do
      pagy = Pagy.new(count: 1000, page: 20)
      frontend.pagy_bootstrap_nav(pagy).must_equal \
        "<nav class=\"pagy-bootstrap-nav pagination\" role=\"navigation\" aria-label=\"pager\"><ul class=\"pagination\"><li class=\"page-item prev\"><a href=\"/foo?page=19\"  class=\"page-link\" rel=\"prev\" aria-label=\"previous\">&lsaquo;&nbsp;Prev</a></li><li class=\"page-item\"><a href=\"/foo?page=1\"  class=\"page-link\" >1</a></li><li class=\"page-item gap disabled\"><a href=\"#\" class=\"page-link\">&hellip;</a></li><li class=\"page-item\"><a href=\"/foo?page=16\"  class=\"page-link\" >16</a></li><li class=\"page-item\"><a href=\"/foo?page=17\"  class=\"page-link\" >17</a></li><li class=\"page-item\"><a href=\"/foo?page=18\"  class=\"page-link\" >18</a></li><li class=\"page-item\"><a href=\"/foo?page=19\"  class=\"page-link\" rel=\"prev\" >19</a></li><li class=\"page-item active\"><a href=\"/foo?page=20\"  class=\"page-link\" >20</a></li><li class=\"page-item\"><a href=\"/foo?page=21\"  class=\"page-link\" rel=\"next\" >21</a></li><li class=\"page-item\"><a href=\"/foo?page=22\"  class=\"page-link\" >22</a></li><li class=\"page-item\"><a href=\"/foo?page=23\"  class=\"page-link\" >23</a></li><li class=\"page-item\"><a href=\"/foo?page=24\"  class=\"page-link\" >24</a></li><li class=\"page-item gap disabled\"><a href=\"#\" class=\"page-link\">&hellip;</a></li><li class=\"page-item\"><a href=\"/foo?page=50\"  class=\"page-link\" >50</a></li><li class=\"page-item next\"><a href=\"/foo?page=21\"  class=\"page-link\" rel=\"next\" aria-label=\"next\">Next&nbsp;&rsaquo;</a></li></ul></nav>"
    end

    it 'renders last page' do
      pagy = Pagy.new(count: 1000, page: 50)
      frontend.pagy_bootstrap_nav(pagy).must_equal \
        "<nav class=\"pagy-bootstrap-nav pagination\" role=\"navigation\" aria-label=\"pager\"><ul class=\"pagination\"><li class=\"page-item prev\"><a href=\"/foo?page=49\"  class=\"page-link\" rel=\"prev\" aria-label=\"previous\">&lsaquo;&nbsp;Prev</a></li><li class=\"page-item\"><a href=\"/foo?page=1\"  class=\"page-link\" >1</a></li><li class=\"page-item gap disabled\"><a href=\"#\" class=\"page-link\">&hellip;</a></li><li class=\"page-item\"><a href=\"/foo?page=46\"  class=\"page-link\" >46</a></li><li class=\"page-item\"><a href=\"/foo?page=47\"  class=\"page-link\" >47</a></li><li class=\"page-item\"><a href=\"/foo?page=48\"  class=\"page-link\" >48</a></li><li class=\"page-item\"><a href=\"/foo?page=49\"  class=\"page-link\" rel=\"prev\" >49</a></li><li class=\"page-item active\"><a href=\"/foo?page=50\"  class=\"page-link\" >50</a></li><li class=\"page-item next disabled\"><a href=\"#\" class=\"page-link\">Next&nbsp;&rsaquo;</a></li></ul></nav>"
    end

  end

  describe "#pagy_bootstrap_nav_js" do

    it 'renders first page' do
      pagy = Pagy.new(count: 1000, page: 1)
      html = frontend.pagy_bootstrap_nav_js(pagy, pagy_test_id)
      html.must_equal \
        "<nav id=\"test-id\" class=\"pagy-bootstrap-nav-js pagination\" role=\"navigation\" aria-label=\"pager\"></nav><script type=\"application/json\" class=\"pagy-json\">[\"nav\",\"test-id\",\"#{Pagy::Frontend::MARKER}\",{\"before\":\"<ul class=\\\"pagination\\\"><li class=\\\"page-item prev disabled\\\"><a href=\\\"#\\\" class=\\\"page-link\\\">&lsaquo;&nbsp;Prev</a></li>\",\"link\":\"<li class=\\\"page-item\\\"><a href=\\\"/foo?page=#{Pagy::Frontend::MARKER}\\\"  class=\\\"page-link\\\" >#{Pagy::Frontend::MARKER}</a></li>\",\"active\":\"<li class=\\\"page-item active\\\"><a href=\\\"/foo?page=#{Pagy::Frontend::MARKER}\\\"  class=\\\"page-link\\\" >#{Pagy::Frontend::MARKER}</a></li>\",\"gap\":\"<li class=\\\"page-item gap disabled\\\"><a href=\\\"#\\\" class=\\\"page-link\\\">&hellip;</a></li>\",\"after\":\"<li class=\\\"page-item next\\\"><a href=\\\"/foo?page=2\\\"  class=\\\"page-link\\\" rel=\\\"next\\\" aria-label=\\\"next\\\">Next&nbsp;&rsaquo;</a></li></ul>\"},{\"0\":[\"1\",2,3,4,5,\"gap\",50]}]</script>"
    end

    it 'renders intermediate page' do
      pagy = Pagy.new(count: 1000, page: 20)
      html = frontend.pagy_bootstrap_nav_js(pagy, pagy_test_id)
      html.must_equal \
        "<nav id=\"test-id\" class=\"pagy-bootstrap-nav-js pagination\" role=\"navigation\" aria-label=\"pager\"></nav><script type=\"application/json\" class=\"pagy-json\">[\"nav\",\"test-id\",\"#{Pagy::Frontend::MARKER}\",{\"before\":\"<ul class=\\\"pagination\\\"><li class=\\\"page-item prev\\\"><a href=\\\"/foo?page=19\\\"  class=\\\"page-link\\\" rel=\\\"prev\\\" aria-label=\\\"previous\\\">&lsaquo;&nbsp;Prev</a></li>\",\"link\":\"<li class=\\\"page-item\\\"><a href=\\\"/foo?page=#{Pagy::Frontend::MARKER}\\\"  class=\\\"page-link\\\" >#{Pagy::Frontend::MARKER}</a></li>\",\"active\":\"<li class=\\\"page-item active\\\"><a href=\\\"/foo?page=#{Pagy::Frontend::MARKER}\\\"  class=\\\"page-link\\\" >#{Pagy::Frontend::MARKER}</a></li>\",\"gap\":\"<li class=\\\"page-item gap disabled\\\"><a href=\\\"#\\\" class=\\\"page-link\\\">&hellip;</a></li>\",\"after\":\"<li class=\\\"page-item next\\\"><a href=\\\"/foo?page=21\\\"  class=\\\"page-link\\\" rel=\\\"next\\\" aria-label=\\\"next\\\">Next&nbsp;&rsaquo;</a></li></ul>\"},{\"0\":[1,\"gap\",16,17,18,19,\"20\",21,22,23,24,\"gap\",50]}]</script>"
    end

    it 'renders last page' do
      pagy = Pagy.new(count: 1000, page: 50)
      html = frontend.pagy_bootstrap_nav_js(pagy, pagy_test_id)
      html.must_equal \
        "<nav id=\"test-id\" class=\"pagy-bootstrap-nav-js pagination\" role=\"navigation\" aria-label=\"pager\"></nav><script type=\"application/json\" class=\"pagy-json\">[\"nav\",\"test-id\",\"#{Pagy::Frontend::MARKER}\",{\"before\":\"<ul class=\\\"pagination\\\"><li class=\\\"page-item prev\\\"><a href=\\\"/foo?page=49\\\"  class=\\\"page-link\\\" rel=\\\"prev\\\" aria-label=\\\"previous\\\">&lsaquo;&nbsp;Prev</a></li>\",\"link\":\"<li class=\\\"page-item\\\"><a href=\\\"/foo?page=#{Pagy::Frontend::MARKER}\\\"  class=\\\"page-link\\\" >#{Pagy::Frontend::MARKER}</a></li>\",\"active\":\"<li class=\\\"page-item active\\\"><a href=\\\"/foo?page=#{Pagy::Frontend::MARKER}\\\"  class=\\\"page-link\\\" >#{Pagy::Frontend::MARKER}</a></li>\",\"gap\":\"<li class=\\\"page-item gap disabled\\\"><a href=\\\"#\\\" class=\\\"page-link\\\">&hellip;</a></li>\",\"after\":\"<li class=\\\"page-item next disabled\\\"><a href=\\\"#\\\" class=\\\"page-link\\\">Next&nbsp;&rsaquo;</a></li></ul>\"},{\"0\":[1,\"gap\",46,47,48,49,\"50\"]}]</script>"
    end

    it 'renders with :steps' do
      pagy = Pagy.new(count: 1000, page: 20, steps: {0 => [1,2,2,1], 500 => [2,3,3,2]})
      html = frontend.pagy_bootstrap_nav_js(pagy, pagy_test_id)
      html.must_equal \
        "<nav id=\"test-id\" class=\"pagy-bootstrap-nav-js pagination\" role=\"navigation\" aria-label=\"pager\"></nav><script type=\"application/json\" class=\"pagy-json\">[\"nav\",\"test-id\",\"#{Pagy::Frontend::MARKER}\",{\"before\":\"<ul class=\\\"pagination\\\"><li class=\\\"page-item prev\\\"><a href=\\\"/foo?page=19\\\"  class=\\\"page-link\\\" rel=\\\"prev\\\" aria-label=\\\"previous\\\">&lsaquo;&nbsp;Prev</a></li>\",\"link\":\"<li class=\\\"page-item\\\"><a href=\\\"/foo?page=#{Pagy::Frontend::MARKER}\\\"  class=\\\"page-link\\\" >#{Pagy::Frontend::MARKER}</a></li>\",\"active\":\"<li class=\\\"page-item active\\\"><a href=\\\"/foo?page=#{Pagy::Frontend::MARKER}\\\"  class=\\\"page-link\\\" >#{Pagy::Frontend::MARKER}</a></li>\",\"gap\":\"<li class=\\\"page-item gap disabled\\\"><a href=\\\"#\\\" class=\\\"page-link\\\">&hellip;</a></li>\",\"after\":\"<li class=\\\"page-item next\\\"><a href=\\\"/foo?page=21\\\"  class=\\\"page-link\\\" rel=\\\"next\\\" aria-label=\\\"next\\\">Next&nbsp;&rsaquo;</a></li></ul>\"},{\"0\":[1,\"gap\",18,19,\"20\",21,22,\"gap\",50],\"500\":[1,2,\"gap\",17,18,19,\"20\",21,22,23,\"gap\",49,50]}]</script>"
    end

  end

  describe "#pagy_bootstrap_combo_nav_js" do

    it 'renders first page' do
      pagy = Pagy.new(count: 103, page: 1)
      html = frontend.pagy_bootstrap_combo_nav_js(pagy, pagy_test_id)
      html.must_equal \
        "<nav id=\"test-id\" class=\"pagy-bootstrap-combo-nav-js pagination\" role=\"navigation\" aria-label=\"pager\"><a href=\"/foo?page=#{Pagy::Frontend::MARKER}\"   style=\"display: none;\" ></a><div class=\"btn-group\" role=\"group\"><a class=\"prev btn btn-primary disabled\" href=\"#\">&lsaquo;&nbsp;Prev</a><div class=\"pagy-compact-input btn btn-primary disabled\" style=\"white-space: nowrap;\">Page <input type=\"number\" min=\"1\" max=\"6\" value=\"1\" class=\"text-primary\" style=\"padding: 0; border: none; text-align: center; width: 2rem;\"> of 6</div><a href=\"/foo?page=2\"   rel=\"next\" aria-label=\"next\" class=\"next btn btn-primary\">Next&nbsp;&rsaquo;</a></div></nav><script type=\"application/json\" class=\"pagy-json\">[\"combo_nav\",\"test-id\",\"#{Pagy::Frontend::MARKER}\",1,false]</script>"
    end

    it 'renders intermediate page' do
      pagy = Pagy.new(count: 103, page: 3)
      html = frontend.pagy_bootstrap_combo_nav_js(pagy, pagy_test_id)
      html.must_equal \
        "<nav id=\"test-id\" class=\"pagy-bootstrap-combo-nav-js pagination\" role=\"navigation\" aria-label=\"pager\"><a href=\"/foo?page=#{Pagy::Frontend::MARKER}\"   style=\"display: none;\" ></a><div class=\"btn-group\" role=\"group\"><a href=\"/foo?page=2\"   rel=\"prev\" aria-label=\"previous\" class=\"prev btn btn-primary\">&lsaquo;&nbsp;Prev</a><div class=\"pagy-compact-input btn btn-primary disabled\" style=\"white-space: nowrap;\">Page <input type=\"number\" min=\"1\" max=\"6\" value=\"3\" class=\"text-primary\" style=\"padding: 0; border: none; text-align: center; width: 2rem;\"> of 6</div><a href=\"/foo?page=4\"   rel=\"next\" aria-label=\"next\" class=\"next btn btn-primary\">Next&nbsp;&rsaquo;</a></div></nav><script type=\"application/json\" class=\"pagy-json\">[\"combo_nav\",\"test-id\",\"#{Pagy::Frontend::MARKER}\",3,false]</script>"
    end

    it 'renders last page' do
      pagy = Pagy.new(count: 103, page: 6)
      html = frontend.pagy_bootstrap_combo_nav_js(pagy, pagy_test_id)
      html.must_equal \
        "<nav id=\"test-id\" class=\"pagy-bootstrap-combo-nav-js pagination\" role=\"navigation\" aria-label=\"pager\"><a href=\"/foo?page=#{Pagy::Frontend::MARKER}\"   style=\"display: none;\" ></a><div class=\"btn-group\" role=\"group\"><a href=\"/foo?page=5\"   rel=\"prev\" aria-label=\"previous\" class=\"prev btn btn-primary\">&lsaquo;&nbsp;Prev</a><div class=\"pagy-compact-input btn btn-primary disabled\" style=\"white-space: nowrap;\">Page <input type=\"number\" min=\"1\" max=\"6\" value=\"6\" class=\"text-primary\" style=\"padding: 0; border: none; text-align: center; width: 2rem;\"> of 6</div><a class=\"next btn btn-primary disabled\" href=\"#\">Next&nbsp;&rsaquo;</a></div></nav><script type=\"application/json\" class=\"pagy-json\">[\"combo_nav\",\"test-id\",\"#{Pagy::Frontend::MARKER}\",6,false]</script>"
    end

  end

end
