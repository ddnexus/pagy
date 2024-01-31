# frozen_string_literal: true

require_relative '../../test_helper'
require 'i18n'
require 'pagy/extras/calendar'
require 'pagy/extras/i18n'

require_relative '../../mock_helpers/app'

Time.zone = 'EST'
Date.beginning_of_week = :sunday

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
      I18n.locale = :en
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

  describe 'Calendar with I18n.l' do
    I18n.load_path += Dir[Pagy.root.join('..', 'test', 'files', 'locales', '*.yml')]
    it 'works in :en' do
      pagy = Pagy::Calendar.create(:month,
                                   period: [Time.zone.local(2021, 10, 21, 13, 18, 23, 0),
                                            Time.zone.local(2023, 11, 13, 15, 43, 40, 0)],
                                   page: 3, format: '%B, %A')
      _(pagy.label).must_equal "December, Wednesday"
      _(pagy.label(locale: :de)).must_equal "Dezember, Mittwoch"
      _(pagy.label(format: '%b')).must_equal "Dec"
      _(pagy.label(format: '%b', locale: :de)).must_equal "Dez"
      _(pagy.label_for(5)).must_equal "February, Tuesday"
      _(pagy.label_for(5, locale: :de)).must_equal "Februar, Dienstag"
      I18n.locale = :de
      _(pagy.label).must_equal "Dezember, Mittwoch"
      _(pagy.label(format: '%b')).must_equal "Dez"
      _(pagy.label_for(5)).must_equal "Februar, Dienstag"
      _(pagy.label_for(5, format: '%b')).must_equal "Feb"
      I18n.locale = :en
    end
  end
end
