# frozen_string_literal: true

require_relative '../../test_helper'
require 'i18n'
require 'pagy/extras/i18n'

require_relative '../../mock_helpers/app'

describe 'pagy/extras/i18n' do
  let(:app) { MockApp.new }

  describe '#pagy_t with I18n' do
    it 'does not conflict with the I18n gem namespace' do
      app.test_i18n_call
    end
    it 'pluralizes' do
      _(app.pagy_t('pagy.aria_label.prev')).must_equal "Previous"
      _(app.pagy_t('pagy.item_name', count: 0)).must_equal 'items'
      _(app.pagy_t('pagy.item_name', count: 1)).must_equal  'item'
      _(app.pagy_t('pagy.item_name', count: 10)).must_equal 'items'
    end
    it 'handles missing paths' do
      _(app.pagy_t('pagy.not_here')).must_equal 'Translation missing: en.pagy.not_here'
    end
  end

  describe '#pagy_info with I18n' do
    it 'renders info' do
      _(app.pagy_info(Pagy.new(count: 0))).must_rematch :info_0
      _(app.pagy_info(Pagy.new(count: 1))).must_rematch :info_1
      _(app.pagy_info(Pagy.new(count: 13))).must_rematch :info_13
      _(app.pagy_info(Pagy.new(count: 100, page: 3))).must_rematch :info_100
    end
    it 'renders with existing i18n key' do
      I18n.locale = 'en'
      custom_dictionary = Pagy.root.parent.join('test', 'files', 'i18n.yml')
      I18n.load_path += [custom_dictionary]
      _(app.pagy_info(Pagy.new(count: 0, item_i18n_key: 'activerecord.models.product'))).must_rematch :info_1
      _(app.pagy_info(Pagy.new(count: 1, item_i18n_key: 'activerecord.models.product'))).must_rematch :info_2
      _(app.pagy_info(Pagy.new(count: 13, item_i18n_key: 'activerecord.models.product'))).must_rematch :info_3
      _(app.pagy_info(Pagy.new(count: 100, item_i18n_key: 'activerecord.models.product', page: 3))).must_rematch :info_4
      _(app.pagy_info(Pagy.new(count: 0), item_i18n_key: 'activerecord.models.product')).must_rematch :info_5
      _(app.pagy_info(Pagy.new(count: 1), item_i18n_key: 'activerecord.models.product')).must_rematch :info_6
      _(app.pagy_info(Pagy.new(count: 13), item_i18n_key: 'activerecord.models.product')).must_rematch :info_7
      _(app.pagy_info(Pagy.new(count: 100, page: 3), item_i18n_key: 'activerecord.models.product')).must_rematch :info_8
    end
  end
end
