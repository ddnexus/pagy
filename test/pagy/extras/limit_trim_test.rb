# frozen_string_literal: true

require_relative '../../test_helper'
require 'pagy/extras/limit'
require 'pagy/extras/trim'

require_relative '../../mock_helpers/app'

describe 'pagy/extras/limit_trim' do
  let(:app) { MockApp.new(params: {}) }

  it 'renders limit selector with trim' do
    pagy = Pagy.new count: 1000, page: 3
    _(app.pagy_limit_selector_js(pagy, id: 'test-id')).must_rematch :selector_1
    _(app.pagy_limit_selector_js(pagy, id: 'test-id', item_name: 'products')).must_rematch :selector_2
    Pagy::I18n::DATA['en'][0]['activerecord.models.product.other'] = 'products'
    pagy = Pagy.new count: 1000, page: 3, limit_extra: false

    _(app.pagy_limit_selector_js(pagy, id: 'test-id')).must_equal ''
  end
end
