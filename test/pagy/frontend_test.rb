# frozen_string_literal: true

require_relative '../test_helper'
require_relative '../mock_helpers/pagy_buggy'
require_relative '../mock_helpers/app'
require_relative '../mock_helpers/collection'
require_relative '../../gem/lib/pagy/support/components/utils/data_pagy_attribute'

describe 'pagy/frontend' do
  describe '#pagy_anchor_lambda' do
    it 'renders with legacy' do
      pagy = Pagy::Offset.new(count: 103, page: 1, request: MockApp.new.request)
      _(pagy.anchor_lambda(anchor_string: 'X').call(3)).must_equal '<a X href="/foo?page=3">3</a>'
    end
  end

  describe '#pagy_t' do
    it 'pluralizes' do
      _(Pagy::I18n.translate('pagy.aria_label.previous')).must_equal "Previous"
      _(Pagy::I18n.translate('pagy.item_name', count: 0)).must_equal "items"
      _(Pagy::I18n.translate('pagy.item_name', count: 1)).must_equal "item"
      _(Pagy::I18n.translate('pagy.item_name', count: 10)).must_equal "items"
    end
    it 'interpolates' do
      _(Pagy::I18n.translate('pagy.info.no_items', count: 0)).must_rematch :info_0
      _(Pagy::I18n.translate('pagy.info.single_page', count: 1)).must_rematch :info_1
      _(Pagy::I18n.translate('pagy.info.single_page', count: 10)).must_rematch :info_10
      _(Pagy::I18n.translate('pagy.info.multiple_pages', count: 10)).must_rematch :info_multi_10
      _(Pagy::I18n.translate('pagy.info.multiple_pages', item_name: 'Products', count: 300, from: 101, to: 125)).must_rematch :info_multi_item_name
    end
    it 'handles missing keys' do
      _(Pagy::I18n.translate('pagy.not_here')).must_equal '[translation missing: "pagy.not_here"]'
      _(Pagy::I18n.translate('pagy.gap.not_here')).must_equal '[translation missing: "pagy.gap.not_here"]'
    end
  end

  describe "Pagy::I18n" do
    it 'switches :locale according to @pagy_locale' do
      Pagy::I18n.locale = 'nl'
      _(Pagy::I18n.translate('pagy.item_name', count: 1)).must_equal "stuk"
      Pagy::I18n.locale = 'en'
      _(Pagy::I18n.translate('pagy.item_name', count: 1)).must_equal "item"
      Pagy::I18n.locale = 'de'
      _(Pagy::I18n.translate('pagy.item_name', count: 1)).must_equal "Eintrag"
      Pagy::I18n.locale = 'unknown'
      _ { Pagy::I18n.translate('pagy.item_name', count: 1) }.must_raise Errno::ENOENT
      Pagy::I18n.locale = 'en' # reset for other tests
    end
  end

  describe '#pagy_info' do
    it 'renders without i18n key' do
      _(Pagy::Offset.new(count: 0).info).must_rematch :info_0
      _(Pagy::Offset.new(count: 1).info).must_rematch :info_1
      _(Pagy::Offset.new(count: 13).info).must_rematch :info_13
      _(Pagy::Offset.new(count: 100, page: 3).info).must_rematch :info_100
      _(Pagy::Offset::Countless.new(page: 3).info).must_rematch :no_info
    end
    it 'overrides the item_name and set id' do
      _(Pagy::Offset.new(count: 0).info(id: 'pagy-info', item_name: 'Widgets')).must_rematch :info_0
      _(Pagy::Offset.new(count: 1).info(id: 'pagy-info', item_name: 'Widget')).must_rematch :info_1
      _(Pagy::Offset.new(count: 13).info(id: 'pagy-info', item_name: 'Widgets')).must_rematch :info_13
      _(Pagy::Offset.new(count: 100, page: 3).info(id: 'pagy-info', item_name: 'Widgets')).must_rematch :info_100
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
        pagy, = app.send(:pagy_offset, MockCollection.new, count: 100)
        _(pagy.send(:data_pagy_attribute, :test_function, 'some-string', 123, true)).must_rematch :data_1
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
