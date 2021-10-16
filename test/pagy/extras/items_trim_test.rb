# frozen_string_literal: true

require_relative '../../test_helper'
require 'pagy/extras/items'
require 'pagy/extras/trim'

require_relative '../../mock_helpers/view'

describe 'pagy/extras/items_trim' do
  let(:view) { MockView.new('http://example.com:3000/foo?') }

  describe '#pagy_marked_link' do
    it 'should return the marked link' do
      pagy = Pagy.new(count: 100, page: 4)
      _(view.pagy_marked_link(view.pagy_link_proc(pagy))).must_rematch
      pagy = Pagy.new(count: 100, page: 4, page_param: 'p')
      _(view.pagy_marked_link(view.pagy_link_proc(pagy))).must_rematch
      pagy = Pagy.new(count: 100, page: 4, items_param: 'i')
      _(view.pagy_marked_link(view.pagy_link_proc(pagy))).must_rematch
      pagy = Pagy.new(count: 100, page: 4, page_param: 'p', items_param: 'i')
      _(view.pagy_marked_link(view.pagy_link_proc(pagy))).must_rematch
    end
  end
  it 'renders items selector with trim' do
    pagy = Pagy.new count: 1000, page: 3
    _(view.pagy_items_selector_js(pagy, pagy_id: 'test-id')).must_rematch
    _(view.pagy_items_selector_js(pagy, pagy_id: 'test-id', item_name: 'products')).must_rematch
    Pagy::I18n::DATA['en'][0]['activerecord.models.product.other'] = 'products'
    _(view.pagy_items_selector_js(pagy, pagy_id: 'test-id', i18n_key: 'activerecord.models.product')).must_rematch
    pagy = Pagy.new count: 1000, page: 3, items_extra: false
    _(view.pagy_items_selector_js(pagy, pagy_id: 'test-id')).must_equal ''
  end
end
