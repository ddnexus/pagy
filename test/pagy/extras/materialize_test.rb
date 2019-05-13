# encoding: utf-8
# frozen_string_literal: true

require_relative '../../test_helper'
require 'pagy/extras/materialize'

describe Pagy::Frontend do

  let(:view) { MockView.new }
  let(:pagy_test_id) { 'test-id' }

  describe "#pagy_materialize_nav" do

    it 'renders first page' do
      pagy = Pagy.new(count: 1000, page: 1)
      view.pagy_materialize_nav(pagy).must_equal \
        "<div class=\"pagy-materialize-nav pagination\" role=\"navigation\" aria-label=\"pager\"><ul class=\"pagination\"><li class=\"prev disabled\"><a href=\"#\"><i class=\"material-icons\">chevron_left</i></a></li><li class=\"active\"><a href=\"/foo?page=1\"   >1</a></li><li class=\"waves-effect\"><a href=\"/foo?page=2\"   rel=\"next\" >2</a></li><li class=\"waves-effect\"><a href=\"/foo?page=3\"   >3</a></li><li class=\"waves-effect\"><a href=\"/foo?page=4\"   >4</a></li><li class=\"waves-effect\"><a href=\"/foo?page=5\"   >5</a></li><li class=\"gap disabled\"><a href=\"#\">&hellip;</a></li><li class=\"waves-effect\"><a href=\"/foo?page=50\"   >50</a></li><li class=\"waves-effect next\"><a href=\"/foo?page=2\"   rel=\"next\" aria-label=\"next\"><i class=\"material-icons\">chevron_right</i></a></li></ul></div>"
    end

    it 'renders intermediate page' do
      pagy = Pagy.new(count: 1000, page: 20)
      view.pagy_materialize_nav(pagy).must_equal \
        "<div class=\"pagy-materialize-nav pagination\" role=\"navigation\" aria-label=\"pager\"><ul class=\"pagination\"><li class=\"waves-effect prev\"><a href=\"/foo?page=19\"   rel=\"prev\" aria-label=\"previous\"><i class=\"material-icons\">chevron_left</i></a></li><li class=\"waves-effect\"><a href=\"/foo?page=1\"   >1</a></li><li class=\"gap disabled\"><a href=\"#\">&hellip;</a></li><li class=\"waves-effect\"><a href=\"/foo?page=16\"   >16</a></li><li class=\"waves-effect\"><a href=\"/foo?page=17\"   >17</a></li><li class=\"waves-effect\"><a href=\"/foo?page=18\"   >18</a></li><li class=\"waves-effect\"><a href=\"/foo?page=19\"   rel=\"prev\" >19</a></li><li class=\"active\"><a href=\"/foo?page=20\"   >20</a></li><li class=\"waves-effect\"><a href=\"/foo?page=21\"   rel=\"next\" >21</a></li><li class=\"waves-effect\"><a href=\"/foo?page=22\"   >22</a></li><li class=\"waves-effect\"><a href=\"/foo?page=23\"   >23</a></li><li class=\"waves-effect\"><a href=\"/foo?page=24\"   >24</a></li><li class=\"gap disabled\"><a href=\"#\">&hellip;</a></li><li class=\"waves-effect\"><a href=\"/foo?page=50\"   >50</a></li><li class=\"waves-effect next\"><a href=\"/foo?page=21\"   rel=\"next\" aria-label=\"next\"><i class=\"material-icons\">chevron_right</i></a></li></ul></div>"
    end


    it 'renders last page' do
      pagy = Pagy.new(count: 1000, page: 50)
      view.pagy_materialize_nav(pagy).must_equal \
        "<div class=\"pagy-materialize-nav pagination\" role=\"navigation\" aria-label=\"pager\"><ul class=\"pagination\"><li class=\"waves-effect prev\"><a href=\"/foo?page=49\"   rel=\"prev\" aria-label=\"previous\"><i class=\"material-icons\">chevron_left</i></a></li><li class=\"waves-effect\"><a href=\"/foo?page=1\"   >1</a></li><li class=\"gap disabled\"><a href=\"#\">&hellip;</a></li><li class=\"waves-effect\"><a href=\"/foo?page=46\"   >46</a></li><li class=\"waves-effect\"><a href=\"/foo?page=47\"   >47</a></li><li class=\"waves-effect\"><a href=\"/foo?page=48\"   >48</a></li><li class=\"waves-effect\"><a href=\"/foo?page=49\"   rel=\"prev\" >49</a></li><li class=\"active\"><a href=\"/foo?page=50\"   >50</a></li><li class=\"next disabled\"><a href=\"#\"><i class=\"material-icons\">chevron_right</i></a></li></ul></div>"
    end

  end

  describe "#pagy_materialize_nav_js" do

    it 'renders first page' do
      pagy = Pagy.new(count: 1000, page: 1)
      view.pagy_materialize_nav_js(pagy, pagy_test_id).must_equal \
        "<div id=\"test-id\" class=\"pagy-materialize-nav-js\" role=\"navigation\" aria-label=\"pager\"></div><script type=\"application/json\" class=\"pagy-json\">[\"nav\",\"test-id\",{\"before\":\"<ul class=\\\"pagination\\\"><li class=\\\"prev disabled\\\"><a href=\\\"#\\\"><i class=\\\"material-icons\\\">chevron_left</i></a></li>\",\"link\":\"<li class=\\\"waves-effect\\\"><a href=\\\"/foo?page=__pagy_page__\\\"   >__pagy_page__</a></li>\",\"active\":\"<li class=\\\"active\\\"><a href=\\\"/foo?page=__pagy_page__\\\"   >__pagy_page__</a></li>\",\"gap\":\"<li class=\\\"gap disabled\\\"><a href=\\\"#\\\">&hellip;</a></li>\",\"after\":\"<li class=\\\"waves-effect next\\\"><a href=\\\"/foo?page=2\\\"   rel=\\\"next\\\" aria-label=\\\"next\\\"><i class=\\\"material-icons\\\">chevron_right</i></a></li></ul>\"},{\"0\":[\"1\",2,3,4,5,\"gap\",50]},null]</script>"
    end

    it 'renders intermediate page' do
      pagy = Pagy.new(count: 1000, page: 20)
      view.pagy_materialize_nav_js(pagy, pagy_test_id).must_equal \
        "<div id=\"test-id\" class=\"pagy-materialize-nav-js\" role=\"navigation\" aria-label=\"pager\"></div><script type=\"application/json\" class=\"pagy-json\">[\"nav\",\"test-id\",{\"before\":\"<ul class=\\\"pagination\\\"><li class=\\\"waves-effect prev\\\"><a href=\\\"/foo?page=19\\\"   rel=\\\"prev\\\" aria-label=\\\"previous\\\"><i class=\\\"material-icons\\\">chevron_left</i></a></li>\",\"link\":\"<li class=\\\"waves-effect\\\"><a href=\\\"/foo?page=__pagy_page__\\\"   >__pagy_page__</a></li>\",\"active\":\"<li class=\\\"active\\\"><a href=\\\"/foo?page=__pagy_page__\\\"   >__pagy_page__</a></li>\",\"gap\":\"<li class=\\\"gap disabled\\\"><a href=\\\"#\\\">&hellip;</a></li>\",\"after\":\"<li class=\\\"waves-effect next\\\"><a href=\\\"/foo?page=21\\\"   rel=\\\"next\\\" aria-label=\\\"next\\\"><i class=\\\"material-icons\\\">chevron_right</i></a></li></ul>\"},{\"0\":[1,\"gap\",16,17,18,19,\"20\",21,22,23,24,\"gap\",50]},null]</script>"
    end

    it 'renders last page' do
      pagy = Pagy.new(count: 1000, page: 50)
      view.pagy_materialize_nav_js(pagy, pagy_test_id).must_equal \
        "<div id=\"test-id\" class=\"pagy-materialize-nav-js\" role=\"navigation\" aria-label=\"pager\"></div><script type=\"application/json\" class=\"pagy-json\">[\"nav\",\"test-id\",{\"before\":\"<ul class=\\\"pagination\\\"><li class=\\\"waves-effect prev\\\"><a href=\\\"/foo?page=49\\\"   rel=\\\"prev\\\" aria-label=\\\"previous\\\"><i class=\\\"material-icons\\\">chevron_left</i></a></li>\",\"link\":\"<li class=\\\"waves-effect\\\"><a href=\\\"/foo?page=__pagy_page__\\\"   >__pagy_page__</a></li>\",\"active\":\"<li class=\\\"active\\\"><a href=\\\"/foo?page=__pagy_page__\\\"   >__pagy_page__</a></li>\",\"gap\":\"<li class=\\\"gap disabled\\\"><a href=\\\"#\\\">&hellip;</a></li>\",\"after\":\"<li class=\\\"next disabled\\\"><a href=\\\"#\\\"><i class=\\\"material-icons\\\">chevron_right</i></a></li></ul>\"},{\"0\":[1,\"gap\",46,47,48,49,\"50\"]},null]</script>"
    end

    it 'renders with :steps' do
      pagy = Pagy.new(count: 1000, page: 20, steps: {0 => [1,2,2,1], 500 => [2,3,3,2]})
      view.pagy_materialize_nav_js(pagy, pagy_test_id).must_equal \
        "<div id=\"test-id\" class=\"pagy-materialize-nav-js\" role=\"navigation\" aria-label=\"pager\"></div><script type=\"application/json\" class=\"pagy-json\">[\"nav\",\"test-id\",{\"before\":\"<ul class=\\\"pagination\\\"><li class=\\\"waves-effect prev\\\"><a href=\\\"/foo?page=19\\\"   rel=\\\"prev\\\" aria-label=\\\"previous\\\"><i class=\\\"material-icons\\\">chevron_left</i></a></li>\",\"link\":\"<li class=\\\"waves-effect\\\"><a href=\\\"/foo?page=__pagy_page__\\\"   >__pagy_page__</a></li>\",\"active\":\"<li class=\\\"active\\\"><a href=\\\"/foo?page=__pagy_page__\\\"   >__pagy_page__</a></li>\",\"gap\":\"<li class=\\\"gap disabled\\\"><a href=\\\"#\\\">&hellip;</a></li>\",\"after\":\"<li class=\\\"waves-effect next\\\"><a href=\\\"/foo?page=21\\\"   rel=\\\"next\\\" aria-label=\\\"next\\\"><i class=\\\"material-icons\\\">chevron_right</i></a></li></ul>\"},{\"0\":[1,\"gap\",18,19,\"20\",21,22,\"gap\",50],\"500\":[1,2,\"gap\",17,18,19,\"20\",21,22,23,\"gap\",49,50]},null]</script>"
    end

  end

  describe "#pagy_materialize_combo_nav_js" do

    it 'renders first page' do
      pagy = Pagy.new(count: 103, page: 1)
      view.pagy_materialize_combo_nav_js(pagy, pagy_test_id).must_equal \
        "<div id=\"test-id\" class=\"pagy-materialize-combo-nav-js pagination\" role=\"navigation\" aria-label=\"pager\"><div class=\"pagy-compact-chip role=\"group\" style=\"height: 35px; border-radius: 18px; background: #e4e4e4; display: inline-block;\"><ul class=\"pagination\" style=\"margin: 0px;\"><li class=\"prev disabled\" style=\"vertical-align: middle;\"><a href=\"#\"><i class=\"material-icons\">chevron_left</i></a></li><div class=\"pagy-combo-input btn-flat\" style=\"cursor: default; padding: 0px\">Page <input type=\"number\" class=\"browser-default\" min=\"1\" max=\"6\" value=\"1\" style=\"padding: 2px; border: none; border-radius: 2px; text-align: center; width: 2rem;\"> of 6</div><li class=\"waves-effect next\" style=\"vertical-align: middle;\"><a href=\"/foo?page=2\"   rel=\"next\" aria-label=\"next\"><i class=\"material-icons\">chevron_right</i></a></li></ul></div><script type=\"application/json\" class=\"pagy-json\">[\"combo_nav\",\"test-id\",1,\"<a href=\\\"/foo?page=__pagy_page__\\\"   style=\\\"display: none;\\\"></a>\",null]</script>"
    end

    it 'renders intermediate page' do
      pagy = Pagy.new(count: 103, page: 3)
      view.pagy_materialize_combo_nav_js(pagy, pagy_test_id).must_equal \
        "<div id=\"test-id\" class=\"pagy-materialize-combo-nav-js pagination\" role=\"navigation\" aria-label=\"pager\"><div class=\"pagy-compact-chip role=\"group\" style=\"height: 35px; border-radius: 18px; background: #e4e4e4; display: inline-block;\"><ul class=\"pagination\" style=\"margin: 0px;\"><li class=\"waves-effect prev\" style=\"vertical-align: middle;\"><a href=\"/foo?page=2\"   rel=\"prev\" aria-label=\"previous\"><i class=\"material-icons\">chevron_left</i></a></li><div class=\"pagy-combo-input btn-flat\" style=\"cursor: default; padding: 0px\">Page <input type=\"number\" class=\"browser-default\" min=\"1\" max=\"6\" value=\"3\" style=\"padding: 2px; border: none; border-radius: 2px; text-align: center; width: 2rem;\"> of 6</div><li class=\"waves-effect next\" style=\"vertical-align: middle;\"><a href=\"/foo?page=4\"   rel=\"next\" aria-label=\"next\"><i class=\"material-icons\">chevron_right</i></a></li></ul></div><script type=\"application/json\" class=\"pagy-json\">[\"combo_nav\",\"test-id\",3,\"<a href=\\\"/foo?page=__pagy_page__\\\"   style=\\\"display: none;\\\"></a>\",null]</script>"
    end

    it 'renders last page' do
      pagy = Pagy.new(count: 103, page: 6)
      view.pagy_materialize_combo_nav_js(pagy, pagy_test_id).must_equal \
        "<div id=\"test-id\" class=\"pagy-materialize-combo-nav-js pagination\" role=\"navigation\" aria-label=\"pager\"><div class=\"pagy-compact-chip role=\"group\" style=\"height: 35px; border-radius: 18px; background: #e4e4e4; display: inline-block;\"><ul class=\"pagination\" style=\"margin: 0px;\"><li class=\"waves-effect prev\" style=\"vertical-align: middle;\"><a href=\"/foo?page=5\"   rel=\"prev\" aria-label=\"previous\"><i class=\"material-icons\">chevron_left</i></a></li><div class=\"pagy-combo-input btn-flat\" style=\"cursor: default; padding: 0px\">Page <input type=\"number\" class=\"browser-default\" min=\"1\" max=\"6\" value=\"6\" style=\"padding: 2px; border: none; border-radius: 2px; text-align: center; width: 2rem;\"> of 6</div><li class=\"next disabled\" style=\"vertical-align: middle;\"><a href=\"#\"><i class=\"material-icons\">chevron_right</i></a></li></ul></div><script type=\"application/json\" class=\"pagy-json\">[\"combo_nav\",\"test-id\",6,\"<a href=\\\"/foo?page=__pagy_page__\\\"   style=\\\"display: none;\\\"></a>\",null]</script>"
    end

  end

end
