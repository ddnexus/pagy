# encoding: utf-8
# frozen_string_literal: true

require_relative '../../test_helper'
require 'pagy/extras/navs'
require 'pagy/extras/trim'

SingleCov.covered! unless ENV['SKIP_SINGLECOV']

describe Pagy::Frontend do

  let(:frontend) { TestView.new }
  let(:pagy_test_id) { 'test-id' }

  describe "#pagy_trim_url" do

    it 'trims urls' do
      frontend.send(:pagy_trim_url, 'foo/bar?page=1', 'page=1').must_equal('foo/bar')
      frontend.send(:pagy_trim_url, 'foo/bar?a=page&page=1', 'page=1').must_equal('foo/bar?a=page')
      frontend.send(:pagy_trim_url, 'foo/bar?a=page&page=1&b=4', 'page=1').must_equal('foo/bar?a=page&b=4')
      frontend.send(:pagy_trim_url, 'foo/bar?a=page&page=1&b=4&my_page=1', 'page=1').must_equal('foo/bar?a=page&b=4&my_page=1')
    end

  end

  describe "#pagy_link_proc" do

    it 'returns trimmed link' do
      pagy = Pagy.new(count: 1000)
      link = frontend.pagy_link_proc(pagy)
      link.call(1).must_equal("<a href=\"/foo\"   >1</a>")
      link.call(10).must_equal("<a href=\"/foo?page=10\"   >10</a>")
      pagy = Pagy.new(count: 1000, params: {a:3,b:4})
      link = frontend.pagy_link_proc(pagy)
      link.call(1).must_equal("<a href=\"/foo?a=3&b=4\"   >1</a>")
      link.call(10).must_equal("<a href=\"/foo?page=10&a=3&b=4\"   >10</a>")
    end

  end

  describe "#pagy_nav" do

    it 'renders first page' do
      pagy = Pagy.new(count: 103, page: 1)
      html = frontend.pagy_nav(pagy)
      html.must_equal \
        "<nav class=\"pagy-nav pagination\" role=\"navigation\" aria-label=\"pager\"><span class=\"page prev disabled\">&lsaquo;&nbsp;Prev</span> <span class=\"page active\">1</span> <span class=\"page\"><a href=\"/foo?page=2\"   rel=\"next\" >2</a></span> <span class=\"page\"><a href=\"/foo?page=3\"   >3</a></span> <span class=\"page\"><a href=\"/foo?page=4\"   >4</a></span> <span class=\"page\"><a href=\"/foo?page=5\"   >5</a></span> <span class=\"page\"><a href=\"/foo?page=6\"   >6</a></span> <span class=\"page next\"><a href=\"/foo?page=2\"   rel=\"next\" aria-label=\"next\">Next&nbsp;&rsaquo;</a></span></nav>"
    end

    it 'renders intermediate page' do
      pagy = Pagy.new(count: 103, page: 3)
      html = frontend.pagy_nav(pagy)
      html.must_equal \
        "<nav class=\"pagy-nav pagination\" role=\"navigation\" aria-label=\"pager\"><span class=\"page prev\"><a href=\"/foo?page=2\"   rel=\"prev\" aria-label=\"previous\">&lsaquo;&nbsp;Prev</a></span> <span class=\"page\"><a href=\"/foo\"   >1</a></span> <span class=\"page\"><a href=\"/foo?page=2\"   rel=\"prev\" >2</a></span> <span class=\"page active\">3</span> <span class=\"page\"><a href=\"/foo?page=4\"   rel=\"next\" >4</a></span> <span class=\"page\"><a href=\"/foo?page=5\"   >5</a></span> <span class=\"page\"><a href=\"/foo?page=6\"   >6</a></span> <span class=\"page next\"><a href=\"/foo?page=4\"   rel=\"next\" aria-label=\"next\">Next&nbsp;&rsaquo;</a></span></nav>"
    end

    it 'renders last page' do
      pagy = Pagy.new(count: 103, page: 6)
      html = frontend.pagy_nav(pagy)
      html.must_equal \
        "<nav class=\"pagy-nav pagination\" role=\"navigation\" aria-label=\"pager\"><span class=\"page prev\"><a href=\"/foo?page=5\"   rel=\"prev\" aria-label=\"previous\">&lsaquo;&nbsp;Prev</a></span> <span class=\"page\"><a href=\"/foo\"   >1</a></span> <span class=\"page\"><a href=\"/foo?page=2\"   >2</a></span> <span class=\"page\"><a href=\"/foo?page=3\"   >3</a></span> <span class=\"page\"><a href=\"/foo?page=4\"   >4</a></span> <span class=\"page\"><a href=\"/foo?page=5\"   rel=\"prev\" >5</a></span> <span class=\"page active\">6</span> <span class=\"page next disabled\">Next&nbsp;&rsaquo;</span></nav>"
    end

  end

  describe "#pagy_nav_js" do

    it 'renders first page' do
      pagy = Pagy.new(count: 103, page: 1)
      html = frontend.pagy_nav_js(pagy, pagy_test_id)
      html.must_equal \
        "<nav id=\"test-id\" class=\"pagy-nav-js pagination\" role=\"navigation\" aria-label=\"pager\"></nav><script type=\"application/json\" class=\"pagy-json\">[\"nav\",\"test-id\",\"#{Pagy::Frontend::MARKER}\",{\"before\":\"<span class=\\\"page prev disabled\\\">&lsaquo;&nbsp;Prev</span> \",\"link\":\"<span class=\\\"page\\\"><a href=\\\"/foo?page=#{Pagy::Frontend::MARKER}\\\"   >#{Pagy::Frontend::MARKER}</a></span> \",\"active\":\"<span class=\\\"page active\\\">1</span> \",\"gap\":\"<span class=\\\"page gap\\\">&hellip;</span> \",\"after\":\"<span class=\\\"page next\\\"><a href=\\\"/foo?page=2\\\"   rel=\\\"next\\\" aria-label=\\\"next\\\">Next&nbsp;&rsaquo;</a></span>\"},{\"0\":[\"1\",2,3,4,5,6]}]</script>"
    end

    it 'renders intermediate page' do
      pagy = Pagy.new(count: 103, page: 3)
      html = frontend.pagy_nav_js(pagy, pagy_test_id)
      html.must_equal \
        "<nav id=\"test-id\" class=\"pagy-nav-js pagination\" role=\"navigation\" aria-label=\"pager\"></nav><script type=\"application/json\" class=\"pagy-json\">[\"nav\",\"test-id\",\"#{Pagy::Frontend::MARKER}\",{\"before\":\"<span class=\\\"page prev\\\"><a href=\\\"/foo?page=2\\\"   rel=\\\"prev\\\" aria-label=\\\"previous\\\">&lsaquo;&nbsp;Prev</a></span> \",\"link\":\"<span class=\\\"page\\\"><a href=\\\"/foo?page=#{Pagy::Frontend::MARKER}\\\"   >#{Pagy::Frontend::MARKER}</a></span> \",\"active\":\"<span class=\\\"page active\\\">3</span> \",\"gap\":\"<span class=\\\"page gap\\\">&hellip;</span> \",\"after\":\"<span class=\\\"page next\\\"><a href=\\\"/foo?page=4\\\"   rel=\\\"next\\\" aria-label=\\\"next\\\">Next&nbsp;&rsaquo;</a></span>\"},{\"0\":[1,2,\"3\",4,5,6]}]</script>"
    end

    it 'renders last page' do
      pagy = Pagy.new(count: 103, page: 6)
      html = frontend.pagy_nav_js(pagy, pagy_test_id)
      html.must_equal \
        "<nav id=\"test-id\" class=\"pagy-nav-js pagination\" role=\"navigation\" aria-label=\"pager\"></nav><script type=\"application/json\" class=\"pagy-json\">[\"nav\",\"test-id\",\"#{Pagy::Frontend::MARKER}\",{\"before\":\"<span class=\\\"page prev\\\"><a href=\\\"/foo?page=5\\\"   rel=\\\"prev\\\" aria-label=\\\"previous\\\">&lsaquo;&nbsp;Prev</a></span> \",\"link\":\"<span class=\\\"page\\\"><a href=\\\"/foo?page=#{Pagy::Frontend::MARKER}\\\"   >#{Pagy::Frontend::MARKER}</a></span> \",\"active\":\"<span class=\\\"page active\\\">6</span> \",\"gap\":\"<span class=\\\"page gap\\\">&hellip;</span> \",\"after\":\"<span class=\\\"page next disabled\\\">Next&nbsp;&rsaquo;</span>\"},{\"0\":[1,2,3,4,5,\"6\"]}]</script>"
    end

  end

  describe "#pagy_combo_nav_js" do

    it 'renders first page' do
      pagy = Pagy.new(count: 103, page: 1)
      html = frontend.pagy_combo_nav_js(pagy, pagy_test_id)
      html.must_equal \
        "<nav id=\"test-id\" class=\"pagy-combo-nav-js-js pagination\" role=\"navigation\" aria-label=\"pager\"><a href=\"/foo?page=#{Pagy::Frontend::MARKER}\"   style=\"display: none;\" ></a><a href=\"/foo\"   style=\"display: none;\" ></a><span class=\"page prev disabled\">&lsaquo;&nbsp;Prev</span> <span class=\"pagy-compact-input\" style=\"margin: 0 0.6rem;\">Page <input type=\"number\" min=\"1\" max=\"6\" value=\"1\" style=\"padding: 0; text-align: center; width: 2rem;\"> of 6</span> <span class=\"page next\"><a href=\"/foo?page=2\"   rel=\"next\" aria-label=\"next\">Next&nbsp;&rsaquo;</a></span></nav><script type=\"application/json\" class=\"pagy-json\">[\"combo_nav\",\"test-id\",\"#{Pagy::Frontend::MARKER}\",1,true]</script>"
    end

    it 'renders intermediate page' do
      pagy = Pagy.new(count: 103, page: 3)
      html = frontend.pagy_combo_nav_js(pagy, pagy_test_id)
      html.must_equal \
        "<nav id=\"test-id\" class=\"pagy-combo-nav-js-js pagination\" role=\"navigation\" aria-label=\"pager\"><a href=\"/foo?page=#{Pagy::Frontend::MARKER}\"   style=\"display: none;\" ></a><a href=\"/foo\"   style=\"display: none;\" ></a><span class=\"page prev\"><a href=\"/foo?page=2\"   rel=\"prev\" aria-label=\"previous\">&lsaquo;&nbsp;Prev</a></span> <span class=\"pagy-compact-input\" style=\"margin: 0 0.6rem;\">Page <input type=\"number\" min=\"1\" max=\"6\" value=\"3\" style=\"padding: 0; text-align: center; width: 2rem;\"> of 6</span> <span class=\"page next\"><a href=\"/foo?page=4\"   rel=\"next\" aria-label=\"next\">Next&nbsp;&rsaquo;</a></span></nav><script type=\"application/json\" class=\"pagy-json\">[\"combo_nav\",\"test-id\",\"#{Pagy::Frontend::MARKER}\",3,true]</script>"
    end

    it 'renders last page' do
      pagy = Pagy.new(count: 103, page: 6)
      html = frontend.pagy_combo_nav_js(pagy, pagy_test_id)
      html.must_equal \
        "<nav id=\"test-id\" class=\"pagy-combo-nav-js-js pagination\" role=\"navigation\" aria-label=\"pager\"><a href=\"/foo?page=#{Pagy::Frontend::MARKER}\"   style=\"display: none;\" ></a><a href=\"/foo\"   style=\"display: none;\" ></a><span class=\"page prev\"><a href=\"/foo?page=5\"   rel=\"prev\" aria-label=\"previous\">&lsaquo;&nbsp;Prev</a></span> <span class=\"pagy-compact-input\" style=\"margin: 0 0.6rem;\">Page <input type=\"number\" min=\"1\" max=\"6\" value=\"6\" style=\"padding: 0; text-align: center; width: 2rem;\"> of 6</span> <span class=\"page next disabled\">Next&nbsp;&rsaquo;</span></nav><script type=\"application/json\" class=\"pagy-json\">[\"combo_nav\",\"test-id\",\"#{Pagy::Frontend::MARKER}\",6,true]</script>"
    end

  end

end
