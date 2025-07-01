# frozen_string_literal: true

require_relative '../../../test_helper'
require_relative '../../../mock_helpers/app'

describe 'pagy/i18n' do
  let(:app) { MockApp.new }

  ##### pagy.rb initializer ###############
  Pagy.translate_with_the_slower_i18n_gem!
  #########################################

  describe 'translate with I18n' do
    it 'does not conflict with the I18n gem namespace' do
      app.test_i18n_call
    end

    it 'is the actual gem module' do
      _(Pagy::I18n::VERSION).must_equal I18n::VERSION
    end
    it 'pluralizes' do
      _(Pagy::I18n.translate('pagy.aria_label.previous')).must_equal "Previous"
      _(Pagy::I18n.translate('pagy.item_name', count: 0)).must_equal 'items'
      _(Pagy::I18n.translate('pagy.item_name', count: 1)).must_equal  'item'
      _(Pagy::I18n.translate('pagy.item_name', count: 10)).must_equal 'items'
    end
    it 'handles missing paths' do
      _(Pagy::I18n.translate('pagy.not_here')).must_equal 'Translation missing: en.pagy.not_here'
    end
  end

  describe 'info_tag with I18n' do
    it 'renders info' do
      _(Pagy::Offset.new(count: 0).info_tag).must_rematch :info_0
      _(Pagy::Offset.new(count: 1).info_tag).must_rematch :info_1
      _(Pagy::Offset.new(count: 13).info_tag).must_rematch :info_13
      _(Pagy::Offset.new(count: 100, page: 3).info_tag).must_rematch :info_100
    end
  end
end
