# frozen_string_literal: true

require_relative '../../test_helper'
require 'i18n'
require 'pagy/extras/i18n'

describe 'pagy/extras/i18n' do
  require_relative '../../mock_helpers/view'
  let(:view) { MockView.new }

  describe '#pagy_t with I18n' do
    it 'does not conflict with the I18n gem namespace' do
      view.test_i18n_call
    end
    it 'pluralizes' do
      _(view.pagy_t('pagy.nav.prev')).must_equal "&lsaquo;&nbsp;Prev"
      _(view.pagy_t('pagy.item_name', count: 0)).must_equal 'items'
      _(view.pagy_t('pagy.item_name', count: 1)).must_equal  'item'
      _(view.pagy_t('pagy.item_name', count: 10)).must_equal 'items'
    end
    it 'handles missing paths' do
      _(view.pagy_t('pagy.nav.not_here')).must_equal 'translation missing: en.pagy.nav.not_here'
    end
  end

  describe '#pagy_info with I18n' do
    it 'renders info' do
      _(view.pagy_info(Pagy.new(count: 0))).must_rematch
      _(view.pagy_info(Pagy.new(count: 1))).must_rematch
      _(view.pagy_info(Pagy.new(count: 13))).must_rematch
      _(view.pagy_info(Pagy.new(count: 100, page: 3))).must_rematch
    end
    it 'renders with existing i18n key' do
      ::I18n.locale = 'en'
      custom_dictionary = Pagy.root.parent.join('test', 'files', 'i18n.yml')
      ::I18n.load_path += [custom_dictionary]
      _(view.pagy_info(Pagy.new(count: 0, i18n_key: 'activerecord.models.product'))).must_rematch
      _(view.pagy_info(Pagy.new(count: 1, i18n_key: 'activerecord.models.product'))).must_rematch
      _(view.pagy_info(Pagy.new(count: 13, i18n_key: 'activerecord.models.product'))).must_rematch
      _(view.pagy_info(Pagy.new(count: 100, i18n_key: 'activerecord.models.product', page: 3))).must_rematch
      _(view.pagy_info(Pagy.new(count: 0), i18n_key: 'activerecord.models.product')).must_rematch
      _(view.pagy_info(Pagy.new(count: 1), i18n_key: 'activerecord.models.product')).must_rematch
      _(view.pagy_info(Pagy.new(count: 13), i18n_key: 'activerecord.models.product')).must_rematch
      _(view.pagy_info(Pagy.new(count: 100, page: 3), i18n_key: 'activerecord.models.product')).must_rematch
    end
  end
end
