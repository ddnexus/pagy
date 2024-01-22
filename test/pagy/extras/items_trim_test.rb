# frozen_string_literal: true

require_relative '../../test_helper'
require 'pagy/extras/items'
require 'pagy/extras/trim'

require_relative '../../mock_helpers/app'

describe 'pagy/extras/items_trim' do
  let(:app) { MockApp.new(params: {}) }

  describe '#pagy_marked_link' do
    it 'should return the marked link' do
      pagy = Pagy.new(count: 100, page: 4)
      _(app.pagy_marked_link(app.pagy_link_proc(pagy))).must_rematch :link_1
      pagy = Pagy.new(count: 100, page: 4, page_param: 'p')
      _(app.pagy_marked_link(app.pagy_link_proc(pagy))).must_rematch :link_2
      pagy = Pagy.new(count: 100, page: 4, items_param: 'i')
      _(app.pagy_marked_link(app.pagy_link_proc(pagy))).must_rematch :link_3
      pagy = Pagy.new(count: 100, page: 4, page_param: 'p', items_param: 'i')
      _(app.pagy_marked_link(app.pagy_link_proc(pagy))).must_rematch :link_4
    end
  end
  it 'renders items selector with trim' do
    pagy = Pagy.new count: 1000, page: 3
    _(app.pagy_items_selector_js(pagy, pagy_id: 'test-id')).must_rematch :selector_1
    _(app.pagy_items_selector_js(pagy, pagy_id: 'test-id', item_name: 'products')).must_rematch :selector_2
    Pagy::I18n::DATA['en'][0]['activerecord.models.product.other'] = 'products'
    _(app.pagy_items_selector_js(pagy, pagy_id: 'test-id', item_i18n_key: 'activerecord.models.product')).must_rematch :selector_3
    pagy = Pagy.new count: 1000, page: 3, items_extra: false
    _(app.pagy_items_selector_js(pagy, pagy_id: 'test-id')).must_equal ''
  end
end
