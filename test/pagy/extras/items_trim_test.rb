# frozen_string_literal: true

require_relative '../../test_helper'
require 'pagy/extras/items'
require 'pagy/extras/trim'

require_relative '../../mock_helpers/app'

describe 'pagy/extras/items_trim' do
  let(:app) { MockApp.new(params: {}) }

  it 'renders items selector with trim' do
    pagy = Pagy.new count: 1000, page: 3
    _(app.pagy_items_selector_js(pagy, id: 'test-id')).must_rematch :selector_1
    _(app.pagy_items_selector_js(pagy, id: 'test-id', item_name: 'products')).must_rematch :selector_2
    Pagy::I18n::DATA['en'][0]['activerecord.models.product.other'] = 'products'
    pagy = Pagy.new count: 1000, page: 3, items_extra: false
    _(app.pagy_items_selector_js(pagy, id: 'test-id')).must_equal ''
  end
end
