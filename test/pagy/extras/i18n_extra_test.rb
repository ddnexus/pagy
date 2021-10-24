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
      _(app.pagy_t('pagy.nav.prev')).must_equal "&lsaquo;&nbsp;Prev"
      _(app.pagy_t('pagy.item_name', count: 0)).must_equal 'items'
      _(app.pagy_t('pagy.item_name', count: 1)).must_equal  'item'
      _(app.pagy_t('pagy.item_name', count: 10)).must_equal 'items'
    end
    it 'handles missing paths' do
      _(app.pagy_t('pagy.nav.not_here')).must_equal 'translation missing: en.pagy.nav.not_here'
    end
  end

  describe '#pagy_info with I18n' do
    it 'renders info' do
      _(app.pagy_info(Pagy.new(count: 0))).must_rematch
      _(app.pagy_info(Pagy.new(count: 1))).must_rematch
      _(app.pagy_info(Pagy.new(count: 13))).must_rematch
      _(app.pagy_info(Pagy.new(count: 100, page: 3))).must_rematch
    end
    it 'renders with existing i18n key' do
      ::I18n.locale = 'en'
      custom_dictionary = Pagy.root.parent.join('test', 'files', 'i18n.yml')
      ::I18n.load_path += [custom_dictionary]
      _(app.pagy_info(Pagy.new(count: 0, i18n_key: 'activerecord.models.product'))).must_rematch
      _(app.pagy_info(Pagy.new(count: 1, i18n_key: 'activerecord.models.product'))).must_rematch
      _(app.pagy_info(Pagy.new(count: 13, i18n_key: 'activerecord.models.product'))).must_rematch
      _(app.pagy_info(Pagy.new(count: 100, i18n_key: 'activerecord.models.product', page: 3))).must_rematch
      _(app.pagy_info(Pagy.new(count: 0), i18n_key: 'activerecord.models.product')).must_rematch
      _(app.pagy_info(Pagy.new(count: 1), i18n_key: 'activerecord.models.product')).must_rematch
      _(app.pagy_info(Pagy.new(count: 13), i18n_key: 'activerecord.models.product')).must_rematch
      _(app.pagy_info(Pagy.new(count: 100, page: 3), i18n_key: 'activerecord.models.product')).must_rematch
    end
  end
end
