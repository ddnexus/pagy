# frozen_string_literal: true

require_relative '../../test_helper'
require 'pagy/extras/items'
require 'pagy/extras/trim'

describe 'pagy/extras/items_trim' do
  let(:view) { MockView.new('http://example.com:3000/foo?') }

  describe '#pagy_marked_link' do
    it 'should return the marked link' do
      pagy = Pagy.new(count: 100, page: 4)
      _(view.pagy_marked_link(view.pagy_link_proc(pagy))).must_equal \
        "<a href=\"/foo?page=__pagy_page__&items=20\"   style=\"display: none;\"></a>"
      pagy = Pagy.new(count: 100, page: 4, page_param: 'p')
      _(view.pagy_marked_link(view.pagy_link_proc(pagy))).must_equal \
        "<a href=\"/foo?p=__pagy_page__&items=20\"   style=\"display: none;\"></a>"
      pagy = Pagy.new(count: 100, page: 4, items_param: 'i')
      _(view.pagy_marked_link(view.pagy_link_proc(pagy))).must_equal \
        "<a href=\"/foo?page=__pagy_page__&i=20\"   style=\"display: none;\"></a>"
      pagy = Pagy.new(count: 100, page: 4, page_param: 'p', items_param: 'i')
      _(view.pagy_marked_link(view.pagy_link_proc(pagy))).must_equal \
        "<a href=\"/foo?p=__pagy_page__&i=20\"   style=\"display: none;\"></a>"
    end
  end
  it 'renders items selector with trim' do
    pagy = Pagy.new count: 1000, page: 3
    _(view.pagy_items_selector_js(pagy, pagy_id: 'test-id')).must_equal \
      "<span id=\"test-id\" class=\"pagy-items-selector-js\">Show <input type=\"number\" min=\"1\" max=\"100\" value=\"20\" style=\"padding: 0; text-align: center; width: 3rem;\"> items per page</span><script type=\"application/json\" class=\"pagy-json\">[\"items_selector\",41,\"<a href=\\\"/foo?page=__pagy_page__&items=__pagy_items__\\\"   style=\\\"display: none;\\\"></a>\",\"page\"]</script>"
    _(view.pagy_items_selector_js(pagy, pagy_id: 'test-id', item_name: 'products')).must_equal \
      "<span id=\"test-id\" class=\"pagy-items-selector-js\">Show <input type=\"number\" min=\"1\" max=\"100\" value=\"20\" style=\"padding: 0; text-align: center; width: 3rem;\"> products per page</span><script type=\"application/json\" class=\"pagy-json\">[\"items_selector\",41,\"<a href=\\\"/foo?page=__pagy_page__&items=__pagy_items__\\\"   style=\\\"display: none;\\\"></a>\",\"page\"]</script>"
    Pagy::I18n['en'][0]['activerecord.models.product.other'] = ->(_){ 'products'}
    _(view.pagy_items_selector_js(pagy, pagy_id: 'test-id', i18n_key: 'activerecord.models.product')).must_equal \
      "<span id=\"test-id\" class=\"pagy-items-selector-js\">Show <input type=\"number\" min=\"1\" max=\"100\" value=\"20\" style=\"padding: 0; text-align: center; width: 3rem;\"> products per page</span><script type=\"application/json\" class=\"pagy-json\">[\"items_selector\",41,\"<a href=\\\"/foo?page=__pagy_page__&items=__pagy_items__\\\"   style=\\\"display: none;\\\"></a>\",\"page\"]</script>"
    pagy = Pagy.new count: 1000, page: 3, enable_items_extra: false
    _(view.pagy_items_selector_js(pagy, pagy_id: 'test-id')).must_equal ''
  end
end

