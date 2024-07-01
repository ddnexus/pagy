# frozen_string_literal: true

require_relative '../test_helper'

require_relative '../mock_helpers/pagy_buggy'
require_relative '../mock_helpers/app'

# in test we cannot use the Pagy::I18n.load method because
# it would freeze the Pagy::I18n::DATA hash so i18n_load
# do the same as Pagy::I18n.load, just omitting the freeze
def i18n_load(*locales)
  Pagy::I18n::DATA.clear
  Pagy::I18n.send(:build, *locales)
end

describe 'pagy/frontend' do
  let(:app) { MockApp.new }

  # #pagy_nav helper tests in the test/extras/pagy_test.rb

  describe '#pagy_a_proc' do
    it 'renders with extras' do
      pagy = Pagy.new(count: 103, page: 1)
      _(app.pagy_anchor(pagy, anchor_string: 'X').call(3)).must_equal '<a X href="/foo?page=3">3</a>'
    end
  end

  describe '#pagy_t' do
    it 'pluralizes' do
      _(app.pagy_t('pagy.aria_label.prev')).must_equal "Previous"
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
    it 'loads custom :locale, :filepath and :pluralize' do
      _(proc { i18n_load(locale: 'xx') }).must_raise Errno::ENOENT
      _(proc { i18n_load(locale: 'xx', filepath: Pagy.root.join('locales', 'en.yml')) }).must_raise Pagy::I18nError
      _(proc { i18n_load(locale: 'en', filepath: Pagy.root.join('locales', 'xx.yml')) }).must_raise Errno::ENOENT
      custom_dictionary = Pagy.root.parent.join('test', 'files', 'custom.yml')
      i18n_load(locale: 'custom', filepath: custom_dictionary)
      _(Pagy::I18n.t('custom', 'pagy.aria_label.prev')).must_equal "Custom Previous"
      i18n_load(locale: 'en', pluralize: ->(_) { 'one' }) # returns always 'one' regardless the count
      _(Pagy::I18n.t(nil, 'pagy.item_name', count: 0)).must_equal "item"
      _(Pagy::I18n.t('en', 'pagy.item_name', count: 0)).must_equal "item"
      _(Pagy::I18n.t('en', 'pagy.item_name', count: 1)).must_equal "item"
      _(Pagy::I18n.t('en', 'pagy.item_name', count: 10)).must_equal "item"
      i18n_load(locale: 'en') # reset for other tests
    end
    it 'switches :locale according to @pagy_locale' do
      i18n_load({ locale: 'de' }, { locale: 'en' }, { locale: 'nl' })
      app.set_pagy_locale('nl')
      _(app.pagy_t('pagy.item_name', count: 1)).must_equal "stuk"
      app.set_pagy_locale('en')
      _(app.pagy_t('pagy.item_name', count: 1)).must_equal "item"
      app.set_pagy_locale(nil)
      _(app.pagy_t('pagy.item_name', count: 1)).must_equal "Eintrag"
      app.set_pagy_locale('unknown')
      _(app.pagy_t('pagy.item_name', count: 1)).must_equal "Eintrag" # silently serves the first loaded locale
      i18n_load(locale: 'en') # reset for other tests
      app.instance_variable_set(:@pagy_locale, nil) # reset for other tests
    end
  end

  describe '#pagy_info' do
    it 'renders without i18n key' do
      _(app.pagy_info(Pagy.new(count: 0))).must_rematch key: :info_0
      _(app.pagy_info(Pagy.new(count: 1))).must_rematch key: :info_1
      _(app.pagy_info(Pagy.new(count: 13))).must_rematch key: :info_13
      _(app.pagy_info(Pagy.new(count: 100, page: 3))).must_rematch key: :info_100
    end
    it 'overrides the item_name and set id' do
      _(app.pagy_info(Pagy.new(count: 0), id: 'pagy-info', item_name: 'Widgets')).must_rematch key: :info_0
      _(app.pagy_info(Pagy.new(count: 1), id: 'pagy-info', item_name: 'Widget')).must_rematch key: :info_1
      _(app.pagy_info(Pagy.new(count: 13), id: 'pagy-info', item_name: 'Widgets')).must_rematch key: :info_13
      _(app.pagy_info(Pagy.new(count: 100, page: 3), id: 'pagy-info', item_name: 'Widgets')).must_rematch key: :info_100
    end
  end

  describe '#pagy_url_for' do
    it 'renders basic url' do
      pagy = Pagy.new count: 1000, page: 3
      _(app.pagy_url_for(pagy, 5)).must_equal '/foo?page=5'
      _(app.pagy_url_for(pagy, 5, absolute: true)).must_equal 'http://example.com:3000/foo?page=5'
    end
    it 'renders url with params' do
      pagy = Pagy.new count: 1000, page: 3, params: { a: 3, b: 4 }
      _(app.pagy_url_for(pagy, 5)).must_equal "/foo?page=5&a=3&b=4"
      _(app.pagy_url_for(pagy, 5, absolute: true)).must_equal "http://example.com:3000/foo?page=5&a=3&b=4"
    end
    it 'renders url with fragment' do
      pagy = Pagy.new count: 1000, page: 3, fragment: '#fragment'
      _(app.pagy_url_for(pagy, 6)).must_equal '/foo?page=6#fragment'
      _(app.pagy_url_for(pagy, 6, absolute: true)).must_equal 'http://example.com:3000/foo?page=6#fragment'
    end
    it 'renders url with params and fragment' do
      pagy = Pagy.new count: 1000, page: 3, params: { a: 3, b: 4 }, fragment: '#fragment'
      _(app.pagy_url_for(pagy, 5)).must_equal "/foo?page=5&a=3&b=4#fragment"
      _(app.pagy_url_for(pagy, 5, absolute: true)).must_equal "http://example.com:3000/foo?page=5&a=3&b=4#fragment"
    end
    it 'renders url with overridden path' do
      pagy = Pagy.new count: 1000, page: 3, request_path: '/bar'
      _(app.pagy_url_for(pagy, 5)).must_equal '/bar?page=5'
    end
  end

  describe '#pagy_get_params and r' do
    it 'overrides params' do
      app  = MockApp.new(params: { delete_me: 'delete_me', a: 5 })
      pagy = Pagy.new(count: 1000,
                      page: 3,
                      fragment: '#fragment',
                      params: lambda do |params|
                                params.delete('delete_me')
                                params.merge('b' => 4, 'add_me' => 'add_me')
                              end)
      _(app.pagy_url_for(pagy, 5)).must_equal "/foo?a=5&page=5&b=4&add_me=add_me#fragment"
    end
  end
end
