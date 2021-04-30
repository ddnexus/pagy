# frozen_string_literal: true

require_relative '../../test_helper'
require 'pagy/extras/uikit'

describe 'pagy/extras/uikit' do
  let(:view) { MockView.new }

  describe '#pagy_uikit_nav' do
    it 'renders first page' do
      pagy = Pagy.new(count: 1000, page: 1)
      _(view.pagy_uikit_nav(pagy)).must_equal \
        "<ul class=\"pagy-uikit-nav uk-pagination uk-flex-center\"><li class=\"uk-disabled\"><a href=\"#\"><span uk-pagination-previous>&lsaquo;&nbsp;Prev</span></a></li><li class=\"uk-active\"><span>1</span></li><li><a href=\"/foo?page=2\"   rel=\"next\" >2</a></li><li><a href=\"/foo?page=3\"   >3</a></li><li><a href=\"/foo?page=4\"   >4</a></li><li><a href=\"/foo?page=5\"   >5</a></li><li class=\"uk-disabled\"><span>&hellip;</span></li><li><a href=\"/foo?page=50\"   >50</a></li><li><a href=\"/foo?page=2\"   rel=\"next\" ><span uk-pagination-next>Next&nbsp;&rsaquo;</span></a></li></ul>"
      _(view.pagy_uikit_nav(pagy, pagy_id: 'test-nav-id', link_extra: 'link-extra')).must_equal \
        "<ul id=\"test-nav-id\" class=\"pagy-uikit-nav uk-pagination uk-flex-center\"><li class=\"uk-disabled\"><a href=\"#\"><span uk-pagination-previous>&lsaquo;&nbsp;Prev</span></a></li><li class=\"uk-active\"><span>1</span></li><li><a href=\"/foo?page=2\"  link-extra rel=\"next\" >2</a></li><li><a href=\"/foo?page=3\"  link-extra >3</a></li><li><a href=\"/foo?page=4\"  link-extra >4</a></li><li><a href=\"/foo?page=5\"  link-extra >5</a></li><li class=\"uk-disabled\"><span>&hellip;</span></li><li><a href=\"/foo?page=50\"  link-extra >50</a></li><li><a href=\"/foo?page=2\"  link-extra rel=\"next\" ><span uk-pagination-next>Next&nbsp;&rsaquo;</span></a></li></ul>"
    end
    it 'renders intermediate page' do
      pagy = Pagy.new(count: 1000, page: 20)
      _(view.pagy_uikit_nav(pagy)).must_equal \
        "<ul class=\"pagy-uikit-nav uk-pagination uk-flex-center\"><li><a href=\"/foo?page=19\"   rel=\"prev\" ><span uk-pagination-previous>&lsaquo;&nbsp;Prev</span></a></li><li><a href=\"/foo?page=1\"   >1</a></li><li class=\"uk-disabled\"><span>&hellip;</span></li><li><a href=\"/foo?page=16\"   >16</a></li><li><a href=\"/foo?page=17\"   >17</a></li><li><a href=\"/foo?page=18\"   >18</a></li><li><a href=\"/foo?page=19\"   rel=\"prev\" >19</a></li><li class=\"uk-active\"><span>20</span></li><li><a href=\"/foo?page=21\"   rel=\"next\" >21</a></li><li><a href=\"/foo?page=22\"   >22</a></li><li><a href=\"/foo?page=23\"   >23</a></li><li><a href=\"/foo?page=24\"   >24</a></li><li class=\"uk-disabled\"><span>&hellip;</span></li><li><a href=\"/foo?page=50\"   >50</a></li><li><a href=\"/foo?page=21\"   rel=\"next\" ><span uk-pagination-next>Next&nbsp;&rsaquo;</span></a></li></ul>"
      _(view.pagy_uikit_nav(pagy, pagy_id: 'test-nav-id', link_extra: 'link-extra')).must_equal \
        "<ul id=\"test-nav-id\" class=\"pagy-uikit-nav uk-pagination uk-flex-center\"><li><a href=\"/foo?page=19\"  link-extra rel=\"prev\" ><span uk-pagination-previous>&lsaquo;&nbsp;Prev</span></a></li><li><a href=\"/foo?page=1\"  link-extra >1</a></li><li class=\"uk-disabled\"><span>&hellip;</span></li><li><a href=\"/foo?page=16\"  link-extra >16</a></li><li><a href=\"/foo?page=17\"  link-extra >17</a></li><li><a href=\"/foo?page=18\"  link-extra >18</a></li><li><a href=\"/foo?page=19\"  link-extra rel=\"prev\" >19</a></li><li class=\"uk-active\"><span>20</span></li><li><a href=\"/foo?page=21\"  link-extra rel=\"next\" >21</a></li><li><a href=\"/foo?page=22\"  link-extra >22</a></li><li><a href=\"/foo?page=23\"  link-extra >23</a></li><li><a href=\"/foo?page=24\"  link-extra >24</a></li><li class=\"uk-disabled\"><span>&hellip;</span></li><li><a href=\"/foo?page=50\"  link-extra >50</a></li><li><a href=\"/foo?page=21\"  link-extra rel=\"next\" ><span uk-pagination-next>Next&nbsp;&rsaquo;</span></a></li></ul>"
    end
    it 'renders last page' do
      pagy = Pagy.new(count: 1000, page: 50)
      _(view.pagy_uikit_nav(pagy)).must_equal \
        "<ul class=\"pagy-uikit-nav uk-pagination uk-flex-center\"><li><a href=\"/foo?page=49\"   rel=\"prev\" ><span uk-pagination-previous>&lsaquo;&nbsp;Prev</span></a></li><li><a href=\"/foo?page=1\"   >1</a></li><li class=\"uk-disabled\"><span>&hellip;</span></li><li><a href=\"/foo?page=46\"   >46</a></li><li><a href=\"/foo?page=47\"   >47</a></li><li><a href=\"/foo?page=48\"   >48</a></li><li><a href=\"/foo?page=49\"   rel=\"prev\" >49</a></li><li class=\"uk-active\"><span>50</span></li><li class=\"uk-disabled\"><a href=\"#\"><span uk-pagination-next>Next&nbsp;&rsaquo;</span></a></li></ul>"
      _(view.pagy_uikit_nav(pagy, pagy_id: 'test-nav-id', link_extra: 'link-extra')).must_equal \
        "<ul id=\"test-nav-id\" class=\"pagy-uikit-nav uk-pagination uk-flex-center\"><li><a href=\"/foo?page=49\"  link-extra rel=\"prev\" ><span uk-pagination-previous>&lsaquo;&nbsp;Prev</span></a></li><li><a href=\"/foo?page=1\"  link-extra >1</a></li><li class=\"uk-disabled\"><span>&hellip;</span></li><li><a href=\"/foo?page=46\"  link-extra >46</a></li><li><a href=\"/foo?page=47\"  link-extra >47</a></li><li><a href=\"/foo?page=48\"  link-extra >48</a></li><li><a href=\"/foo?page=49\"  link-extra rel=\"prev\" >49</a></li><li class=\"uk-active\"><span>50</span></li><li class=\"uk-disabled\"><a href=\"#\"><span uk-pagination-next>Next&nbsp;&rsaquo;</span></a></li></ul>"
    end
  end

  describe '#pagy_uikit_nav_js' do
    it 'renders first page' do
      pagy = Pagy.new(count: 1000, page: 1)
      _(view.pagy_uikit_nav_js(pagy)).must_equal \
        "<ul class=\"pagy-njs pagy-uikit-nav-js uk-pagination uk-flex-center\"></ul><script type=\"application/json\" class=\"pagy-json\">[\"nav\",{\"before\":\"<li class=\\\"uk-disabled\\\"><a href=\\\"#\\\"><span uk-pagination-previous>&lsaquo;&nbsp;Prev</span></a></li>\",\"link\":\"<li><a href=\\\"/foo?page=__pagy_page__\\\"   >__pagy_page__</a></li>\",\"active\":\"<li class=\\\"uk-active\\\"><span>__pagy_page__</span></li>\",\"gap\":\"<li class=\\\"uk-disabled\\\"><span>&hellip;</span></li>\",\"after\":\"<li><a href=\\\"/foo?page=2\\\"   rel=\\\"next\\\" ><span uk-pagination-next>Next&nbsp;&rsaquo;</span></a></li>\"},{\"0\":[\"1\",2,3,4,5,\"gap\",50]}]</script>"
      _(view.pagy_uikit_nav_js(pagy, pagy_id: 'test-nav-id', link_extra: 'link-extra', steps: {0 => [1,2,2,1], 600 => [1,3,3,1]})).must_equal \
        "<ul id=\"test-nav-id\" class=\"pagy-njs pagy-uikit-nav-js uk-pagination uk-flex-center\"></ul><script type=\"application/json\" class=\"pagy-json\">[\"nav\",{\"before\":\"<li class=\\\"uk-disabled\\\"><a href=\\\"#\\\"><span uk-pagination-previous>&lsaquo;&nbsp;Prev</span></a></li>\",\"link\":\"<li><a href=\\\"/foo?page=__pagy_page__\\\"  link-extra >__pagy_page__</a></li>\",\"active\":\"<li class=\\\"uk-active\\\"><span>__pagy_page__</span></li>\",\"gap\":\"<li class=\\\"uk-disabled\\\"><span>&hellip;</span></li>\",\"after\":\"<li><a href=\\\"/foo?page=2\\\"  link-extra rel=\\\"next\\\" ><span uk-pagination-next>Next&nbsp;&rsaquo;</span></a></li>\"},{\"0\":[\"1\",2,3,\"gap\",50],\"600\":[\"1\",2,3,4,\"gap\",50]}]</script>"
    end
    it 'renders intermediate page' do
      pagy = Pagy.new(count: 1000, page: 20)
      _(view.pagy_uikit_nav_js(pagy)).must_equal \
        "<ul class=\"pagy-njs pagy-uikit-nav-js uk-pagination uk-flex-center\"></ul><script type=\"application/json\" class=\"pagy-json\">[\"nav\",{\"before\":\"<li><a href=\\\"/foo?page=19\\\"   rel=\\\"prev\\\" ><span uk-pagination-previous>&lsaquo;&nbsp;Prev</span></a></li>\",\"link\":\"<li><a href=\\\"/foo?page=__pagy_page__\\\"   >__pagy_page__</a></li>\",\"active\":\"<li class=\\\"uk-active\\\"><span>__pagy_page__</span></li>\",\"gap\":\"<li class=\\\"uk-disabled\\\"><span>&hellip;</span></li>\",\"after\":\"<li><a href=\\\"/foo?page=21\\\"   rel=\\\"next\\\" ><span uk-pagination-next>Next&nbsp;&rsaquo;</span></a></li>\"},{\"0\":[1,\"gap\",16,17,18,19,\"20\",21,22,23,24,\"gap\",50]}]</script>"
      _(view.pagy_uikit_nav_js(pagy, pagy_id: 'test-nav-id', link_extra: 'link-extra', steps: {0 => [1,2,2,1], 600 => [1,3,3,1]})).must_equal \
        "<ul id=\"test-nav-id\" class=\"pagy-njs pagy-uikit-nav-js uk-pagination uk-flex-center\"></ul><script type=\"application/json\" class=\"pagy-json\">[\"nav\",{\"before\":\"<li><a href=\\\"/foo?page=19\\\"  link-extra rel=\\\"prev\\\" ><span uk-pagination-previous>&lsaquo;&nbsp;Prev</span></a></li>\",\"link\":\"<li><a href=\\\"/foo?page=__pagy_page__\\\"  link-extra >__pagy_page__</a></li>\",\"active\":\"<li class=\\\"uk-active\\\"><span>__pagy_page__</span></li>\",\"gap\":\"<li class=\\\"uk-disabled\\\"><span>&hellip;</span></li>\",\"after\":\"<li><a href=\\\"/foo?page=21\\\"  link-extra rel=\\\"next\\\" ><span uk-pagination-next>Next&nbsp;&rsaquo;</span></a></li>\"},{\"0\":[1,\"gap\",18,19,\"20\",21,22,\"gap\",50],\"600\":[1,\"gap\",17,18,19,\"20\",21,22,23,\"gap\",50]}]</script>"
    end
    it 'renders last page' do
      pagy = Pagy.new(count: 1000, page: 50)
      _(view.pagy_uikit_nav_js(pagy)).must_equal \
        "<ul class=\"pagy-njs pagy-uikit-nav-js uk-pagination uk-flex-center\"></ul><script type=\"application/json\" class=\"pagy-json\">[\"nav\",{\"before\":\"<li><a href=\\\"/foo?page=49\\\"   rel=\\\"prev\\\" ><span uk-pagination-previous>&lsaquo;&nbsp;Prev</span></a></li>\",\"link\":\"<li><a href=\\\"/foo?page=__pagy_page__\\\"   >__pagy_page__</a></li>\",\"active\":\"<li class=\\\"uk-active\\\"><span>__pagy_page__</span></li>\",\"gap\":\"<li class=\\\"uk-disabled\\\"><span>&hellip;</span></li>\",\"after\":\"<li class=\\\"uk-disabled\\\"><a href=\\\"#\\\"><span uk-pagination-next>Next&nbsp;&rsaquo;</span></a></li>\"},{\"0\":[1,\"gap\",46,47,48,49,\"50\"]}]</script>"
      _(view.pagy_uikit_nav_js(pagy, pagy_id: 'test-nav-id', link_extra: 'link-extra', steps: {0 => [1,2,2,1], 600 => [1,3,3,1]})).must_equal \
        "<ul id=\"test-nav-id\" class=\"pagy-njs pagy-uikit-nav-js uk-pagination uk-flex-center\"></ul><script type=\"application/json\" class=\"pagy-json\">[\"nav\",{\"before\":\"<li><a href=\\\"/foo?page=49\\\"  link-extra rel=\\\"prev\\\" ><span uk-pagination-previous>&lsaquo;&nbsp;Prev</span></a></li>\",\"link\":\"<li><a href=\\\"/foo?page=__pagy_page__\\\"  link-extra >__pagy_page__</a></li>\",\"active\":\"<li class=\\\"uk-active\\\"><span>__pagy_page__</span></li>\",\"gap\":\"<li class=\\\"uk-disabled\\\"><span>&hellip;</span></li>\",\"after\":\"<li class=\\\"uk-disabled\\\"><a href=\\\"#\\\"><span uk-pagination-next>Next&nbsp;&rsaquo;</span></a></li>\"},{\"0\":[1,\"gap\",48,49,\"50\"],\"600\":[1,\"gap\",47,48,49,\"50\"]}]</script>"
    end
    it 'renders with :steps' do
      pagy = Pagy.new(count: 1000, page: 20, steps: {0 => [1,2,2,1], 500 => [2,3,3,2]})
      _(view.pagy_uikit_nav_js(pagy)).must_equal \
        "<ul class=\"pagy-njs pagy-uikit-nav-js uk-pagination uk-flex-center\"></ul><script type=\"application/json\" class=\"pagy-json\">[\"nav\",{\"before\":\"<li><a href=\\\"/foo?page=19\\\"   rel=\\\"prev\\\" ><span uk-pagination-previous>&lsaquo;&nbsp;Prev</span></a></li>\",\"link\":\"<li><a href=\\\"/foo?page=__pagy_page__\\\"   >__pagy_page__</a></li>\",\"active\":\"<li class=\\\"uk-active\\\"><span>__pagy_page__</span></li>\",\"gap\":\"<li class=\\\"uk-disabled\\\"><span>&hellip;</span></li>\",\"after\":\"<li><a href=\\\"/foo?page=21\\\"   rel=\\\"next\\\" ><span uk-pagination-next>Next&nbsp;&rsaquo;</span></a></li>\"},{\"0\":[1,\"gap\",18,19,\"20\",21,22,\"gap\",50],\"500\":[1,2,\"gap\",17,18,19,\"20\",21,22,23,\"gap\",49,50]}]</script>"
      _(view.pagy_uikit_nav_js(pagy, pagy_id: 'test-nav-id', link_extra: 'link-extra', steps: {0 => [1,2,2,1], 600 => [1,3,3,1]})).must_equal \
        "<ul id=\"test-nav-id\" class=\"pagy-njs pagy-uikit-nav-js uk-pagination uk-flex-center\"></ul><script type=\"application/json\" class=\"pagy-json\">[\"nav\",{\"before\":\"<li><a href=\\\"/foo?page=19\\\"  link-extra rel=\\\"prev\\\" ><span uk-pagination-previous>&lsaquo;&nbsp;Prev</span></a></li>\",\"link\":\"<li><a href=\\\"/foo?page=__pagy_page__\\\"  link-extra >__pagy_page__</a></li>\",\"active\":\"<li class=\\\"uk-active\\\"><span>__pagy_page__</span></li>\",\"gap\":\"<li class=\\\"uk-disabled\\\"><span>&hellip;</span></li>\",\"after\":\"<li><a href=\\\"/foo?page=21\\\"  link-extra rel=\\\"next\\\" ><span uk-pagination-next>Next&nbsp;&rsaquo;</span></a></li>\"},{\"0\":[1,\"gap\",18,19,\"20\",21,22,\"gap\",50],\"600\":[1,\"gap\",17,18,19,\"20\",21,22,23,\"gap\",50]}]</script>"
    end
  end

  describe '#pagy_uikit_combo_nav' do
    it 'renders first page' do
      pagy = Pagy.new(count: 1000, page: 1)
      _(view.pagy_uikit_combo_nav_js(pagy)).must_equal \
        "<div class=\"pagy-uikit-combo-nav-js uk-button-group\"><button class=\"uk-button uk-button-default\" disabled>&lsaquo;&nbsp;Prev</button><div class=\"uk-text-middle uk-margin-left uk-margin-right\">Page <input type=\"number\" min=\"1\" max=\"50\" value=\"1\" class=\"uk-input\" style=\"padding: 0; text-align: center; width: 3rem;\"> of 50</div><a href=\"/foo?page=2\"   rel=\"next\" class=\"uk-button uk-button-default\">Next&nbsp;&rsaquo;</a></div><script type=\"application/json\" class=\"pagy-json\">[\"combo_nav\",1,\"<a href=\\\"/foo?page=__pagy_page__\\\"   style=\\\"display: none;\\\"></a>\"]</script>"
      _(view.pagy_uikit_combo_nav_js(pagy, pagy_id: 'test-nav-id', link_extra: 'link-extra')).must_equal \
        "<div id=\"test-nav-id\" class=\"pagy-uikit-combo-nav-js uk-button-group\"><button class=\"uk-button uk-button-default\" disabled>&lsaquo;&nbsp;Prev</button><div class=\"uk-text-middle uk-margin-left uk-margin-right\">Page <input type=\"number\" min=\"1\" max=\"50\" value=\"1\" class=\"uk-input\" style=\"padding: 0; text-align: center; width: 3rem;\"> of 50</div><a href=\"/foo?page=2\"  link-extra rel=\"next\" class=\"uk-button uk-button-default\">Next&nbsp;&rsaquo;</a></div><script type=\"application/json\" class=\"pagy-json\">[\"combo_nav\",1,\"<a href=\\\"/foo?page=__pagy_page__\\\"  link-extra style=\\\"display: none;\\\"></a>\"]</script>"
    end
    it 'renders intermediate page' do
      pagy = Pagy.new(count: 1000, page: 20)
      _(view.pagy_uikit_combo_nav_js(pagy)).must_equal \
        "<div class=\"pagy-uikit-combo-nav-js uk-button-group\"><a href=\"/foo?page=19\"   rel=\"prev\" class=\"uk-button uk-button-default\">&lsaquo;&nbsp;Prev</a><div class=\"uk-text-middle uk-margin-left uk-margin-right\">Page <input type=\"number\" min=\"1\" max=\"50\" value=\"20\" class=\"uk-input\" style=\"padding: 0; text-align: center; width: 3rem;\"> of 50</div><a href=\"/foo?page=21\"   rel=\"next\" class=\"uk-button uk-button-default\">Next&nbsp;&rsaquo;</a></div><script type=\"application/json\" class=\"pagy-json\">[\"combo_nav\",20,\"<a href=\\\"/foo?page=__pagy_page__\\\"   style=\\\"display: none;\\\"></a>\"]</script>"
      _(view.pagy_uikit_combo_nav_js(pagy, pagy_id: 'test-nav-id', link_extra: 'link-extra')).must_equal \
        "<div id=\"test-nav-id\" class=\"pagy-uikit-combo-nav-js uk-button-group\"><a href=\"/foo?page=19\"  link-extra rel=\"prev\" class=\"uk-button uk-button-default\">&lsaquo;&nbsp;Prev</a><div class=\"uk-text-middle uk-margin-left uk-margin-right\">Page <input type=\"number\" min=\"1\" max=\"50\" value=\"20\" class=\"uk-input\" style=\"padding: 0; text-align: center; width: 3rem;\"> of 50</div><a href=\"/foo?page=21\"  link-extra rel=\"next\" class=\"uk-button uk-button-default\">Next&nbsp;&rsaquo;</a></div><script type=\"application/json\" class=\"pagy-json\">[\"combo_nav\",20,\"<a href=\\\"/foo?page=__pagy_page__\\\"  link-extra style=\\\"display: none;\\\"></a>\"]</script>"
    end
    it 'renders last page' do
      pagy = Pagy.new(count: 1000, page: 50)
      _(view.pagy_uikit_combo_nav_js(pagy)).must_equal \
        "<div class=\"pagy-uikit-combo-nav-js uk-button-group\"><a href=\"/foo?page=49\"   rel=\"prev\" class=\"uk-button uk-button-default\">&lsaquo;&nbsp;Prev</a><div class=\"uk-text-middle uk-margin-left uk-margin-right\">Page <input type=\"number\" min=\"1\" max=\"50\" value=\"50\" class=\"uk-input\" style=\"padding: 0; text-align: center; width: 3rem;\"> of 50</div><button class=\"uk-button uk-button-default\" disabled>Next&nbsp;&rsaquo;</button></div><script type=\"application/json\" class=\"pagy-json\">[\"combo_nav\",50,\"<a href=\\\"/foo?page=__pagy_page__\\\"   style=\\\"display: none;\\\"></a>\"]</script>"
      _(view.pagy_uikit_combo_nav_js(pagy, pagy_id: 'test-nav-id', link_extra: 'link-extra')).must_equal \
        "<div id=\"test-nav-id\" class=\"pagy-uikit-combo-nav-js uk-button-group\"><a href=\"/foo?page=49\"  link-extra rel=\"prev\" class=\"uk-button uk-button-default\">&lsaquo;&nbsp;Prev</a><div class=\"uk-text-middle uk-margin-left uk-margin-right\">Page <input type=\"number\" min=\"1\" max=\"50\" value=\"50\" class=\"uk-input\" style=\"padding: 0; text-align: center; width: 3rem;\"> of 50</div><button class=\"uk-button uk-button-default\" disabled>Next&nbsp;&rsaquo;</button></div><script type=\"application/json\" class=\"pagy-json\">[\"combo_nav\",50,\"<a href=\\\"/foo?page=__pagy_page__\\\"  link-extra style=\\\"display: none;\\\"></a>\"]</script>"
    end
  end
end
