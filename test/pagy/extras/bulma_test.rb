# frozen_string_literal: true

require_relative '../../test_helper'
require 'pagy/extras/bulma'

describe Pagy::Frontend do

  let(:view) { MockView.new }
  let(:pagy_test_id) { 'test-id' }

  describe '#pagy_bulma_nav' do

    it 'renders first page' do
      pagy = Pagy.new(count: 1000, page: 1)
      _(view.pagy_bulma_nav(pagy)).must_equal "<nav class=\"pagy-bulma-nav pagination is-centered\" role=\"navigation\" aria-label=\"pagination\"><a class=\"pagination-previous\" disabled>&lsaquo;&nbsp;Prev</a><a href=\"/foo?page=2\"   rel=\"next\" class=\"pagination-next\" aria-label=\"next page\">Next&nbsp;&rsaquo;</a><ul class=\"pagination-list\"><li><a href=\"/foo?page=1\"   class=\"pagination-link is-current\" aria-label=\"page 1\" aria-current=\"page\">1</a></li><li><a href=\"/foo?page=2\"   rel=\"next\" class=\"pagination-link\" aria-label=\"goto page 2\">2</a></li><li><a href=\"/foo?page=3\"   class=\"pagination-link\" aria-label=\"goto page 3\">3</a></li><li><a href=\"/foo?page=4\"   class=\"pagination-link\" aria-label=\"goto page 4\">4</a></li><li><a href=\"/foo?page=5\"   class=\"pagination-link\" aria-label=\"goto page 5\">5</a></li><li><span class=\"pagination-ellipsis\">&hellip;</span></li><li><a href=\"/foo?page=50\"   class=\"pagination-link\" aria-label=\"goto page 50\">50</a></li></ul></nav>"
    end

    it 'renders intermediate page' do
      pagy = Pagy.new(count: 1000, page: 20)
      _(view.pagy_bulma_nav(pagy)).must_equal "<nav class=\"pagy-bulma-nav pagination is-centered\" role=\"navigation\" aria-label=\"pagination\"><a href=\"/foo?page=19\"   rel=\"prev\" class=\"pagination-previous\" aria-label=\"previous page\">&lsaquo;&nbsp;Prev</a><a href=\"/foo?page=21\"   rel=\"next\" class=\"pagination-next\" aria-label=\"next page\">Next&nbsp;&rsaquo;</a><ul class=\"pagination-list\"><li><a href=\"/foo?page=1\"   class=\"pagination-link\" aria-label=\"goto page 1\">1</a></li><li><span class=\"pagination-ellipsis\">&hellip;</span></li><li><a href=\"/foo?page=16\"   class=\"pagination-link\" aria-label=\"goto page 16\">16</a></li><li><a href=\"/foo?page=17\"   class=\"pagination-link\" aria-label=\"goto page 17\">17</a></li><li><a href=\"/foo?page=18\"   class=\"pagination-link\" aria-label=\"goto page 18\">18</a></li><li><a href=\"/foo?page=19\"   rel=\"prev\" class=\"pagination-link\" aria-label=\"goto page 19\">19</a></li><li><a href=\"/foo?page=20\"   class=\"pagination-link is-current\" aria-label=\"page 20\" aria-current=\"page\">20</a></li><li><a href=\"/foo?page=21\"   rel=\"next\" class=\"pagination-link\" aria-label=\"goto page 21\">21</a></li><li><a href=\"/foo?page=22\"   class=\"pagination-link\" aria-label=\"goto page 22\">22</a></li><li><a href=\"/foo?page=23\"   class=\"pagination-link\" aria-label=\"goto page 23\">23</a></li><li><a href=\"/foo?page=24\"   class=\"pagination-link\" aria-label=\"goto page 24\">24</a></li><li><span class=\"pagination-ellipsis\">&hellip;</span></li><li><a href=\"/foo?page=50\"   class=\"pagination-link\" aria-label=\"goto page 50\">50</a></li></ul></nav>"
    end

    it 'renders last page' do
      pagy = Pagy.new(count: 1000, page: 50)
      _(view.pagy_bulma_nav(pagy)).must_equal "<nav class=\"pagy-bulma-nav pagination is-centered\" role=\"navigation\" aria-label=\"pagination\"><a href=\"/foo?page=49\"   rel=\"prev\" class=\"pagination-previous\" aria-label=\"previous page\">&lsaquo;&nbsp;Prev</a><a class=\"pagination-next\" disabled>Next&nbsp;&rsaquo;</a><ul class=\"pagination-list\"><li><a href=\"/foo?page=1\"   class=\"pagination-link\" aria-label=\"goto page 1\">1</a></li><li><span class=\"pagination-ellipsis\">&hellip;</span></li><li><a href=\"/foo?page=46\"   class=\"pagination-link\" aria-label=\"goto page 46\">46</a></li><li><a href=\"/foo?page=47\"   class=\"pagination-link\" aria-label=\"goto page 47\">47</a></li><li><a href=\"/foo?page=48\"   class=\"pagination-link\" aria-label=\"goto page 48\">48</a></li><li><a href=\"/foo?page=49\"   rel=\"prev\" class=\"pagination-link\" aria-label=\"goto page 49\">49</a></li><li><a href=\"/foo?page=50\"   class=\"pagination-link is-current\" aria-label=\"page 50\" aria-current=\"page\">50</a></li></ul></nav>"
    end

  end

  describe '#pagy_bulma_nav_js' do

    it 'renders first page' do
      pagy = Pagy.new(count: 1000, page: 1)
      _(view.pagy_bulma_nav_js(pagy, pagy_test_id)).must_equal "<nav id=\"test-id\" class=\"pagy-bulma-nav-js pagination is-centered\" role=\"navigation\" aria-label=\"pagination\"></nav><script type=\"application/json\" class=\"pagy-json\">[\"nav\",\"test-id\",{\"before\":\"<a class=\\\"pagination-previous\\\" disabled>&lsaquo;&nbsp;Prev</a><a href=\\\"/foo?page=2\\\"   rel=\\\"next\\\" class=\\\"pagination-next\\\" aria-label=\\\"next page\\\">Next&nbsp;&rsaquo;</a><ul class=\\\"pagination-list\\\">\",\"link\":\"<li><a href=\\\"/foo?page=__pagy_page__\\\"   class=\\\"pagination-link\\\" aria-label=\\\"goto page __pagy_page__\\\">__pagy_page__</a></li>\",\"active\":\"<li><a href=\\\"/foo?page=__pagy_page__\\\"   class=\\\"pagination-link is-current\\\" aria-current=\\\"page\\\" aria-label=\\\"page __pagy_page__\\\">__pagy_page__</a></li>\",\"gap\":\"<li><span class=\\\"pagination-ellipsis\\\">&hellip;</span></li>\",\"after\":\"</ul>\"},{\"0\":[\"1\",2,3,4,5,\"gap\",50]}]</script>"
    end

    it 'renders intermediate page' do
      pagy = Pagy.new(count: 1000, page: 20)
      _(view.pagy_bulma_nav_js(pagy, pagy_test_id)).must_equal "<nav id=\"test-id\" class=\"pagy-bulma-nav-js pagination is-centered\" role=\"navigation\" aria-label=\"pagination\"></nav><script type=\"application/json\" class=\"pagy-json\">[\"nav\",\"test-id\",{\"before\":\"<a href=\\\"/foo?page=19\\\"   rel=\\\"prev\\\" class=\\\"pagination-previous\\\" aria-label=\\\"previous page\\\">&lsaquo;&nbsp;Prev</a><a href=\\\"/foo?page=21\\\"   rel=\\\"next\\\" class=\\\"pagination-next\\\" aria-label=\\\"next page\\\">Next&nbsp;&rsaquo;</a><ul class=\\\"pagination-list\\\">\",\"link\":\"<li><a href=\\\"/foo?page=__pagy_page__\\\"   class=\\\"pagination-link\\\" aria-label=\\\"goto page __pagy_page__\\\">__pagy_page__</a></li>\",\"active\":\"<li><a href=\\\"/foo?page=__pagy_page__\\\"   class=\\\"pagination-link is-current\\\" aria-current=\\\"page\\\" aria-label=\\\"page __pagy_page__\\\">__pagy_page__</a></li>\",\"gap\":\"<li><span class=\\\"pagination-ellipsis\\\">&hellip;</span></li>\",\"after\":\"</ul>\"},{\"0\":[1,\"gap\",16,17,18,19,\"20\",21,22,23,24,\"gap\",50]}]</script>"
    end

    it 'renders last page' do
      pagy = Pagy.new(count: 1000, page: 50)
      _(view.pagy_bulma_nav_js(pagy, pagy_test_id)).must_equal "<nav id=\"test-id\" class=\"pagy-bulma-nav-js pagination is-centered\" role=\"navigation\" aria-label=\"pagination\"></nav><script type=\"application/json\" class=\"pagy-json\">[\"nav\",\"test-id\",{\"before\":\"<a href=\\\"/foo?page=49\\\"   rel=\\\"prev\\\" class=\\\"pagination-previous\\\" aria-label=\\\"previous page\\\">&lsaquo;&nbsp;Prev</a><a class=\\\"pagination-next\\\" disabled>Next&nbsp;&rsaquo;</a><ul class=\\\"pagination-list\\\">\",\"link\":\"<li><a href=\\\"/foo?page=__pagy_page__\\\"   class=\\\"pagination-link\\\" aria-label=\\\"goto page __pagy_page__\\\">__pagy_page__</a></li>\",\"active\":\"<li><a href=\\\"/foo?page=__pagy_page__\\\"   class=\\\"pagination-link is-current\\\" aria-current=\\\"page\\\" aria-label=\\\"page __pagy_page__\\\">__pagy_page__</a></li>\",\"gap\":\"<li><span class=\\\"pagination-ellipsis\\\">&hellip;</span></li>\",\"after\":\"</ul>\"},{\"0\":[1,\"gap\",46,47,48,49,\"50\"]}]</script>"
    end

    it 'renders with :steps' do
      pagy = Pagy.new(count: 1000, page: 20, steps: {0 => [1,2,2,1], 500 => [2,3,3,2]})
      _(view.pagy_bulma_nav_js(pagy, pagy_test_id)).must_equal "<nav id=\"test-id\" class=\"pagy-bulma-nav-js pagination is-centered\" role=\"navigation\" aria-label=\"pagination\"></nav><script type=\"application/json\" class=\"pagy-json\">[\"nav\",\"test-id\",{\"before\":\"<a href=\\\"/foo?page=19\\\"   rel=\\\"prev\\\" class=\\\"pagination-previous\\\" aria-label=\\\"previous page\\\">&lsaquo;&nbsp;Prev</a><a href=\\\"/foo?page=21\\\"   rel=\\\"next\\\" class=\\\"pagination-next\\\" aria-label=\\\"next page\\\">Next&nbsp;&rsaquo;</a><ul class=\\\"pagination-list\\\">\",\"link\":\"<li><a href=\\\"/foo?page=__pagy_page__\\\"   class=\\\"pagination-link\\\" aria-label=\\\"goto page __pagy_page__\\\">__pagy_page__</a></li>\",\"active\":\"<li><a href=\\\"/foo?page=__pagy_page__\\\"   class=\\\"pagination-link is-current\\\" aria-current=\\\"page\\\" aria-label=\\\"page __pagy_page__\\\">__pagy_page__</a></li>\",\"gap\":\"<li><span class=\\\"pagination-ellipsis\\\">&hellip;</span></li>\",\"after\":\"</ul>\"},{\"0\":[1,\"gap\",18,19,\"20\",21,22,\"gap\",50],\"500\":[1,2,\"gap\",17,18,19,\"20\",21,22,23,\"gap\",49,50]}]</script>"
    end

  end

  describe '#pagy_bulma_combo_nav_js' do

    it 'renders first page' do
      pagy = Pagy.new(count: 103, page: 1)
      _(view.pagy_bulma_combo_nav_js(pagy, pagy_test_id)).must_equal "<nav id=\"test-id\" class=\"pagy-bulma-combo-nav-js\" role=\"navigation\" aria-label=\"pagination\"><div class=\"field is-grouped is-grouped-centered\" role=\"group\"><p class=\"control\"><a class=\"button\" disabled>&lsaquo;&nbsp;Prev</a></p><div class=\"pagy-combo-input control level is-mobile\">Page <input class=\"input\" type=\"number\" min=\"1\" max=\"6\" value=\"1\" style=\"padding: 0; text-align: center; width: 2rem; margin:0 0.3rem;\"> of 6</div><p class=\"control\"><a href=\"/foo?page=2\"   rel=\"next\" class=\"button\" aria-label=\"next page\">Next&nbsp;&rsaquo;</a></p></div></nav><script type=\"application/json\" class=\"pagy-json\">[\"combo_nav\",\"test-id\",1,\"<a href=\\\"/foo?page=__pagy_page__\\\"   style=\\\"display: none;\\\"></a>\"]</script>"
    end

    it 'renders intermediate page' do
      pagy = Pagy.new(count: 103, page: 3)
      html = view.pagy_bulma_combo_nav_js(pagy, pagy_test_id)
      _(html).must_equal "<nav id=\"test-id\" class=\"pagy-bulma-combo-nav-js\" role=\"navigation\" aria-label=\"pagination\"><div class=\"field is-grouped is-grouped-centered\" role=\"group\"><p class=\"control\"><a href=\"/foo?page=2\"   rel=\"prev\" class=\"button\" aria-label=\"previous page\">&lsaquo;&nbsp;Prev</a></p><div class=\"pagy-combo-input control level is-mobile\">Page <input class=\"input\" type=\"number\" min=\"1\" max=\"6\" value=\"3\" style=\"padding: 0; text-align: center; width: 2rem; margin:0 0.3rem;\"> of 6</div><p class=\"control\"><a href=\"/foo?page=4\"   rel=\"next\" class=\"button\" aria-label=\"next page\">Next&nbsp;&rsaquo;</a></p></div></nav><script type=\"application/json\" class=\"pagy-json\">[\"combo_nav\",\"test-id\",3,\"<a href=\\\"/foo?page=__pagy_page__\\\"   style=\\\"display: none;\\\"></a>\"]</script>"
    end

    it 'renders last page' do
      pagy = Pagy.new(count: 103, page: 6)
      _(view.pagy_bulma_combo_nav_js(pagy, pagy_test_id)).must_equal "<nav id=\"test-id\" class=\"pagy-bulma-combo-nav-js\" role=\"navigation\" aria-label=\"pagination\"><div class=\"field is-grouped is-grouped-centered\" role=\"group\"><p class=\"control\"><a href=\"/foo?page=5\"   rel=\"prev\" class=\"button\" aria-label=\"previous page\">&lsaquo;&nbsp;Prev</a></p><div class=\"pagy-combo-input control level is-mobile\">Page <input class=\"input\" type=\"number\" min=\"1\" max=\"6\" value=\"6\" style=\"padding: 0; text-align: center; width: 2rem; margin:0 0.3rem;\"> of 6</div><p class=\"control\"><a class=\"button\" disabled>Next&nbsp;&rsaquo;</a></p></div></nav><script type=\"application/json\" class=\"pagy-json\">[\"combo_nav\",\"test-id\",6,\"<a href=\\\"/foo?page=__pagy_page__\\\"   style=\\\"display: none;\\\"></a>\"]</script>"
    end

  end

end
