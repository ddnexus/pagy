# frozen_string_literal: true

require_relative '../../test_helper'
require 'pagy/extras/items'
require 'pagy/extras/trim'

SimpleCov.command_name 'shared_combo' if ENV['RUN_SIMPLECOV'] == 'true'

# add tests for oj and pagy_id
describe Pagy::Frontend do

  let(:view) { MockView.new('http://example.com:3000/foo?') }

  describe '#pagy_marked_link' do

    it 'should return the marked link' do
      pagy = Pagy.new(count: 100, page: 4)
      _(view.pagy_marked_link(view.pagy_link_proc(pagy))).must_equal "<a href=\"/foo?page=__pagy_page__&items=20\"   style=\"display: none;\"></a>"

      pagy = Pagy.new(count: 100, page: 4, page_param: 'p')
      _(view.pagy_marked_link(view.pagy_link_proc(pagy))).must_equal "<a href=\"/foo?p=__pagy_page__&items=20\"   style=\"display: none;\"></a>"

      pagy = Pagy.new(count: 100, page: 4, items_param: 'i')
      _(view.pagy_marked_link(view.pagy_link_proc(pagy))).must_equal "<a href=\"/foo?page=__pagy_page__&i=20\"   style=\"display: none;\"></a>"

      pagy = Pagy.new(count: 100, page: 4, page_param: 'p', items_param: 'i')
      _(view.pagy_marked_link(view.pagy_link_proc(pagy))).must_equal "<a href=\"/foo?p=__pagy_page__&i=20\"   style=\"display: none;\"></a>"

    end

  end

  describe '#pagy_items_selector_js' do

    it 'renders items selector with trim' do
      pagy = Pagy.new count: 1000, page: 3
      _(view.pagy_items_selector_js(pagy, 'test-id')).must_equal "<span id=\"test-id\">Show <input type=\"number\" min=\"1\" max=\"100\" value=\"20\" style=\"padding: 0; text-align: center; width: 3rem;\"> items per page</span><script type=\"application/json\" class=\"pagy-json\">[\"items_selector\",\"test-id\",41,\"<a href=\\\"/foo?page=__pagy_page__&items=__pagy_items__\\\"   style=\\\"display: none;\\\"></a>\",\"page\"]</script>"
    end

  end


end

