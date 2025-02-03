# frozen_string_literal: true

require_relative '../test_helper'
require_relative '../mock_helpers/pagy_buggy'
require_relative '../mock_helpers/app'
require_relative '../../gem/lib/pagy/frontend/utils/data_pagy'

describe 'pagy/frontend' do
  let(:app) { MockApp.new }

  # #pagy_nav helper tests in the test/legacy/offset_test.rb

  describe '#pagy_anchor' do
    it 'renders with legacy' do
      pagy = Pagy::Offset.new(count: 103, page: 1)
      _(app.pagy_anchor(pagy, anchor_string: 'X').call(3)).must_equal '<a X href="/foo?page=3">3</a>'
    end
  end

  describe '#pagy_t' do
    it 'pluralizes' do
      _(app.pagy_t('pagy.aria_label.previous')).must_equal "Previous"
      _(app.pagy_t('pagy.item_name', count: 0)).must_equal "items"
      _(app.pagy_t('pagy.item_name', count: 1)).must_equal "item"
      _(app.pagy_t('pagy.item_name', count: 10)).must_equal "items"
    end
    it 'interpolates' do
      _(app.pagy_t('pagy.info.no_items', count: 0)).must_rematch :info_0
      _(app.pagy_t('pagy.info.single_page', count: 1)).must_rematch :info_1
      _(app.pagy_t('pagy.info.single_page', count: 10)).must_rematch :info_10
      _(app.pagy_t('pagy.info.multiple_pages', count: 10)).must_rematch :info_multi_10
      _(app.pagy_t('pagy.info.multiple_pages', item_name: 'Products', count: 300, from: 101, to: 125)).must_rematch :info_multi_item_name
    end
    it 'handles missing keys' do
      _(app.pagy_t('pagy.not_here')).must_equal '[translation missing: "pagy.not_here"]'
      _(app.pagy_t('pagy.gap.not_here')).must_equal '[translation missing: "pagy.gap.not_here"]'
    end
  end

  describe "Pagy::I18n" do
    it 'switches :locale according to @pagy_locale' do
      app.set_pagy_locale('nl')
      _(app.pagy_t('pagy.item_name', count: 1)).must_equal "stuk"
      app.set_pagy_locale('en')
      _(app.pagy_t('pagy.item_name', count: 1)).must_equal "item"
      app.set_pagy_locale('de')
      _(app.pagy_t('pagy.item_name', count: 1)).must_equal "Eintrag"
      app.set_pagy_locale('unknown')
      _ { app.pagy_t('pagy.item_name', count: 1) }.must_raise Errno::ENOENT
      app.instance_variable_set(:@pagy_locale, nil) # reset for other tests
    end
  end

  describe '#pagy_info' do
    it 'renders without i18n key' do
      _(app.pagy_info(Pagy::Offset.new(count: 0))).must_rematch :info_0
      _(app.pagy_info(Pagy::Offset.new(count: 1))).must_rematch :info_1
      _(app.pagy_info(Pagy::Offset.new(count: 13))).must_rematch :info_13
      _(app.pagy_info(Pagy::Offset.new(count: 100, page: 3))).must_rematch :info_100
      _(app.pagy_info(Pagy::Offset::Countless.new(page: 3))).must_rematch :no_info
    end
    it 'overrides the item_name and set id' do
      _(app.pagy_info(Pagy::Offset.new(count: 0), id: 'pagy-info', item_name: 'Widgets')).must_rematch :info_0
      _(app.pagy_info(Pagy::Offset.new(count: 1), id: 'pagy-info', item_name: 'Widget')).must_rematch :info_1
      _(app.pagy_info(Pagy::Offset.new(count: 13), id: 'pagy-info', item_name: 'Widgets')).must_rematch :info_13
      _(app.pagy_info(Pagy::Offset.new(count: 100, page: 3), id: 'pagy-info', item_name: 'Widgets')).must_rematch :info_100
    end
  end
end

OJ = %i[without_oj with_oj].freeze
OJ.each do |test|
  require 'oj' if test == :with_oj

  Time.zone = 'EST'
  Date.beginning_of_week = :sunday

  describe 'pagy/frontend' do
    let(:app) { MockApp.new(params: {}) }

    describe "data_pagy #{test}" do
      it "runs #{test}" do
        _(Pagy::DataPagy.attr(:test_function, 'some-string', 123, true)).must_rematch :data_1
      end
    end
    describe "Calendar sequels and label_sequels #{test}" do
      it 'generate the labels for the sequels' do
        steps = { 0 => 5, 600 => 7 }
        pagy = Pagy::Calendar.send(:create,
                                   :month,
                                   period:  [Time.zone.local(2021, 10, 21, 13, 18, 23, 0),
                                             Time.zone.local(2023, 11, 13, 15, 43, 40, 0)],
                                   steps:   steps,
                                   compact: false,   # to hit the :gap condition in the calendar sequels override
                                   page:    6)
        _(pagy.sequels).must_rematch :sequels
      end
    end
  end
end
