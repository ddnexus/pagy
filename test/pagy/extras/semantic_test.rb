# encoding: utf-8
# frozen_string_literal: true

require_relative '../../test_helper'
require 'pagy/extras/semantic'

SingleCov.covered!(uncovered: 1) unless ENV['SKIP_SINGLECOV']

describe Pagy::Frontend do

  let(:frontend) { TestView.new }
  let(:pagy_test_id) { 'test-id' }

  describe "#pagy_semantic_nav" do

    before do
      @array = (1..103).to_a.extend(Pagy::Array::PageMethod)
    end

    it 'renders page 1' do
      pagy, _ = @array.pagy(1)
      frontend.pagy_semantic_nav(pagy).must_equal \
        "<div class=\"pagy-semantic-nav ui pagination menu\" aria-label=\"pager\"><div class=\"item disabled\"><i class=\"left small chevron icon\"></i></div><a class=\"item active\">1</a><a href=\"/foo?page=2\"  class=\"item\" rel=\"next\" >2</a><a href=\"/foo?page=3\"  class=\"item\" >3</a><a href=\"/foo?page=4\"  class=\"item\" >4</a><a href=\"/foo?page=5\"  class=\"item\" >5</a><a href=\"/foo?page=6\"  class=\"item\" >6</a><a href=\"/foo?page=2\"  class=\"item\" rel=\"next\" aria-label=\"next\"><i class=\"right small chevron icon\"></i></a></div>"
    end

    it 'renders page 3' do
      pagy, _ = @array.pagy(3)
      frontend.pagy_semantic_nav(pagy).must_equal \
        "<div class=\"pagy-semantic-nav ui pagination menu\" aria-label=\"pager\"><a href=\"/foo?page=2\"  class=\"item\" rel=\"prev\" aria-label=\"previous\"><i class=\"left small chevron icon\"></i></a><a href=\"/foo?page=1\"  class=\"item\" >1</a><a href=\"/foo?page=2\"  class=\"item\" rel=\"prev\" >2</a><a class=\"item active\">3</a><a href=\"/foo?page=4\"  class=\"item\" rel=\"next\" >4</a><a href=\"/foo?page=5\"  class=\"item\" >5</a><a href=\"/foo?page=6\"  class=\"item\" >6</a><a href=\"/foo?page=4\"  class=\"item\" rel=\"next\" aria-label=\"next\"><i class=\"right small chevron icon\"></i></a></div>"
    end

    it 'renders page 6' do
      pagy, _ = @array.pagy(6)
      frontend.pagy_semantic_nav(pagy).must_equal \
        "<div class=\"pagy-semantic-nav ui pagination menu\" aria-label=\"pager\"><a href=\"/foo?page=5\"  class=\"item\" rel=\"prev\" aria-label=\"previous\"><i class=\"left small chevron icon\"></i></a><a href=\"/foo?page=1\"  class=\"item\" >1</a><a href=\"/foo?page=2\"  class=\"item\" >2</a><a href=\"/foo?page=3\"  class=\"item\" >3</a><a href=\"/foo?page=4\"  class=\"item\" >4</a><a href=\"/foo?page=5\"  class=\"item\" rel=\"prev\" >5</a><a class=\"item active\">6</a><div class=\"item disabled\"><i class=\"right small chevron icon\"></i></div></div>"
    end

    it 'renders page 10' do
      @array = (1..1000).to_a.extend(Pagy::Array::PageMethod)
      pagy, _ = @array.pagy(10)
      frontend.pagy_semantic_nav(pagy).must_equal \
        "<div class=\"pagy-semantic-nav ui pagination menu\" aria-label=\"pager\"><a href=\"/foo?page=9\"  class=\"item\" rel=\"prev\" aria-label=\"previous\"><i class=\"left small chevron icon\"></i></a><a href=\"/foo?page=1\"  class=\"item\" >1</a><div class=\"disabled item\">...</div><a href=\"/foo?page=6\"  class=\"item\" >6</a><a href=\"/foo?page=7\"  class=\"item\" >7</a><a href=\"/foo?page=8\"  class=\"item\" >8</a><a href=\"/foo?page=9\"  class=\"item\" rel=\"prev\" >9</a><a class=\"item active\">10</a><a href=\"/foo?page=11\"  class=\"item\" rel=\"next\" >11</a><a href=\"/foo?page=12\"  class=\"item\" >12</a><a href=\"/foo?page=13\"  class=\"item\" >13</a><a href=\"/foo?page=14\"  class=\"item\" >14</a><div class=\"disabled item\">...</div><a href=\"/foo?page=50\"  class=\"item\" >50</a><a href=\"/foo?page=11\"  class=\"item\" rel=\"next\" aria-label=\"next\"><i class=\"right small chevron icon\"></i></a></div>"
    end

  end

  describe "#pagy_semantic_compact_nav" do

    before do
      @array = (1..103).to_a.extend(Pagy::Array::PageMethod)
    end

    it 'renders page 1' do
      pagy, _  = @array.pagy(1)
      html = frontend.pagy_semantic_compact_nav(pagy, pagy_test_id)
      html.must_equal \
        "<div id=\"test-id\" class=\"pagy-semantic-compact-nav ui compact menu\" role=\"navigation\" aria-label=\"pager\"><a href=\"/foo?page=#{Pagy::Frontend::MARKER}\"  class=\"item\" style=\"display: none;\" ></a><div class=\"item disabled\"><i class=\"left small chevron icon\"></i></div><div class=\"pagy-compact-input item\">Page <input type=\"number\" min=\"1\" max=\"6\" value=\"1\" style=\"padding: 0; text-align: center; width: 2rem; margin: 0 0.3rem\"> of 6</div> <a href=\"/foo?page=2\"  class=\"item\" rel=\"next\" aria-label=\"next\"><i class=\"right small chevron icon\"></i></a></div><script type=\"application/json\" class=\"pagy-json\">[\"compact\",\"test-id\",\"#{Pagy::Frontend::MARKER}\",1,false]</script>"
    end

    it 'renders page 3' do
      pagy, _  = @array.pagy(3)
      html = frontend.pagy_semantic_compact_nav(pagy, pagy_test_id)
      html.must_equal \
        "<div id=\"test-id\" class=\"pagy-semantic-compact-nav ui compact menu\" role=\"navigation\" aria-label=\"pager\"><a href=\"/foo?page=#{Pagy::Frontend::MARKER}\"  class=\"item\" style=\"display: none;\" ></a><a href=\"/foo?page=2\"  class=\"item\" rel=\"prev\" aria-label=\"previous\"><i class=\"left small chevron icon\"></i></a><div class=\"pagy-compact-input item\">Page <input type=\"number\" min=\"1\" max=\"6\" value=\"3\" style=\"padding: 0; text-align: center; width: 2rem; margin: 0 0.3rem\"> of 6</div> <a href=\"/foo?page=4\"  class=\"item\" rel=\"next\" aria-label=\"next\"><i class=\"right small chevron icon\"></i></a></div><script type=\"application/json\" class=\"pagy-json\">[\"compact\",\"test-id\",\"#{Pagy::Frontend::MARKER}\",3,false]</script>"
    end

    it 'renders page 6' do
      pagy, _  = @array.pagy(6)
      html = frontend.pagy_semantic_compact_nav(pagy, pagy_test_id)
      html.must_equal \
        "<div id=\"test-id\" class=\"pagy-semantic-compact-nav ui compact menu\" role=\"navigation\" aria-label=\"pager\"><a href=\"/foo?page=#{Pagy::Frontend::MARKER}\"  class=\"item\" style=\"display: none;\" ></a><a href=\"/foo?page=5\"  class=\"item\" rel=\"prev\" aria-label=\"previous\"><i class=\"left small chevron icon\"></i></a><div class=\"pagy-compact-input item\">Page <input type=\"number\" min=\"1\" max=\"6\" value=\"6\" style=\"padding: 0; text-align: center; width: 2rem; margin: 0 0.3rem\"> of 6</div> <div class=\"item disabled\"><i class=\"right small chevron icon\"></i></div></div><script type=\"application/json\" class=\"pagy-json\">[\"compact\",\"test-id\",\"#{Pagy::Frontend::MARKER}\",6,false]</script>"
    end

  end

  describe "#pagy_semantic_responsive_nav" do

    before do
      @array = (1..103).to_a.extend(Pagy::Array::PageMethod)
    end

    it 'renders page 1' do
      pagy, _  = @array.pagy(1)
      html = frontend.pagy_semantic_responsive_nav(pagy, pagy_test_id)
      html.must_equal \
        "<div id=\"test-id\" class=\"pagy-semantic-responsive-nav ui pagination menu\" role=\"navigation\" aria-label=\"pager\"></div><script type=\"application/json\" class=\"pagy-json\">[\"responsive\",\"test-id\",{\"before\":\"<div class=\\\"item disabled\\\"><i class=\\\"left small chevron icon\\\"></i></div>\",\"1\":\"<a class=\\\"item active\\\">1</a>\",\"2\":\"<a href=\\\"/foo?page=2\\\"  class=\\\"item\\\" rel=\\\"next\\\" >2</a>\",\"3\":\"<a href=\\\"/foo?page=3\\\"  class=\\\"item\\\" >3</a>\",\"4\":\"<a href=\\\"/foo?page=4\\\"  class=\\\"item\\\" >4</a>\",\"5\":\"<a href=\\\"/foo?page=5\\\"  class=\\\"item\\\" >5</a>\",\"6\":\"<a href=\\\"/foo?page=6\\\"  class=\\\"item\\\" >6</a>\",\"after\":\"<a href=\\\"/foo?page=2\\\"  class=\\\"item\\\" rel=\\\"next\\\" aria-label=\\\"next\\\"><i class=\\\"right small chevron icon\\\"></i></a>\"},[0],{\"0\":[\"1\",2,3,4,5,6]}]</script>"
    end

    it 'renders page 3' do
      pagy, _  = @array.pagy(3)
      html = frontend.pagy_semantic_responsive_nav(pagy, pagy_test_id)
      html.must_equal \
        "<div id=\"test-id\" class=\"pagy-semantic-responsive-nav ui pagination menu\" role=\"navigation\" aria-label=\"pager\"></div><script type=\"application/json\" class=\"pagy-json\">[\"responsive\",\"test-id\",{\"before\":\"<a href=\\\"/foo?page=2\\\"  class=\\\"item\\\" rel=\\\"prev\\\" aria-label=\\\"previous\\\"><i class=\\\"left small chevron icon\\\"></i></a>\",\"1\":\"<a href=\\\"/foo?page=1\\\"  class=\\\"item\\\" >1</a>\",\"2\":\"<a href=\\\"/foo?page=2\\\"  class=\\\"item\\\" rel=\\\"prev\\\" >2</a>\",\"3\":\"<a class=\\\"item active\\\">3</a>\",\"4\":\"<a href=\\\"/foo?page=4\\\"  class=\\\"item\\\" rel=\\\"next\\\" >4</a>\",\"5\":\"<a href=\\\"/foo?page=5\\\"  class=\\\"item\\\" >5</a>\",\"6\":\"<a href=\\\"/foo?page=6\\\"  class=\\\"item\\\" >6</a>\",\"after\":\"<a href=\\\"/foo?page=4\\\"  class=\\\"item\\\" rel=\\\"next\\\" aria-label=\\\"next\\\"><i class=\\\"right small chevron icon\\\"></i></a>\"},[0],{\"0\":[1,2,\"3\",4,5,6]}]</script>"
    end

    it 'renders page 6' do
      pagy, _ = @array.pagy(6)
      html = frontend.pagy_semantic_responsive_nav(pagy, pagy_test_id)
      html.must_equal \
        "<div id=\"test-id\" class=\"pagy-semantic-responsive-nav ui pagination menu\" role=\"navigation\" aria-label=\"pager\"></div><script type=\"application/json\" class=\"pagy-json\">[\"responsive\",\"test-id\",{\"before\":\"<a href=\\\"/foo?page=5\\\"  class=\\\"item\\\" rel=\\\"prev\\\" aria-label=\\\"previous\\\"><i class=\\\"left small chevron icon\\\"></i></a>\",\"1\":\"<a href=\\\"/foo?page=1\\\"  class=\\\"item\\\" >1</a>\",\"2\":\"<a href=\\\"/foo?page=2\\\"  class=\\\"item\\\" >2</a>\",\"3\":\"<a href=\\\"/foo?page=3\\\"  class=\\\"item\\\" >3</a>\",\"4\":\"<a href=\\\"/foo?page=4\\\"  class=\\\"item\\\" >4</a>\",\"5\":\"<a href=\\\"/foo?page=5\\\"  class=\\\"item\\\" rel=\\\"prev\\\" >5</a>\",\"6\":\"<a class=\\\"item active\\\">6</a>\",\"after\":\"<div class=\\\"item disabled\\\"><i class=\\\"right small chevron icon\\\"></i></div>\"},[0],{\"0\":[1,2,3,4,5,\"6\"]}]</script>"
    end

    it 'renders page 10' do
      @array   = (1..1000).to_a.extend(Pagy::Array::PageMethod)
      pagy, _  = @array.pagy(10)
      html = frontend.pagy_semantic_responsive_nav(pagy, pagy_test_id)
      html.must_equal \
        "<div id=\"test-id\" class=\"pagy-semantic-responsive-nav ui pagination menu\" role=\"navigation\" aria-label=\"pager\"></div><script type=\"application/json\" class=\"pagy-json\">[\"responsive\",\"test-id\",{\"before\":\"<a href=\\\"/foo?page=9\\\"  class=\\\"item\\\" rel=\\\"prev\\\" aria-label=\\\"previous\\\"><i class=\\\"left small chevron icon\\\"></i></a>\",\"1\":\"<a href=\\\"/foo?page=1\\\"  class=\\\"item\\\" >1</a>\",\"gap\":\"<div class=\\\"disabled item\\\">...</div>\",\"6\":\"<a href=\\\"/foo?page=6\\\"  class=\\\"item\\\" >6</a>\",\"7\":\"<a href=\\\"/foo?page=7\\\"  class=\\\"item\\\" >7</a>\",\"8\":\"<a href=\\\"/foo?page=8\\\"  class=\\\"item\\\" >8</a>\",\"9\":\"<a href=\\\"/foo?page=9\\\"  class=\\\"item\\\" rel=\\\"prev\\\" >9</a>\",\"10\":\"<a class=\\\"item active\\\">10</a>\",\"11\":\"<a href=\\\"/foo?page=11\\\"  class=\\\"item\\\" rel=\\\"next\\\" >11</a>\",\"12\":\"<a href=\\\"/foo?page=12\\\"  class=\\\"item\\\" >12</a>\",\"13\":\"<a href=\\\"/foo?page=13\\\"  class=\\\"item\\\" >13</a>\",\"14\":\"<a href=\\\"/foo?page=14\\\"  class=\\\"item\\\" >14</a>\",\"50\":\"<a href=\\\"/foo?page=50\\\"  class=\\\"item\\\" >50</a>\",\"after\":\"<a href=\\\"/foo?page=11\\\"  class=\\\"item\\\" rel=\\\"next\\\" aria-label=\\\"next\\\"><i class=\\\"right small chevron icon\\\"></i></a>\"},[0],{\"0\":[1,\"gap\",6,7,8,9,\"10\",11,12,13,14,\"gap\",50]}]</script>"
    end

  end



end
