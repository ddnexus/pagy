# frozen_string_literal: true

require_relative '../../test_helper'
require 'pagy/extras/navs'

describe 'pagy/extras/navs' do
  let(:view) { MockView.new }

  describe '#pagy_nav_js' do
    it 'renders first page' do
      pagy = Pagy.new(count: 1000, page: 1)
      _(view.pagy_nav_js(pagy)).must_equal \
        "<nav class=\"pagy-njs pagy-nav-js pagination\" role=\"navigation\" aria-label=\"pager\"></nav><script type=\"application/json\" class=\"pagy-json\">[\"nav\",{\"before\":\"<span class=\\\"page prev disabled\\\">&lsaquo;&nbsp;Prev</span> \",\"link\":\"<span class=\\\"page\\\"><a href=\\\"/foo?page=__pagy_page__\\\"   >__pagy_page__</a></span> \",\"active\":\"<span class=\\\"page active\\\">1</span> \",\"gap\":\"<span class=\\\"page gap\\\">&hellip;</span> \",\"after\":\"<span class=\\\"page next\\\"><a href=\\\"/foo?page=2\\\"   rel=\\\"next\\\" aria-label=\\\"next\\\">Next&nbsp;&rsaquo;</a></span>\"},{\"0\":[\"1\",2,3,4,5,\"gap\",50]}]</script>"
      _(view.pagy_nav_js(pagy, pagy_id: 'test-nav-id', link_extra: 'link-extra', steps: {0 => [1,2,2,1], 600 => [1,3,3,1]})).must_equal \
        "<nav id=\"test-nav-id\" class=\"pagy-njs pagy-nav-js pagination\" role=\"navigation\" aria-label=\"pager\"></nav><script type=\"application/json\" class=\"pagy-json\">[\"nav\",{\"before\":\"<span class=\\\"page prev disabled\\\">&lsaquo;&nbsp;Prev</span> \",\"link\":\"<span class=\\\"page\\\"><a href=\\\"/foo?page=__pagy_page__\\\"  link-extra >__pagy_page__</a></span> \",\"active\":\"<span class=\\\"page active\\\">1</span> \",\"gap\":\"<span class=\\\"page gap\\\">&hellip;</span> \",\"after\":\"<span class=\\\"page next\\\"><a href=\\\"/foo?page=2\\\"  link-extra rel=\\\"next\\\" aria-label=\\\"next\\\">Next&nbsp;&rsaquo;</a></span>\"},{\"0\":[\"1\",2,3,\"gap\",50],\"600\":[\"1\",2,3,4,\"gap\",50]}]</script>"
    end
    it 'renders intermediate page' do
      pagy = Pagy.new(count: 1000, page: 20)
      _(view.pagy_nav_js(pagy)).must_equal \
        "<nav class=\"pagy-njs pagy-nav-js pagination\" role=\"navigation\" aria-label=\"pager\"></nav><script type=\"application/json\" class=\"pagy-json\">[\"nav\",{\"before\":\"<span class=\\\"page prev\\\"><a href=\\\"/foo?page=19\\\"   rel=\\\"prev\\\" aria-label=\\\"previous\\\">&lsaquo;&nbsp;Prev</a></span> \",\"link\":\"<span class=\\\"page\\\"><a href=\\\"/foo?page=__pagy_page__\\\"   >__pagy_page__</a></span> \",\"active\":\"<span class=\\\"page active\\\">20</span> \",\"gap\":\"<span class=\\\"page gap\\\">&hellip;</span> \",\"after\":\"<span class=\\\"page next\\\"><a href=\\\"/foo?page=21\\\"   rel=\\\"next\\\" aria-label=\\\"next\\\">Next&nbsp;&rsaquo;</a></span>\"},{\"0\":[1,\"gap\",16,17,18,19,\"20\",21,22,23,24,\"gap\",50]}]</script>"
      _(view.pagy_nav_js(pagy, pagy_id: 'test-nav-id', link_extra: 'link-extra', steps: {0 => [1,2,2,1], 600 => [1,3,3,1]})).must_equal \
        "<nav id=\"test-nav-id\" class=\"pagy-njs pagy-nav-js pagination\" role=\"navigation\" aria-label=\"pager\"></nav><script type=\"application/json\" class=\"pagy-json\">[\"nav\",{\"before\":\"<span class=\\\"page prev\\\"><a href=\\\"/foo?page=19\\\"  link-extra rel=\\\"prev\\\" aria-label=\\\"previous\\\">&lsaquo;&nbsp;Prev</a></span> \",\"link\":\"<span class=\\\"page\\\"><a href=\\\"/foo?page=__pagy_page__\\\"  link-extra >__pagy_page__</a></span> \",\"active\":\"<span class=\\\"page active\\\">20</span> \",\"gap\":\"<span class=\\\"page gap\\\">&hellip;</span> \",\"after\":\"<span class=\\\"page next\\\"><a href=\\\"/foo?page=21\\\"  link-extra rel=\\\"next\\\" aria-label=\\\"next\\\">Next&nbsp;&rsaquo;</a></span>\"},{\"0\":[1,\"gap\",18,19,\"20\",21,22,\"gap\",50],\"600\":[1,\"gap\",17,18,19,\"20\",21,22,23,\"gap\",50]}]</script>"
    end
    it 'renders last page' do
      pagy = Pagy.new(count: 1000, page: 50)
      _(view.pagy_nav_js(pagy)).must_equal \
        "<nav class=\"pagy-njs pagy-nav-js pagination\" role=\"navigation\" aria-label=\"pager\"></nav><script type=\"application/json\" class=\"pagy-json\">[\"nav\",{\"before\":\"<span class=\\\"page prev\\\"><a href=\\\"/foo?page=49\\\"   rel=\\\"prev\\\" aria-label=\\\"previous\\\">&lsaquo;&nbsp;Prev</a></span> \",\"link\":\"<span class=\\\"page\\\"><a href=\\\"/foo?page=__pagy_page__\\\"   >__pagy_page__</a></span> \",\"active\":\"<span class=\\\"page active\\\">50</span> \",\"gap\":\"<span class=\\\"page gap\\\">&hellip;</span> \",\"after\":\"<span class=\\\"page next disabled\\\">Next&nbsp;&rsaquo;</span>\"},{\"0\":[1,\"gap\",46,47,48,49,\"50\"]}]</script>"
      _(view.pagy_nav_js(pagy, pagy_id: 'test-nav-id', link_extra: 'link-extra', steps: {0 => [1,2,2,1], 600 => [1,3,3,1]})).must_equal \
        "<nav id=\"test-nav-id\" class=\"pagy-njs pagy-nav-js pagination\" role=\"navigation\" aria-label=\"pager\"></nav><script type=\"application/json\" class=\"pagy-json\">[\"nav\",{\"before\":\"<span class=\\\"page prev\\\"><a href=\\\"/foo?page=49\\\"  link-extra rel=\\\"prev\\\" aria-label=\\\"previous\\\">&lsaquo;&nbsp;Prev</a></span> \",\"link\":\"<span class=\\\"page\\\"><a href=\\\"/foo?page=__pagy_page__\\\"  link-extra >__pagy_page__</a></span> \",\"active\":\"<span class=\\\"page active\\\">50</span> \",\"gap\":\"<span class=\\\"page gap\\\">&hellip;</span> \",\"after\":\"<span class=\\\"page next disabled\\\">Next&nbsp;&rsaquo;</span>\"},{\"0\":[1,\"gap\",48,49,\"50\"],\"600\":[1,\"gap\",47,48,49,\"50\"]}]</script>"
    end
    it 'renders with :steps' do
      pagy = Pagy.new(count: 1000, page: 20, steps: {0 => [1,2,2,1], 500 => [2,3,3,2]})
      _(view.pagy_nav_js(pagy)).must_equal \
        "<nav class=\"pagy-njs pagy-nav-js pagination\" role=\"navigation\" aria-label=\"pager\"></nav><script type=\"application/json\" class=\"pagy-json\">[\"nav\",{\"before\":\"<span class=\\\"page prev\\\"><a href=\\\"/foo?page=19\\\"   rel=\\\"prev\\\" aria-label=\\\"previous\\\">&lsaquo;&nbsp;Prev</a></span> \",\"link\":\"<span class=\\\"page\\\"><a href=\\\"/foo?page=__pagy_page__\\\"   >__pagy_page__</a></span> \",\"active\":\"<span class=\\\"page active\\\">20</span> \",\"gap\":\"<span class=\\\"page gap\\\">&hellip;</span> \",\"after\":\"<span class=\\\"page next\\\"><a href=\\\"/foo?page=21\\\"   rel=\\\"next\\\" aria-label=\\\"next\\\">Next&nbsp;&rsaquo;</a></span>\"},{\"0\":[1,\"gap\",18,19,\"20\",21,22,\"gap\",50],\"500\":[1,2,\"gap\",17,18,19,\"20\",21,22,23,\"gap\",49,50]}]</script>"
      _(view.pagy_nav_js(pagy, pagy_id: 'test-nav-id', link_extra: 'link-extra', steps: {0 => [1,2,2,1], 600 => [1,3,3,1]})).must_equal \
        "<nav id=\"test-nav-id\" class=\"pagy-njs pagy-nav-js pagination\" role=\"navigation\" aria-label=\"pager\"></nav><script type=\"application/json\" class=\"pagy-json\">[\"nav\",{\"before\":\"<span class=\\\"page prev\\\"><a href=\\\"/foo?page=19\\\"  link-extra rel=\\\"prev\\\" aria-label=\\\"previous\\\">&lsaquo;&nbsp;Prev</a></span> \",\"link\":\"<span class=\\\"page\\\"><a href=\\\"/foo?page=__pagy_page__\\\"  link-extra >__pagy_page__</a></span> \",\"active\":\"<span class=\\\"page active\\\">20</span> \",\"gap\":\"<span class=\\\"page gap\\\">&hellip;</span> \",\"after\":\"<span class=\\\"page next\\\"><a href=\\\"/foo?page=21\\\"  link-extra rel=\\\"next\\\" aria-label=\\\"next\\\">Next&nbsp;&rsaquo;</a></span>\"},{\"0\":[1,\"gap\",18,19,\"20\",21,22,\"gap\",50],\"600\":[1,\"gap\",17,18,19,\"20\",21,22,23,\"gap\",50]}]</script>"
    end
  end

  describe '#pagy_combo_nav_js' do
    it 'renders first page' do
      pagy = Pagy.new(count: 103, page: 1)
      _(view.pagy_combo_nav_js(pagy)).must_equal \
        "<nav class=\"pagy-combo-nav-js pagination\" role=\"navigation\" aria-label=\"pager\"><span class=\"page prev disabled\">&lsaquo;&nbsp;Prev</span> <span class=\"pagy-combo-input\" style=\"margin: 0 0.6rem;\">Page <input type=\"number\" min=\"1\" max=\"6\" value=\"1\" style=\"padding: 0; text-align: center; width: 2rem;\"> of 6</span> <span class=\"page next\"><a href=\"/foo?page=2\"   rel=\"next\" aria-label=\"next\">Next&nbsp;&rsaquo;</a></span></nav><script type=\"application/json\" class=\"pagy-json\">[\"combo_nav\",1,\"<a href=\\\"/foo?page=__pagy_page__\\\"   style=\\\"display: none;\\\"></a>\"]</script>"
      _(view.pagy_combo_nav_js(pagy, pagy_id: 'test-nav-id', link_extra: 'link-extra')).must_equal \
        "<nav id=\"test-nav-id\" class=\"pagy-combo-nav-js pagination\" role=\"navigation\" aria-label=\"pager\"><span class=\"page prev disabled\">&lsaquo;&nbsp;Prev</span> <span class=\"pagy-combo-input\" style=\"margin: 0 0.6rem;\">Page <input type=\"number\" min=\"1\" max=\"6\" value=\"1\" style=\"padding: 0; text-align: center; width: 2rem;\"> of 6</span> <span class=\"page next\"><a href=\"/foo?page=2\"  link-extra rel=\"next\" aria-label=\"next\">Next&nbsp;&rsaquo;</a></span></nav><script type=\"application/json\" class=\"pagy-json\">[\"combo_nav\",1,\"<a href=\\\"/foo?page=__pagy_page__\\\"  link-extra style=\\\"display: none;\\\"></a>\"]</script>"
    end
    it 'renders intermediate page' do
      pagy = Pagy.new(count: 103, page: 3)
      _(view.pagy_combo_nav_js(pagy)).must_equal \
        "<nav class=\"pagy-combo-nav-js pagination\" role=\"navigation\" aria-label=\"pager\"><span class=\"page prev\"><a href=\"/foo?page=2\"   rel=\"prev\" aria-label=\"previous\">&lsaquo;&nbsp;Prev</a></span> <span class=\"pagy-combo-input\" style=\"margin: 0 0.6rem;\">Page <input type=\"number\" min=\"1\" max=\"6\" value=\"3\" style=\"padding: 0; text-align: center; width: 2rem;\"> of 6</span> <span class=\"page next\"><a href=\"/foo?page=4\"   rel=\"next\" aria-label=\"next\">Next&nbsp;&rsaquo;</a></span></nav><script type=\"application/json\" class=\"pagy-json\">[\"combo_nav\",3,\"<a href=\\\"/foo?page=__pagy_page__\\\"   style=\\\"display: none;\\\"></a>\"]</script>"
      _(view.pagy_combo_nav_js(pagy, pagy_id: 'test-nav-id', link_extra: 'link-extra')).must_equal \
        "<nav id=\"test-nav-id\" class=\"pagy-combo-nav-js pagination\" role=\"navigation\" aria-label=\"pager\"><span class=\"page prev\"><a href=\"/foo?page=2\"  link-extra rel=\"prev\" aria-label=\"previous\">&lsaquo;&nbsp;Prev</a></span> <span class=\"pagy-combo-input\" style=\"margin: 0 0.6rem;\">Page <input type=\"number\" min=\"1\" max=\"6\" value=\"3\" style=\"padding: 0; text-align: center; width: 2rem;\"> of 6</span> <span class=\"page next\"><a href=\"/foo?page=4\"  link-extra rel=\"next\" aria-label=\"next\">Next&nbsp;&rsaquo;</a></span></nav><script type=\"application/json\" class=\"pagy-json\">[\"combo_nav\",3,\"<a href=\\\"/foo?page=__pagy_page__\\\"  link-extra style=\\\"display: none;\\\"></a>\"]</script>"
    end
    it 'renders last page' do
      pagy = Pagy.new(count: 103, page: 6)
      _(view.pagy_combo_nav_js(pagy)).must_equal \
        "<nav class=\"pagy-combo-nav-js pagination\" role=\"navigation\" aria-label=\"pager\"><span class=\"page prev\"><a href=\"/foo?page=5\"   rel=\"prev\" aria-label=\"previous\">&lsaquo;&nbsp;Prev</a></span> <span class=\"pagy-combo-input\" style=\"margin: 0 0.6rem;\">Page <input type=\"number\" min=\"1\" max=\"6\" value=\"6\" style=\"padding: 0; text-align: center; width: 2rem;\"> of 6</span> <span class=\"page next disabled\">Next&nbsp;&rsaquo;</span></nav><script type=\"application/json\" class=\"pagy-json\">[\"combo_nav\",6,\"<a href=\\\"/foo?page=__pagy_page__\\\"   style=\\\"display: none;\\\"></a>\"]</script>"
      _(view.pagy_combo_nav_js(pagy, pagy_id: 'test-nav-id', link_extra: 'link-extra')).must_equal \
        "<nav id=\"test-nav-id\" class=\"pagy-combo-nav-js pagination\" role=\"navigation\" aria-label=\"pager\"><span class=\"page prev\"><a href=\"/foo?page=5\"  link-extra rel=\"prev\" aria-label=\"previous\">&lsaquo;&nbsp;Prev</a></span> <span class=\"pagy-combo-input\" style=\"margin: 0 0.6rem;\">Page <input type=\"number\" min=\"1\" max=\"6\" value=\"6\" style=\"padding: 0; text-align: center; width: 2rem;\"> of 6</span> <span class=\"page next disabled\">Next&nbsp;&rsaquo;</span></nav><script type=\"application/json\" class=\"pagy-json\">[\"combo_nav\",6,\"<a href=\\\"/foo?page=__pagy_page__\\\"  link-extra style=\\\"display: none;\\\"></a>\"]</script>"
    end
  end
end
