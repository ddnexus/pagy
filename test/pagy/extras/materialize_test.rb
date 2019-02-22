# encoding: utf-8
# frozen_string_literal: true

require_relative '../../test_helper'
require 'pagy/extras/materialize'

SingleCov.covered!(uncovered: 1) unless ENV['SKIP_SINGLECOV'] # undefined TRIM for compact helper, tested in trim_test

describe Pagy::Frontend do

  let(:frontend) { TestView.new }
  let(:pagy_test_id) { 'test-id' }

  describe "#pagy_materialize_nav" do

    before do
      @array = (1..103).to_a.extend(Pagy::Array::PageMethod)
    end

    it 'renders page 1' do
      pagy, _ = @array.pagy(1)
      frontend.pagy_materialize_nav(pagy).must_equal \
        "<div class=\"pagy-materialize-nav pagination\" role=\"navigation\" aria-label=\"pager\"><ul class=\"pagination\"><li class=\"prev disabled\"><a href=\"#\"><i class=\"material-icons\">chevron_left</i></a></li><li class=\"active\"><a href=\"/foo?page=1\"   >1</a></li><li class=\"waves-effect\"><a href=\"/foo?page=2\"   rel=\"next\" >2</a></li><li class=\"waves-effect\"><a href=\"/foo?page=3\"   >3</a></li><li class=\"waves-effect\"><a href=\"/foo?page=4\"   >4</a></li><li class=\"waves-effect\"><a href=\"/foo?page=5\"   >5</a></li><li class=\"waves-effect\"><a href=\"/foo?page=6\"   >6</a></li><li class=\"waves-effect next\"><a href=\"/foo?page=2\"   rel=\"next\" aria-label=\"next\"><i class=\"material-icons\">chevron_right</i></a></li></ul></div>"
    end

    it 'renders page 3' do
      pagy, _ = @array.pagy(3)
      frontend.pagy_materialize_nav(pagy).must_equal \
        "<div class=\"pagy-materialize-nav pagination\" role=\"navigation\" aria-label=\"pager\"><ul class=\"pagination\"><li class=\"waves-effect prev\"><a href=\"/foo?page=2\"   rel=\"prev\" aria-label=\"previous\"><i class=\"material-icons\">chevron_left</i></a></li><li class=\"waves-effect\"><a href=\"/foo?page=1\"   >1</a></li><li class=\"waves-effect\"><a href=\"/foo?page=2\"   rel=\"prev\" >2</a></li><li class=\"active\"><a href=\"/foo?page=3\"   >3</a></li><li class=\"waves-effect\"><a href=\"/foo?page=4\"   rel=\"next\" >4</a></li><li class=\"waves-effect\"><a href=\"/foo?page=5\"   >5</a></li><li class=\"waves-effect\"><a href=\"/foo?page=6\"   >6</a></li><li class=\"waves-effect next\"><a href=\"/foo?page=4\"   rel=\"next\" aria-label=\"next\"><i class=\"material-icons\">chevron_right</i></a></li></ul></div>"
    end


    it 'renders page 6' do
      pagy, _ = @array.pagy(6)
      frontend.pagy_materialize_nav(pagy).must_equal \
        "<div class=\"pagy-materialize-nav pagination\" role=\"navigation\" aria-label=\"pager\"><ul class=\"pagination\"><li class=\"waves-effect prev\"><a href=\"/foo?page=5\"   rel=\"prev\" aria-label=\"previous\"><i class=\"material-icons\">chevron_left</i></a></li><li class=\"waves-effect\"><a href=\"/foo?page=1\"   >1</a></li><li class=\"waves-effect\"><a href=\"/foo?page=2\"   >2</a></li><li class=\"waves-effect\"><a href=\"/foo?page=3\"   >3</a></li><li class=\"waves-effect\"><a href=\"/foo?page=4\"   >4</a></li><li class=\"waves-effect\"><a href=\"/foo?page=5\"   rel=\"prev\" >5</a></li><li class=\"active\"><a href=\"/foo?page=6\"   >6</a></li><li class=\"next disabled\"><a href=\"#\"><i class=\"material-icons\">chevron_right</i></a></li></ul></div>"    end

    it 'renders page 10' do
      @array = (1..1000).to_a.extend(Pagy::Array::PageMethod)
      pagy, _ = @array.pagy(10)
      frontend.pagy_materialize_nav(pagy).must_equal \
        "<div class=\"pagy-materialize-nav pagination\" role=\"navigation\" aria-label=\"pager\"><ul class=\"pagination\"><li class=\"waves-effect prev\"><a href=\"/foo?page=9\"   rel=\"prev\" aria-label=\"previous\"><i class=\"material-icons\">chevron_left</i></a></li><li class=\"waves-effect\"><a href=\"/foo?page=1\"   >1</a></li><li class=\"gap disabled\"><a href=\"#\">&hellip;</a></li><li class=\"waves-effect\"><a href=\"/foo?page=6\"   >6</a></li><li class=\"waves-effect\"><a href=\"/foo?page=7\"   >7</a></li><li class=\"waves-effect\"><a href=\"/foo?page=8\"   >8</a></li><li class=\"waves-effect\"><a href=\"/foo?page=9\"   rel=\"prev\" >9</a></li><li class=\"active\"><a href=\"/foo?page=10\"   >10</a></li><li class=\"waves-effect\"><a href=\"/foo?page=11\"   rel=\"next\" >11</a></li><li class=\"waves-effect\"><a href=\"/foo?page=12\"   >12</a></li><li class=\"waves-effect\"><a href=\"/foo?page=13\"   >13</a></li><li class=\"waves-effect\"><a href=\"/foo?page=14\"   >14</a></li><li class=\"gap disabled\"><a href=\"#\">&hellip;</a></li><li class=\"waves-effect\"><a href=\"/foo?page=50\"   >50</a></li><li class=\"waves-effect next\"><a href=\"/foo?page=11\"   rel=\"next\" aria-label=\"next\"><i class=\"material-icons\">chevron_right</i></a></li></ul></div>"
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
        "<div id=\"test-id\" class=\"pagy-materialize-compact-nav pagination\" role=\"navigation\" aria-label=\"pager\"><a href=\"/foo?page=#{Pagy::Frontend::MARKER}\"   style=\"display: none;\" ></a><div class=\"pagy-compact-chip role=\"group\" style=\"height: 35px; border-radius: 18px; background: #e4e4e4; display: inline-block;\"><ul class=\"pagination\" style=\"margin: 0px;\"><li class=\"prev disabled\" style=\"vertical-align: middle;\"><a href=\"#\"><i class=\"material-icons\">chevron_left</i></a></li><div class=\"pagy-compact-input btn-flat\" style=\"cursor: default; padding: 0px\">Page <input type=\"number\" class=\"browser-default\" min=\"1\" max=\"6\" value=\"1\" style=\"padding: 2px; border: none; border-radius: 2px; text-align: center; width: 2rem;\"> of 6</div><li class=\"waves-effect next\" style=\"vertical-align: middle;\"><a href=\"/foo?page=2\"   rel=\"next\" aria-label=\"next\"><i class=\"material-icons\">chevron_right</i></a></li></ul></div><script type=\"application/json\" class=\"pagy-json\">[\"compact\",\"test-id\",\"#{Pagy::Frontend::MARKER}\",1,false]</script>"
    end

    it 'renders page 3 for materialize' do
      pagy, _  = @array.pagy(3)
      html = frontend.pagy_materialize_compact_nav(pagy, pagy_test_id)
      html.must_equal \
        "<div id=\"test-id\" class=\"pagy-materialize-compact-nav pagination\" role=\"navigation\" aria-label=\"pager\"><a href=\"/foo?page=#{Pagy::Frontend::MARKER}\"   style=\"display: none;\" ></a><div class=\"pagy-compact-chip role=\"group\" style=\"height: 35px; border-radius: 18px; background: #e4e4e4; display: inline-block;\"><ul class=\"pagination\" style=\"margin: 0px;\"><li class=\"waves-effect prev\" style=\"vertical-align: middle;\"><a href=\"/foo?page=2\"   rel=\"prev\" aria-label=\"previous\"><i class=\"material-icons\">chevron_left</i></a></li><div class=\"pagy-compact-input btn-flat\" style=\"cursor: default; padding: 0px\">Page <input type=\"number\" class=\"browser-default\" min=\"1\" max=\"6\" value=\"3\" style=\"padding: 2px; border: none; border-radius: 2px; text-align: center; width: 2rem;\"> of 6</div><li class=\"waves-effect next\" style=\"vertical-align: middle;\"><a href=\"/foo?page=4\"   rel=\"next\" aria-label=\"next\"><i class=\"material-icons\">chevron_right</i></a></li></ul></div><script type=\"application/json\" class=\"pagy-json\">[\"compact\",\"test-id\",\"#{Pagy::Frontend::MARKER}\",3,false]</script>"
    end

    it 'renders page 6 for materialize' do
      pagy, _  = @array.pagy(6)
      html = frontend.pagy_materialize_compact_nav(pagy, pagy_test_id)
      html.must_equal \
        "<div id=\"test-id\" class=\"pagy-materialize-compact-nav pagination\" role=\"navigation\" aria-label=\"pager\"><a href=\"/foo?page=#{Pagy::Frontend::MARKER}\"   style=\"display: none;\" ></a><div class=\"pagy-compact-chip role=\"group\" style=\"height: 35px; border-radius: 18px; background: #e4e4e4; display: inline-block;\"><ul class=\"pagination\" style=\"margin: 0px;\"><li class=\"waves-effect prev\" style=\"vertical-align: middle;\"><a href=\"/foo?page=5\"   rel=\"prev\" aria-label=\"previous\"><i class=\"material-icons\">chevron_left</i></a></li><div class=\"pagy-compact-input btn-flat\" style=\"cursor: default; padding: 0px\">Page <input type=\"number\" class=\"browser-default\" min=\"1\" max=\"6\" value=\"6\" style=\"padding: 2px; border: none; border-radius: 2px; text-align: center; width: 2rem;\"> of 6</div><li class=\"next disabled\" style=\"vertical-align: middle;\"><a href=\"#\"><i class=\"material-icons\">chevron_right</i></a></li></ul></div><script type=\"application/json\" class=\"pagy-json\">[\"compact\",\"test-id\",\"#{Pagy::Frontend::MARKER}\",6,false]</script>"
    end

  end

  describe "#pagy_materialize_responsive_nav" do

    before do
      @array = (1..103).to_a.extend(Pagy::Array::PageMethod)
    end

    it 'renders page 1 for materialize' do
      pagy, _  = @array.pagy(1)
      html = frontend.pagy_materialize_responsive_nav(pagy, pagy_test_id)
      html.must_equal \
        "<div id=\"test-id\" class=\"pagy-materialize-responsive-nav pagination\" role=\"navigation\" aria-label=\"pager\"></div><script type=\"application/json\" class=\"pagy-json\">[\"responsive\",\"test-id\",{\"before\":\"<ul class=\\\"pagination\\\"><li class=\\\"prev disabled\\\"><a href=\\\"#\\\"><i class=\\\"material-icons\\\">chevron_left</i></a></li>\",\"1\":\"<li class=\\\"active\\\"><a href=\\\"/foo?page=1\\\"   >1</a></li>\",\"2\":\"<li class=\\\"waves-effect\\\"><a href=\\\"/foo?page=2\\\"   rel=\\\"next\\\" >2</a></li>\",\"3\":\"<li class=\\\"waves-effect\\\"><a href=\\\"/foo?page=3\\\"   >3</a></li>\",\"4\":\"<li class=\\\"waves-effect\\\"><a href=\\\"/foo?page=4\\\"   >4</a></li>\",\"5\":\"<li class=\\\"waves-effect\\\"><a href=\\\"/foo?page=5\\\"   >5</a></li>\",\"6\":\"<li class=\\\"waves-effect\\\"><a href=\\\"/foo?page=6\\\"   >6</a></li>\",\"after\":\"<li class=\\\"waves-effect next\\\"><a href=\\\"/foo?page=2\\\"   rel=\\\"next\\\" aria-label=\\\"next\\\"><i class=\\\"material-icons\\\">chevron_right</i></a></li></ul>\"},[0],{\"0\":[\"1\",2,3,4,5,6]}]</script>"
    end

    it 'renders page 3 for materialize' do
      pagy, _  = @array.pagy(3)
      html = frontend.pagy_materialize_responsive_nav(pagy, pagy_test_id)
      html.must_equal \
        "<div id=\"test-id\" class=\"pagy-materialize-responsive-nav pagination\" role=\"navigation\" aria-label=\"pager\"></div><script type=\"application/json\" class=\"pagy-json\">[\"responsive\",\"test-id\",{\"before\":\"<ul class=\\\"pagination\\\"><li class=\\\"waves-effect prev\\\"><a href=\\\"/foo?page=2\\\"   rel=\\\"prev\\\" aria-label=\\\"previous\\\"><i class=\\\"material-icons\\\">chevron_left</i></a></li>\",\"1\":\"<li class=\\\"waves-effect\\\"><a href=\\\"/foo?page=1\\\"   >1</a></li>\",\"2\":\"<li class=\\\"waves-effect\\\"><a href=\\\"/foo?page=2\\\"   rel=\\\"prev\\\" >2</a></li>\",\"3\":\"<li class=\\\"active\\\"><a href=\\\"/foo?page=3\\\"   >3</a></li>\",\"4\":\"<li class=\\\"waves-effect\\\"><a href=\\\"/foo?page=4\\\"   rel=\\\"next\\\" >4</a></li>\",\"5\":\"<li class=\\\"waves-effect\\\"><a href=\\\"/foo?page=5\\\"   >5</a></li>\",\"6\":\"<li class=\\\"waves-effect\\\"><a href=\\\"/foo?page=6\\\"   >6</a></li>\",\"after\":\"<li class=\\\"waves-effect next\\\"><a href=\\\"/foo?page=4\\\"   rel=\\\"next\\\" aria-label=\\\"next\\\"><i class=\\\"material-icons\\\">chevron_right</i></a></li></ul>\"},[0],{\"0\":[1,2,\"3\",4,5,6]}]</script>"
    end

    it 'renders page 6 for materialize' do
      pagy, _  = @array.pagy(6)
      html = frontend.pagy_materialize_responsive_nav(pagy, pagy_test_id)
      html.must_equal \
        "<div id=\"test-id\" class=\"pagy-materialize-responsive-nav pagination\" role=\"navigation\" aria-label=\"pager\"></div><script type=\"application/json\" class=\"pagy-json\">[\"responsive\",\"test-id\",{\"before\":\"<ul class=\\\"pagination\\\"><li class=\\\"waves-effect prev\\\"><a href=\\\"/foo?page=5\\\"   rel=\\\"prev\\\" aria-label=\\\"previous\\\"><i class=\\\"material-icons\\\">chevron_left</i></a></li>\",\"1\":\"<li class=\\\"waves-effect\\\"><a href=\\\"/foo?page=1\\\"   >1</a></li>\",\"2\":\"<li class=\\\"waves-effect\\\"><a href=\\\"/foo?page=2\\\"   >2</a></li>\",\"3\":\"<li class=\\\"waves-effect\\\"><a href=\\\"/foo?page=3\\\"   >3</a></li>\",\"4\":\"<li class=\\\"waves-effect\\\"><a href=\\\"/foo?page=4\\\"   >4</a></li>\",\"5\":\"<li class=\\\"waves-effect\\\"><a href=\\\"/foo?page=5\\\"   rel=\\\"prev\\\" >5</a></li>\",\"6\":\"<li class=\\\"active\\\"><a href=\\\"/foo?page=6\\\"   >6</a></li>\",\"after\":\"<li class=\\\"next disabled\\\"><a href=\\\"#\\\"><i class=\\\"material-icons\\\">chevron_right</i></a></li></ul>\"},[0],{\"0\":[1,2,3,4,5,\"6\"]}]</script>"
    end

    it 'renders page 10 for materialize' do
      @array   = (1..1000).to_a.extend(Pagy::Array::PageMethod)
      pagy, _  = @array.pagy(10)
      html = frontend.pagy_materialize_responsive_nav(pagy, pagy_test_id)
      html.must_equal \
         "<div id=\"test-id\" class=\"pagy-materialize-responsive-nav pagination\" role=\"navigation\" aria-label=\"pager\"></div><script type=\"application/json\" class=\"pagy-json\">[\"responsive\",\"test-id\",{\"before\":\"<ul class=\\\"pagination\\\"><li class=\\\"waves-effect prev\\\"><a href=\\\"/foo?page=9\\\"   rel=\\\"prev\\\" aria-label=\\\"previous\\\"><i class=\\\"material-icons\\\">chevron_left</i></a></li>\",\"1\":\"<li class=\\\"waves-effect\\\"><a href=\\\"/foo?page=1\\\"   >1</a></li>\",\"gap\":\"<li class=\\\"gap disabled\\\"><a href=\\\"#\\\">&hellip;</a></li>\",\"6\":\"<li class=\\\"waves-effect\\\"><a href=\\\"/foo?page=6\\\"   >6</a></li>\",\"7\":\"<li class=\\\"waves-effect\\\"><a href=\\\"/foo?page=7\\\"   >7</a></li>\",\"8\":\"<li class=\\\"waves-effect\\\"><a href=\\\"/foo?page=8\\\"   >8</a></li>\",\"9\":\"<li class=\\\"waves-effect\\\"><a href=\\\"/foo?page=9\\\"   rel=\\\"prev\\\" >9</a></li>\",\"10\":\"<li class=\\\"active\\\"><a href=\\\"/foo?page=10\\\"   >10</a></li>\",\"11\":\"<li class=\\\"waves-effect\\\"><a href=\\\"/foo?page=11\\\"   rel=\\\"next\\\" >11</a></li>\",\"12\":\"<li class=\\\"waves-effect\\\"><a href=\\\"/foo?page=12\\\"   >12</a></li>\",\"13\":\"<li class=\\\"waves-effect\\\"><a href=\\\"/foo?page=13\\\"   >13</a></li>\",\"14\":\"<li class=\\\"waves-effect\\\"><a href=\\\"/foo?page=14\\\"   >14</a></li>\",\"50\":\"<li class=\\\"waves-effect\\\"><a href=\\\"/foo?page=50\\\"   >50</a></li>\",\"after\":\"<li class=\\\"waves-effect next\\\"><a href=\\\"/foo?page=11\\\"   rel=\\\"next\\\" aria-label=\\\"next\\\"><i class=\\\"material-icons\\\">chevron_right</i></a></li></ul>\"},[0],{\"0\":[1,\"gap\",6,7,8,9,\"10\",11,12,13,14,\"gap\",50]}]</script>"
    end

  end

end
