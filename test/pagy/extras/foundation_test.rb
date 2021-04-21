# frozen_string_literal: true

require_relative '../../test_helper'
require 'pagy/extras/foundation'

describe Pagy::Frontend do

  let(:view) { MockView.new }

  describe '#pagy_foundation_nav' do

    it 'renders first page' do
      pagy = Pagy.new(count: 1000, page: 1)
      _(view.pagy_foundation_nav(pagy)).must_equal \
        "<nav class=\"pagy-foundation-nav\" role=\"navigation\" aria-label=\"Pagination\"><ul class=\"pagination\"><li class=\"prev disabled\">&lsaquo;&nbsp;Prev</li><li class=\"current\">1</li><li><a href=\"/foo?page=2\"   rel=\"next\" >2</a></li><li><a href=\"/foo?page=3\"   >3</a></li><li><a href=\"/foo?page=4\"   >4</a></li><li><a href=\"/foo?page=5\"   >5</a></li><li class=\"ellipsis gap\" aria-hidden=\"true\"></li><li><a href=\"/foo?page=50\"   >50</a></li><li class=\"next\"><a href=\"/foo?page=2\"   rel=\"next\" aria-label=\"next\">Next&nbsp;&rsaquo;</a></li></ul></nav>"
      _(view.pagy_foundation_nav(pagy, pagy_id: 'test-nav-id', link_extra: 'link-extra')).must_equal \
        "<nav id=\"test-nav-id\" class=\"pagy-foundation-nav\" role=\"navigation\" aria-label=\"Pagination\"><ul class=\"pagination\"><li class=\"prev disabled\">&lsaquo;&nbsp;Prev</li><li class=\"current\">1</li><li><a href=\"/foo?page=2\"  link-extra rel=\"next\" >2</a></li><li><a href=\"/foo?page=3\"  link-extra >3</a></li><li><a href=\"/foo?page=4\"  link-extra >4</a></li><li><a href=\"/foo?page=5\"  link-extra >5</a></li><li class=\"ellipsis gap\" aria-hidden=\"true\"></li><li><a href=\"/foo?page=50\"  link-extra >50</a></li><li class=\"next\"><a href=\"/foo?page=2\"  link-extra rel=\"next\" aria-label=\"next\">Next&nbsp;&rsaquo;</a></li></ul></nav>"
    end

    it 'renders intermediate page' do
      pagy = Pagy.new(count: 1000, page: 20)
      _(view.pagy_foundation_nav(pagy)).must_equal \
        "<nav class=\"pagy-foundation-nav\" role=\"navigation\" aria-label=\"Pagination\"><ul class=\"pagination\"><li class=\"prev\"><a href=\"/foo?page=19\"   rel=\"prev\" aria-label=\"previous\">&lsaquo;&nbsp;Prev</a></li><li><a href=\"/foo?page=1\"   >1</a></li><li class=\"ellipsis gap\" aria-hidden=\"true\"></li><li><a href=\"/foo?page=16\"   >16</a></li><li><a href=\"/foo?page=17\"   >17</a></li><li><a href=\"/foo?page=18\"   >18</a></li><li><a href=\"/foo?page=19\"   rel=\"prev\" >19</a></li><li class=\"current\">20</li><li><a href=\"/foo?page=21\"   rel=\"next\" >21</a></li><li><a href=\"/foo?page=22\"   >22</a></li><li><a href=\"/foo?page=23\"   >23</a></li><li><a href=\"/foo?page=24\"   >24</a></li><li class=\"ellipsis gap\" aria-hidden=\"true\"></li><li><a href=\"/foo?page=50\"   >50</a></li><li class=\"next\"><a href=\"/foo?page=21\"   rel=\"next\" aria-label=\"next\">Next&nbsp;&rsaquo;</a></li></ul></nav>"
      _(view.pagy_foundation_nav(pagy, pagy_id: 'test-nav-id', link_extra: 'link-extra')).must_equal \
        "<nav id=\"test-nav-id\" class=\"pagy-foundation-nav\" role=\"navigation\" aria-label=\"Pagination\"><ul class=\"pagination\"><li class=\"prev\"><a href=\"/foo?page=19\"  link-extra rel=\"prev\" aria-label=\"previous\">&lsaquo;&nbsp;Prev</a></li><li><a href=\"/foo?page=1\"  link-extra >1</a></li><li class=\"ellipsis gap\" aria-hidden=\"true\"></li><li><a href=\"/foo?page=16\"  link-extra >16</a></li><li><a href=\"/foo?page=17\"  link-extra >17</a></li><li><a href=\"/foo?page=18\"  link-extra >18</a></li><li><a href=\"/foo?page=19\"  link-extra rel=\"prev\" >19</a></li><li class=\"current\">20</li><li><a href=\"/foo?page=21\"  link-extra rel=\"next\" >21</a></li><li><a href=\"/foo?page=22\"  link-extra >22</a></li><li><a href=\"/foo?page=23\"  link-extra >23</a></li><li><a href=\"/foo?page=24\"  link-extra >24</a></li><li class=\"ellipsis gap\" aria-hidden=\"true\"></li><li><a href=\"/foo?page=50\"  link-extra >50</a></li><li class=\"next\"><a href=\"/foo?page=21\"  link-extra rel=\"next\" aria-label=\"next\">Next&nbsp;&rsaquo;</a></li></ul></nav>"
    end

    it 'renders last page' do
      pagy = Pagy.new(count: 1000, page: 50)
      _(view.pagy_foundation_nav(pagy)).must_equal \
        "<nav class=\"pagy-foundation-nav\" role=\"navigation\" aria-label=\"Pagination\"><ul class=\"pagination\"><li class=\"prev\"><a href=\"/foo?page=49\"   rel=\"prev\" aria-label=\"previous\">&lsaquo;&nbsp;Prev</a></li><li><a href=\"/foo?page=1\"   >1</a></li><li class=\"ellipsis gap\" aria-hidden=\"true\"></li><li><a href=\"/foo?page=46\"   >46</a></li><li><a href=\"/foo?page=47\"   >47</a></li><li><a href=\"/foo?page=48\"   >48</a></li><li><a href=\"/foo?page=49\"   rel=\"prev\" >49</a></li><li class=\"current\">50</li><li class=\"next disabled\">Next&nbsp;&rsaquo;</li></ul></nav>"
      _(view.pagy_foundation_nav(pagy, pagy_id: 'test-nav-id', link_extra: 'link-extra')).must_equal \
        "<nav id=\"test-nav-id\" class=\"pagy-foundation-nav\" role=\"navigation\" aria-label=\"Pagination\"><ul class=\"pagination\"><li class=\"prev\"><a href=\"/foo?page=49\"  link-extra rel=\"prev\" aria-label=\"previous\">&lsaquo;&nbsp;Prev</a></li><li><a href=\"/foo?page=1\"  link-extra >1</a></li><li class=\"ellipsis gap\" aria-hidden=\"true\"></li><li><a href=\"/foo?page=46\"  link-extra >46</a></li><li><a href=\"/foo?page=47\"  link-extra >47</a></li><li><a href=\"/foo?page=48\"  link-extra >48</a></li><li><a href=\"/foo?page=49\"  link-extra rel=\"prev\" >49</a></li><li class=\"current\">50</li><li class=\"next disabled\">Next&nbsp;&rsaquo;</li></ul></nav>"
    end

  end

  describe '#pagy_foundation_nav_js' do

    it 'renders first page' do
      pagy = Pagy.new(count: 1000, page: 1)
      _(view.pagy_foundation_nav_js(pagy)).must_equal \
        "<nav class=\"pagy-foundation-nav-js\" role=\"navigation\" aria-label=\"Pagination\"></nav><script type=\"application/json\" class=\"pagy-json\">[\"nav\",{\"before\":\"<ul class=\\\"pagination\\\"><li class=\\\"prev disabled\\\">&lsaquo;&nbsp;Prev</li>\",\"link\":\"<li><a href=\\\"/foo?page=__pagy_page__\\\"   >__pagy_page__</a></li>\",\"active\":\"<li class=\\\"current\\\">1</li>\",\"gap\":\"<li class=\\\"ellipsis gap\\\" aria-hidden=\\\"true\\\"></li>\",\"after\":\"<li class=\\\"next\\\"><a href=\\\"/foo?page=2\\\"   rel=\\\"next\\\" aria-label=\\\"next\\\">Next&nbsp;&rsaquo;</a></li></ul>\"},{\"0\":[\"1\",2,3,4,5,\"gap\",50]}]</script>"
      _(view.pagy_foundation_nav_js(pagy, pagy_id: 'test-nav-id', link_extra: 'link-extra', steps: {0 => [1,2,2,1], 600 => [1,3,3,1]})).must_equal \
        "<nav id=\"test-nav-id\" class=\"pagy-foundation-nav-js\" role=\"navigation\" aria-label=\"Pagination\"></nav><script type=\"application/json\" class=\"pagy-json\">[\"nav\",{\"before\":\"<ul class=\\\"pagination\\\"><li class=\\\"prev disabled\\\">&lsaquo;&nbsp;Prev</li>\",\"link\":\"<li><a href=\\\"/foo?page=__pagy_page__\\\"  link-extra >__pagy_page__</a></li>\",\"active\":\"<li class=\\\"current\\\">1</li>\",\"gap\":\"<li class=\\\"ellipsis gap\\\" aria-hidden=\\\"true\\\"></li>\",\"after\":\"<li class=\\\"next\\\"><a href=\\\"/foo?page=2\\\"  link-extra rel=\\\"next\\\" aria-label=\\\"next\\\">Next&nbsp;&rsaquo;</a></li></ul>\"},{\"0\":[\"1\",2,3,\"gap\",50],\"600\":[\"1\",2,3,4,\"gap\",50]}]</script>"
    end

    it 'renders intermediate page' do
      pagy = Pagy.new(count: 1000, page: 20)
      _(view.pagy_foundation_nav_js(pagy)).must_equal \
        "<nav class=\"pagy-foundation-nav-js\" role=\"navigation\" aria-label=\"Pagination\"></nav><script type=\"application/json\" class=\"pagy-json\">[\"nav\",{\"before\":\"<ul class=\\\"pagination\\\"><li class=\\\"prev\\\"><a href=\\\"/foo?page=19\\\"   rel=\\\"prev\\\" aria-label=\\\"previous\\\">&lsaquo;&nbsp;Prev</a></li>\",\"link\":\"<li><a href=\\\"/foo?page=__pagy_page__\\\"   >__pagy_page__</a></li>\",\"active\":\"<li class=\\\"current\\\">20</li>\",\"gap\":\"<li class=\\\"ellipsis gap\\\" aria-hidden=\\\"true\\\"></li>\",\"after\":\"<li class=\\\"next\\\"><a href=\\\"/foo?page=21\\\"   rel=\\\"next\\\" aria-label=\\\"next\\\">Next&nbsp;&rsaquo;</a></li></ul>\"},{\"0\":[1,\"gap\",16,17,18,19,\"20\",21,22,23,24,\"gap\",50]}]</script>"
      _(view.pagy_foundation_nav_js(pagy, pagy_id: 'test-nav-id', link_extra: 'link-extra', steps: {0 => [1,2,2,1], 600 => [1,3,3,1]})).must_equal \
        "<nav id=\"test-nav-id\" class=\"pagy-foundation-nav-js\" role=\"navigation\" aria-label=\"Pagination\"></nav><script type=\"application/json\" class=\"pagy-json\">[\"nav\",{\"before\":\"<ul class=\\\"pagination\\\"><li class=\\\"prev\\\"><a href=\\\"/foo?page=19\\\"  link-extra rel=\\\"prev\\\" aria-label=\\\"previous\\\">&lsaquo;&nbsp;Prev</a></li>\",\"link\":\"<li><a href=\\\"/foo?page=__pagy_page__\\\"  link-extra >__pagy_page__</a></li>\",\"active\":\"<li class=\\\"current\\\">20</li>\",\"gap\":\"<li class=\\\"ellipsis gap\\\" aria-hidden=\\\"true\\\"></li>\",\"after\":\"<li class=\\\"next\\\"><a href=\\\"/foo?page=21\\\"  link-extra rel=\\\"next\\\" aria-label=\\\"next\\\">Next&nbsp;&rsaquo;</a></li></ul>\"},{\"0\":[1,\"gap\",18,19,\"20\",21,22,\"gap\",50],\"600\":[1,\"gap\",17,18,19,\"20\",21,22,23,\"gap\",50]}]</script>"
    end

    it 'renders last page' do
      pagy = Pagy.new(count: 1000, page: 50)
      _(view.pagy_foundation_nav_js(pagy)).must_equal \
        "<nav class=\"pagy-foundation-nav-js\" role=\"navigation\" aria-label=\"Pagination\"></nav><script type=\"application/json\" class=\"pagy-json\">[\"nav\",{\"before\":\"<ul class=\\\"pagination\\\"><li class=\\\"prev\\\"><a href=\\\"/foo?page=49\\\"   rel=\\\"prev\\\" aria-label=\\\"previous\\\">&lsaquo;&nbsp;Prev</a></li>\",\"link\":\"<li><a href=\\\"/foo?page=__pagy_page__\\\"   >__pagy_page__</a></li>\",\"active\":\"<li class=\\\"current\\\">50</li>\",\"gap\":\"<li class=\\\"ellipsis gap\\\" aria-hidden=\\\"true\\\"></li>\",\"after\":\"<li class=\\\"next disabled\\\">Next&nbsp;&rsaquo;</li></ul>\"},{\"0\":[1,\"gap\",46,47,48,49,\"50\"]}]</script>"
      _(view.pagy_foundation_nav_js(pagy, pagy_id: 'test-nav-id', link_extra: 'link-extra', steps: {0 => [1,2,2,1], 600 => [1,3,3,1]})).must_equal \
        "<nav id=\"test-nav-id\" class=\"pagy-foundation-nav-js\" role=\"navigation\" aria-label=\"Pagination\"></nav><script type=\"application/json\" class=\"pagy-json\">[\"nav\",{\"before\":\"<ul class=\\\"pagination\\\"><li class=\\\"prev\\\"><a href=\\\"/foo?page=49\\\"  link-extra rel=\\\"prev\\\" aria-label=\\\"previous\\\">&lsaquo;&nbsp;Prev</a></li>\",\"link\":\"<li><a href=\\\"/foo?page=__pagy_page__\\\"  link-extra >__pagy_page__</a></li>\",\"active\":\"<li class=\\\"current\\\">50</li>\",\"gap\":\"<li class=\\\"ellipsis gap\\\" aria-hidden=\\\"true\\\"></li>\",\"after\":\"<li class=\\\"next disabled\\\">Next&nbsp;&rsaquo;</li></ul>\"},{\"0\":[1,\"gap\",48,49,\"50\"],\"600\":[1,\"gap\",47,48,49,\"50\"]}]</script>"
    end

    it 'renders with :steps' do
      pagy = Pagy.new(count: 1000, page: 20, steps: {0 => [1,2,2,1], 500 => [2,3,3,2]})
      _(view.pagy_foundation_nav_js(pagy)).must_equal \
        "<nav class=\"pagy-foundation-nav-js\" role=\"navigation\" aria-label=\"Pagination\"></nav><script type=\"application/json\" class=\"pagy-json\">[\"nav\",{\"before\":\"<ul class=\\\"pagination\\\"><li class=\\\"prev\\\"><a href=\\\"/foo?page=19\\\"   rel=\\\"prev\\\" aria-label=\\\"previous\\\">&lsaquo;&nbsp;Prev</a></li>\",\"link\":\"<li><a href=\\\"/foo?page=__pagy_page__\\\"   >__pagy_page__</a></li>\",\"active\":\"<li class=\\\"current\\\">20</li>\",\"gap\":\"<li class=\\\"ellipsis gap\\\" aria-hidden=\\\"true\\\"></li>\",\"after\":\"<li class=\\\"next\\\"><a href=\\\"/foo?page=21\\\"   rel=\\\"next\\\" aria-label=\\\"next\\\">Next&nbsp;&rsaquo;</a></li></ul>\"},{\"0\":[1,\"gap\",18,19,\"20\",21,22,\"gap\",50],\"500\":[1,2,\"gap\",17,18,19,\"20\",21,22,23,\"gap\",49,50]}]</script>"
      _(view.pagy_foundation_nav_js(pagy, pagy_id: 'test-nav-id', link_extra: 'link-extra', steps: {0 => [1,2,2,1], 600 => [1,3,3,1]})).must_equal \
        "<nav id=\"test-nav-id\" class=\"pagy-foundation-nav-js\" role=\"navigation\" aria-label=\"Pagination\"></nav><script type=\"application/json\" class=\"pagy-json\">[\"nav\",{\"before\":\"<ul class=\\\"pagination\\\"><li class=\\\"prev\\\"><a href=\\\"/foo?page=19\\\"  link-extra rel=\\\"prev\\\" aria-label=\\\"previous\\\">&lsaquo;&nbsp;Prev</a></li>\",\"link\":\"<li><a href=\\\"/foo?page=__pagy_page__\\\"  link-extra >__pagy_page__</a></li>\",\"active\":\"<li class=\\\"current\\\">20</li>\",\"gap\":\"<li class=\\\"ellipsis gap\\\" aria-hidden=\\\"true\\\"></li>\",\"after\":\"<li class=\\\"next\\\"><a href=\\\"/foo?page=21\\\"  link-extra rel=\\\"next\\\" aria-label=\\\"next\\\">Next&nbsp;&rsaquo;</a></li></ul>\"},{\"0\":[1,\"gap\",18,19,\"20\",21,22,\"gap\",50],\"600\":[1,\"gap\",17,18,19,\"20\",21,22,23,\"gap\",50]}]</script>"
    end

  end

  describe '#pagy_foundation_combo_nav_js' do

    it 'renders first page' do
      pagy = Pagy.new(count: 103, page: 1)
      _(view.pagy_foundation_combo_nav_js(pagy)).must_equal \
        "<nav class=\"pagy-foundation-combo-nav-js\" role=\"navigation\" aria-label=\"Pagination\"><div class=\"input-group\"><a style=\"margin-bottom: 0px;\" class=\"prev button primary disabled\" href=\"#\">&lsaquo;&nbsp;Prev</a><span class=\"input-group-label\">Page <input class=\"input-group-field cell shrink\" type=\"number\" min=\"1\" max=\"6\" value=\"1\" style=\"width: 2rem; padding: 0 0.3rem; margin: 0 0.3rem;\"> of 6</span><a href=\"/foo?page=2\"   rel=\"next\" style=\"margin-bottom: 0px;\" aria-label=\"next\" class=\"next button primary\">Next&nbsp;&rsaquo;</a></div></nav><script type=\"application/json\" class=\"pagy-json\">[\"combo_nav\",1,\"<a href=\\\"/foo?page=__pagy_page__\\\"   style=\\\"display: none;\\\"></a>\"]</script>"
      _(view.pagy_foundation_combo_nav_js(pagy, pagy_id: 'test-nav-id', link_extra: 'link-extra')).must_equal \
        "<nav id=\"test-nav-id\" class=\"pagy-foundation-combo-nav-js\" role=\"navigation\" aria-label=\"Pagination\"><div class=\"input-group\"><a style=\"margin-bottom: 0px;\" class=\"prev button primary disabled\" href=\"#\">&lsaquo;&nbsp;Prev</a><span class=\"input-group-label\">Page <input class=\"input-group-field cell shrink\" type=\"number\" min=\"1\" max=\"6\" value=\"1\" style=\"width: 2rem; padding: 0 0.3rem; margin: 0 0.3rem;\"> of 6</span><a href=\"/foo?page=2\"  link-extra rel=\"next\" style=\"margin-bottom: 0px;\" aria-label=\"next\" class=\"next button primary\">Next&nbsp;&rsaquo;</a></div></nav><script type=\"application/json\" class=\"pagy-json\">[\"combo_nav\",1,\"<a href=\\\"/foo?page=__pagy_page__\\\"  link-extra style=\\\"display: none;\\\"></a>\"]</script>"
    end

    it 'renders intermediate page' do
      pagy = Pagy.new(count: 103, page: 3)
      _(view.pagy_foundation_combo_nav_js(pagy)).must_equal \
        "<nav class=\"pagy-foundation-combo-nav-js\" role=\"navigation\" aria-label=\"Pagination\"><div class=\"input-group\"><a href=\"/foo?page=2\"   rel=\"prev\" style=\"margin-bottom: 0px;\" aria-label=\"previous\" class=\"prev button primary\">&lsaquo;&nbsp;Prev</a><span class=\"input-group-label\">Page <input class=\"input-group-field cell shrink\" type=\"number\" min=\"1\" max=\"6\" value=\"3\" style=\"width: 2rem; padding: 0 0.3rem; margin: 0 0.3rem;\"> of 6</span><a href=\"/foo?page=4\"   rel=\"next\" style=\"margin-bottom: 0px;\" aria-label=\"next\" class=\"next button primary\">Next&nbsp;&rsaquo;</a></div></nav><script type=\"application/json\" class=\"pagy-json\">[\"combo_nav\",3,\"<a href=\\\"/foo?page=__pagy_page__\\\"   style=\\\"display: none;\\\"></a>\"]</script>"
      _(view.pagy_foundation_combo_nav_js(pagy, pagy_id: 'test-nav-id', link_extra: 'link-extra')).must_equal \
        "<nav id=\"test-nav-id\" class=\"pagy-foundation-combo-nav-js\" role=\"navigation\" aria-label=\"Pagination\"><div class=\"input-group\"><a href=\"/foo?page=2\"  link-extra rel=\"prev\" style=\"margin-bottom: 0px;\" aria-label=\"previous\" class=\"prev button primary\">&lsaquo;&nbsp;Prev</a><span class=\"input-group-label\">Page <input class=\"input-group-field cell shrink\" type=\"number\" min=\"1\" max=\"6\" value=\"3\" style=\"width: 2rem; padding: 0 0.3rem; margin: 0 0.3rem;\"> of 6</span><a href=\"/foo?page=4\"  link-extra rel=\"next\" style=\"margin-bottom: 0px;\" aria-label=\"next\" class=\"next button primary\">Next&nbsp;&rsaquo;</a></div></nav><script type=\"application/json\" class=\"pagy-json\">[\"combo_nav\",3,\"<a href=\\\"/foo?page=__pagy_page__\\\"  link-extra style=\\\"display: none;\\\"></a>\"]</script>"
    end

    it 'renders last page' do
      pagy = Pagy.new(count: 103, page: 6)
      _(view.pagy_foundation_combo_nav_js(pagy)).must_equal \
        "<nav class=\"pagy-foundation-combo-nav-js\" role=\"navigation\" aria-label=\"Pagination\"><div class=\"input-group\"><a href=\"/foo?page=5\"   rel=\"prev\" style=\"margin-bottom: 0px;\" aria-label=\"previous\" class=\"prev button primary\">&lsaquo;&nbsp;Prev</a><span class=\"input-group-label\">Page <input class=\"input-group-field cell shrink\" type=\"number\" min=\"1\" max=\"6\" value=\"6\" style=\"width: 2rem; padding: 0 0.3rem; margin: 0 0.3rem;\"> of 6</span><a style=\"margin-bottom: 0px;\" class=\"next button primary disabled\" href=\"#\">Next&nbsp;&rsaquo;</a></div></nav><script type=\"application/json\" class=\"pagy-json\">[\"combo_nav\",6,\"<a href=\\\"/foo?page=__pagy_page__\\\"   style=\\\"display: none;\\\"></a>\"]</script>"
      _(view.pagy_foundation_combo_nav_js(pagy, pagy_id: 'test-nav-id', link_extra: 'link-extra')).must_equal \
        "<nav id=\"test-nav-id\" class=\"pagy-foundation-combo-nav-js\" role=\"navigation\" aria-label=\"Pagination\"><div class=\"input-group\"><a href=\"/foo?page=5\"  link-extra rel=\"prev\" style=\"margin-bottom: 0px;\" aria-label=\"previous\" class=\"prev button primary\">&lsaquo;&nbsp;Prev</a><span class=\"input-group-label\">Page <input class=\"input-group-field cell shrink\" type=\"number\" min=\"1\" max=\"6\" value=\"6\" style=\"width: 2rem; padding: 0 0.3rem; margin: 0 0.3rem;\"> of 6</span><a style=\"margin-bottom: 0px;\" class=\"next button primary disabled\" href=\"#\">Next&nbsp;&rsaquo;</a></div></nav><script type=\"application/json\" class=\"pagy-json\">[\"combo_nav\",6,\"<a href=\\\"/foo?page=__pagy_page__\\\"  link-extra style=\\\"display: none;\\\"></a>\"]</script>"
    end

  end

end
