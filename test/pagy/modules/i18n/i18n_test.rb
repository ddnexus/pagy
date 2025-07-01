# frozen_string_literal: true

require_relative '../../../test_helper'
require_relative '../../../mock_helpers/pagy_buggy'
require_relative '../../../mock_helpers/app'
require_relative '../../../mock_helpers/collection'
require_relative '../../../../gem/lib/pagy/toolbox/helpers/support/data_pagy_attribute'

describe 'Pagy I18n' do
  describe 'translate' do
    it 'pluralizes' do
      _(Pagy::I18n.translate('pagy.aria_label.previous')).must_equal "Previous"
      _(Pagy::I18n.translate('pagy.item_name', count: 0)).must_equal "items"
      _(Pagy::I18n.translate('pagy.item_name', count: 1)).must_equal "item"
      _(Pagy::I18n.translate('pagy.item_name', count: 10)).must_equal "items"
    end
    it 'interpolates' do
      _(Pagy::I18n.translate('pagy.info_tag.no_items', count: 0)).must_rematch :info_0
      _(Pagy::I18n.translate('pagy.info_tag.single_page', count: 1)).must_rematch :info_1
      _(Pagy::I18n.translate('pagy.info_tag.single_page', count: 10)).must_rematch :info_10
      _(Pagy::I18n.translate('pagy.info_tag.multiple_pages', count: 10)).must_rematch :info_multi_10
      _(Pagy::I18n.translate('pagy.info_tag.multiple_pages', item_name: 'Products', count: 300, from: 101, to: 125)).must_rematch :info_multi_item_name
    end
    it 'handles missing keys' do
      _(Pagy::I18n.translate('pagy.not_here')).must_equal '[translation missing: "pagy.not_here"]'
      _(Pagy::I18n.translate('pagy.gap.not_here')).must_equal '[translation missing: "pagy.gap.not_here"]'
    end
  end

  describe "locales" do
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
end
