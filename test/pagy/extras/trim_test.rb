# encoding: utf-8
# frozen_string_literal: true

require_relative '../../test_helper'
require 'pagy/extras/plain'
require 'pagy/extras/bootstrap'
require 'pagy/extras/bulma'
# require 'pagy/extras/foundation'
require 'pagy/extras/materialize'
# require 'pagy/extras/semantic'
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

describe "#pagy_plain_compact_nav" do

    before do
      @array = (1..103).to_a.extend(Pagy::Array::PageMethod)
    end

    it 'renders page 1' do
      pagy, _  = @array.pagy(1)
      html = frontend.pagy_plain_compact_nav(pagy, pagy_test_id)
      html.must_equal \
        "<nav id=\"test-id\" class=\"pagy-plain-compact-nav pagination\" role=\"navigation\" aria-label=\"pager\"><a href=\"/foo?page=#{Pagy::Frontend::MARKER}\"   style=\"display: none;\" ></a><a href=\"/foo\"   style=\"display: none;\" ></a><span class=\"page prev disabled\">&lsaquo;&nbsp;Prev</span> <span class=\"pagy-compact-input\" style=\"margin: 0 0.6rem;\">Page <input type=\"number\" min=\"1\" max=\"6\" value=\"1\" style=\"padding: 0; text-align: center; width: 2rem;\"> of 6</span> <span class=\"page next\"><a href=\"/foo?page=2\"   rel=\"next\" aria-label=\"next\">Next&nbsp;&rsaquo;</a></span></nav><script type=\"application/json\" class=\"pagy-json\">[\"compact\",\"test-id\",\"#{Pagy::Frontend::MARKER}\",1,true]</script>"
    end

    it 'renders page 3' do
      pagy, _  = @array.pagy(3)
      html = frontend.pagy_plain_compact_nav(pagy, pagy_test_id)
      html.must_equal \
        "<nav id=\"test-id\" class=\"pagy-plain-compact-nav pagination\" role=\"navigation\" aria-label=\"pager\"><a href=\"/foo?page=#{Pagy::Frontend::MARKER}\"   style=\"display: none;\" ></a><a href=\"/foo\"   style=\"display: none;\" ></a><span class=\"page prev\"><a href=\"/foo?page=2\"   rel=\"prev\" aria-label=\"previous\">&lsaquo;&nbsp;Prev</a></span> <span class=\"pagy-compact-input\" style=\"margin: 0 0.6rem;\">Page <input type=\"number\" min=\"1\" max=\"6\" value=\"3\" style=\"padding: 0; text-align: center; width: 2rem;\"> of 6</span> <span class=\"page next\"><a href=\"/foo?page=4\"   rel=\"next\" aria-label=\"next\">Next&nbsp;&rsaquo;</a></span></nav><script type=\"application/json\" class=\"pagy-json\">[\"compact\",\"test-id\",\"#{Pagy::Frontend::MARKER}\",3,true]</script>"
    end

    it 'renders page 6' do
      pagy, _  = @array.pagy(6)
      html = frontend.pagy_plain_compact_nav(pagy, pagy_test_id)
      html.must_equal \
        "<nav id=\"test-id\" class=\"pagy-plain-compact-nav pagination\" role=\"navigation\" aria-label=\"pager\"><a href=\"/foo?page=#{Pagy::Frontend::MARKER}\"   style=\"display: none;\" ></a><a href=\"/foo\"   style=\"display: none;\" ></a><span class=\"page prev\"><a href=\"/foo?page=5\"   rel=\"prev\" aria-label=\"previous\">&lsaquo;&nbsp;Prev</a></span> <span class=\"pagy-compact-input\" style=\"margin: 0 0.6rem;\">Page <input type=\"number\" min=\"1\" max=\"6\" value=\"6\" style=\"padding: 0; text-align: center; width: 2rem;\"> of 6</span> <span class=\"page next disabled\">Next&nbsp;&rsaquo;</span></nav><script type=\"application/json\" class=\"pagy-json\">[\"compact\",\"test-id\",\"#{Pagy::Frontend::MARKER}\",6,true]</script>"
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
        "<nav id=\"test-id\" class=\"pagy-bootstrap-compact-nav pagination\" role=\"navigation\" aria-label=\"pager\"><a href=\"/foo?page=#{Pagy::Frontend::MARKER}\"   style=\"display: none;\" ></a><a href=\"/foo\"   style=\"display: none;\" ></a><div class=\"btn-group\" role=\"group\"><a class=\"prev btn btn-primary disabled\" href=\"#\">&lsaquo;&nbsp;Prev</a><div class=\"pagy-compact-input btn btn-primary disabled\">Page <input type=\"number\" min=\"1\" max=\"6\" value=\"1\" class=\"text-primary\" style=\"padding: 0; border: none; text-align: center; width: 2rem;\"> of 6</div><a href=\"/foo?page=2\"   rel=\"next\" aria-label=\"next\" class=\"next btn btn-primary\">Next&nbsp;&rsaquo;</a></div></nav><script type=\"application/json\" class=\"pagy-json\">[\"compact\",\"test-id\",\"#{Pagy::Frontend::MARKER}\",1,true]</script>"
    end

    it 'renders page 3 for bootstrap' do
      pagy, _  = @array.pagy(3)
      html = frontend.pagy_bootstrap_compact_nav(pagy, pagy_test_id)
      html.must_equal \
        "<nav id=\"test-id\" class=\"pagy-bootstrap-compact-nav pagination\" role=\"navigation\" aria-label=\"pager\"><a href=\"/foo?page=#{Pagy::Frontend::MARKER}\"   style=\"display: none;\" ></a><a href=\"/foo\"   style=\"display: none;\" ></a><div class=\"btn-group\" role=\"group\"><a href=\"/foo?page=2\"   rel=\"prev\" aria-label=\"previous\" class=\"prev btn btn-primary\">&lsaquo;&nbsp;Prev</a><div class=\"pagy-compact-input btn btn-primary disabled\">Page <input type=\"number\" min=\"1\" max=\"6\" value=\"3\" class=\"text-primary\" style=\"padding: 0; border: none; text-align: center; width: 2rem;\"> of 6</div><a href=\"/foo?page=4\"   rel=\"next\" aria-label=\"next\" class=\"next btn btn-primary\">Next&nbsp;&rsaquo;</a></div></nav><script type=\"application/json\" class=\"pagy-json\">[\"compact\",\"test-id\",\"#{Pagy::Frontend::MARKER}\",3,true]</script>"
    end

    it 'renders page 6 for bootstrap' do
      pagy, _  = @array.pagy(6)
      html = frontend.pagy_bootstrap_compact_nav(pagy, pagy_test_id)
      html.must_equal \
        "<nav id=\"test-id\" class=\"pagy-bootstrap-compact-nav pagination\" role=\"navigation\" aria-label=\"pager\"><a href=\"/foo?page=#{Pagy::Frontend::MARKER}\"   style=\"display: none;\" ></a><a href=\"/foo\"   style=\"display: none;\" ></a><div class=\"btn-group\" role=\"group\"><a href=\"/foo?page=5\"   rel=\"prev\" aria-label=\"previous\" class=\"prev btn btn-primary\">&lsaquo;&nbsp;Prev</a><div class=\"pagy-compact-input btn btn-primary disabled\">Page <input type=\"number\" min=\"1\" max=\"6\" value=\"6\" class=\"text-primary\" style=\"padding: 0; border: none; text-align: center; width: 2rem;\"> of 6</div><a class=\"next btn btn-primary disabled\" href=\"#\">Next&nbsp;&rsaquo;</a></div></nav><script type=\"application/json\" class=\"pagy-json\">[\"compact\",\"test-id\",\"#{Pagy::Frontend::MARKER}\",6,true]</script>"
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
        "<nav id=\"test-id\" class=\"pagy-bulma-compact-nav\" role=\"navigation\" aria-label=\"pagination\"><a href=\"/foo?page=#{Pagy::Frontend::MARKER}\"   style=\"display: none;\"></a><a href=\"/foo\"   style=\"display: none;\"></a><div class=\"field is-grouped is-grouped-centered\" role=\"group\"><p class=\"control\"><a class=\"button\" disabled>&lsaquo;&nbsp;Prev</a></p><div class=\"pagy-compact-input control level is-mobile\">Page <input class=\"input\" type=\"number\" min=\"1\" max=\"6\" value=\"1\" style=\"padding: 0; text-align: center; width: 2rem; margin:0 0.3rem;\"> of 6</div><p class=\"control\"><a href=\"/foo?page=2\"   rel=\"next\" class=\"button\" aria-label=\"next page\">Next&nbsp;&rsaquo;</a></p></div></nav><script type=\"application/json\" class=\"pagy-json\">[\"compact\",\"test-id\",\"#{Pagy::Frontend::MARKER}\",1,true]</script>"
    end

    it 'renders page 3 for bulma' do
      pagy, _  = @array.pagy(3)
      html = frontend.pagy_bulma_compact_nav(pagy, pagy_test_id)
      html.must_equal \
        "<nav id=\"test-id\" class=\"pagy-bulma-compact-nav\" role=\"navigation\" aria-label=\"pagination\"><a href=\"/foo?page=#{Pagy::Frontend::MARKER}\"   style=\"display: none;\"></a><a href=\"/foo\"   style=\"display: none;\"></a><div class=\"field is-grouped is-grouped-centered\" role=\"group\"><p class=\"control\"><a href=\"/foo?page=2\"   rel=\"prev\" class=\"button\" aria-label=\"previous page\">&lsaquo;&nbsp;Prev</a></p><div class=\"pagy-compact-input control level is-mobile\">Page <input class=\"input\" type=\"number\" min=\"1\" max=\"6\" value=\"3\" style=\"padding: 0; text-align: center; width: 2rem; margin:0 0.3rem;\"> of 6</div><p class=\"control\"><a href=\"/foo?page=4\"   rel=\"next\" class=\"button\" aria-label=\"next page\">Next&nbsp;&rsaquo;</a></p></div></nav><script type=\"application/json\" class=\"pagy-json\">[\"compact\",\"test-id\",\"#{Pagy::Frontend::MARKER}\",3,true]</script>"
    end

    it 'renders page 6 for bulma' do
      pagy, _  = @array.pagy(6)
      html = frontend.pagy_bulma_compact_nav(pagy, pagy_test_id)
      html.must_equal \
        "<nav id=\"test-id\" class=\"pagy-bulma-compact-nav\" role=\"navigation\" aria-label=\"pagination\"><a href=\"/foo?page=#{Pagy::Frontend::MARKER}\"   style=\"display: none;\"></a><a href=\"/foo\"   style=\"display: none;\"></a><div class=\"field is-grouped is-grouped-centered\" role=\"group\"><p class=\"control\"><a href=\"/foo?page=5\"   rel=\"prev\" class=\"button\" aria-label=\"previous page\">&lsaquo;&nbsp;Prev</a></p><div class=\"pagy-compact-input control level is-mobile\">Page <input class=\"input\" type=\"number\" min=\"1\" max=\"6\" value=\"6\" style=\"padding: 0; text-align: center; width: 2rem; margin:0 0.3rem;\"> of 6</div><p class=\"control\"><a class=\"button\" disabled>Next&nbsp;&rsaquo;</a></p></div></nav><script type=\"application/json\" class=\"pagy-json\">[\"compact\",\"test-id\",\"#{Pagy::Frontend::MARKER}\",6,true]</script>"
    end

  end

  describe "#pagy_materialize_compact_nav" do

    before do
      @array = (1..103).to_a.extend(Pagy::Array::PageMethod)
    end

    it 'renders page 1 for materialize' do
      pagy, _  = @array.pagy(1)
      html = frontend.pagy_materialize_compact_nav(pagy, pagy_test_id)
      html.must_equal \
        "<div id=\"test-id\" class=\"pagy-materialize-compact-nav pagination\" role=\"navigation\" aria-label=\"pager\"><a href=\"/foo?page=#{Pagy::Frontend::MARKER}\"   style=\"display: none;\" ></a><a href=\"/foo\"   style=\"display: none;\" ></a><div class=\"pagy-compact-chip role=\"group\" style=\"height: 35px; border-radius: 18px; background: #e4e4e4; display: inline-block;\"><ul class=\"pagination\" style=\"margin: 0px;\"><li class=\"prev disabled\" style=\"vertical-align: middle;\"><a href=\"#\"><i class=\"material-icons\">chevron_left</i></a></li><div class=\"pagy-compact-input btn-flat\" style=\"cursor: default; padding: 0px\">Page <input type=\"number\" class=\"browser-default\" min=\"1\" max=\"6\" value=\"1\" style=\"padding: 2px; border: none; border-radius: 2px; text-align: center; width: 2rem;\"> of 6</div><li class=\"waves-effect next\" style=\"vertical-align: middle;\"><a href=\"/foo?page=2\"   rel=\"next\" aria-label=\"next\"><i class=\"material-icons\">chevron_right</i></a></li></ul></div><script type=\"application/json\" class=\"pagy-json\">[\"compact\",\"test-id\",\"#{Pagy::Frontend::MARKER}\",1,true]</script>"
    end

    it 'renders page 3 for materialize' do
      pagy, _  = @array.pagy(3)
      html = frontend.pagy_materialize_compact_nav(pagy, pagy_test_id)
      html.must_equal \
        "<div id=\"test-id\" class=\"pagy-materialize-compact-nav pagination\" role=\"navigation\" aria-label=\"pager\"><a href=\"/foo?page=#{Pagy::Frontend::MARKER}\"   style=\"display: none;\" ></a><a href=\"/foo\"   style=\"display: none;\" ></a><div class=\"pagy-compact-chip role=\"group\" style=\"height: 35px; border-radius: 18px; background: #e4e4e4; display: inline-block;\"><ul class=\"pagination\" style=\"margin: 0px;\"><li class=\"waves-effect prev\" style=\"vertical-align: middle;\"><a href=\"/foo?page=2\"   rel=\"prev\" aria-label=\"previous\"><i class=\"material-icons\">chevron_left</i></a></li><div class=\"pagy-compact-input btn-flat\" style=\"cursor: default; padding: 0px\">Page <input type=\"number\" class=\"browser-default\" min=\"1\" max=\"6\" value=\"3\" style=\"padding: 2px; border: none; border-radius: 2px; text-align: center; width: 2rem;\"> of 6</div><li class=\"waves-effect next\" style=\"vertical-align: middle;\"><a href=\"/foo?page=4\"   rel=\"next\" aria-label=\"next\"><i class=\"material-icons\">chevron_right</i></a></li></ul></div><script type=\"application/json\" class=\"pagy-json\">[\"compact\",\"test-id\",\"#{Pagy::Frontend::MARKER}\",3,true]</script>"
    end

    it 'renders page 6 for materialize' do
      pagy, _  = @array.pagy(6)
      html = frontend.pagy_materialize_compact_nav(pagy, pagy_test_id)
      html.must_equal \
        "<div id=\"test-id\" class=\"pagy-materialize-compact-nav pagination\" role=\"navigation\" aria-label=\"pager\"><a href=\"/foo?page=#{Pagy::Frontend::MARKER}\"   style=\"display: none;\" ></a><a href=\"/foo\"   style=\"display: none;\" ></a><div class=\"pagy-compact-chip role=\"group\" style=\"height: 35px; border-radius: 18px; background: #e4e4e4; display: inline-block;\"><ul class=\"pagination\" style=\"margin: 0px;\"><li class=\"waves-effect prev\" style=\"vertical-align: middle;\"><a href=\"/foo?page=5\"   rel=\"prev\" aria-label=\"previous\"><i class=\"material-icons\">chevron_left</i></a></li><div class=\"pagy-compact-input btn-flat\" style=\"cursor: default; padding: 0px\">Page <input type=\"number\" class=\"browser-default\" min=\"1\" max=\"6\" value=\"6\" style=\"padding: 2px; border: none; border-radius: 2px; text-align: center; width: 2rem;\"> of 6</div><li class=\"next disabled\" style=\"vertical-align: middle;\"><a href=\"#\"><i class=\"material-icons\">chevron_right</i></a></li></ul></div><script type=\"application/json\" class=\"pagy-json\">[\"compact\",\"test-id\",\"#{Pagy::Frontend::MARKER}\",6,true]</script>"
    end

  end

end
