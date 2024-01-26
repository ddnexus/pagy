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

  # #pagy_nav helper tests in the test/extras/navs_test.rb

  describe '#pagy_link_proc' do
    it 'renders with extras' do
      pagy = Pagy.new count: 103, page: 1
      _(app.pagy_link_proc(pagy, link_extra: "X").call(3)).must_equal '<a href="/foo?page=3"  X >3</a>'
    end
  end

  describe '#pagy_t' do
    it 'pluralizes' do
      _(app.pagy_t('pagy.nav.prev_label')).must_equal "Prev"
      _(app.pagy_t('pagy.item_name', count: 0)).must_equal "items"
      _(app.pagy_t('pagy.item_name', count: 1)).must_equal "item"
      _(app.pagy_t('pagy.item_name', count: 10)).must_equal "items"
    end
    # rubocop:disable Style/FormatStringToken
    it 'interpolates' do
      _(app.pagy_t('pagy.info.no_items', count: 0)).must_equal "No %{item_name} found"
      _(app.pagy_t('pagy.info.single_page', count: 1)).must_equal "Displaying <b>1</b> %{item_name}"
      _(app.pagy_t('pagy.info.single_page', count: 10)).must_equal "Displaying <b>10</b> %{item_name}"
      _(app.pagy_t('pagy.info.multiple_pages', count: 10)).must_equal "Displaying %{item_name} <b>%{from}-%{to}</b> of <b>10</b> in total"
      _(app.pagy_t('pagy.info.multiple_pages', item_name: 'Products', count: 300, from: 101, to: 125)).must_equal "Displaying Products <b>101-125</b> of <b>300</b> in total"
    end
    # rubocop:enable Style/FormatStringToken
    it 'handles missing keys' do
      _(app.pagy_t('pagy.nav.not_here')).must_equal '[translation missing: "pagy.nav.not_here"]'
      _(app.pagy_t('pagy.nav.gap.not_here')).must_equal '[translation missing: "pagy.nav.gap.not_here"]'
    end
  end

  describe "Pagy::I18n" do
    it 'loads custom :locale, :filepath and :pluralize' do
      _(proc { i18n_load(locale: 'xx') }).must_raise Errno::ENOENT
      _(proc { i18n_load(locale: 'xx', filepath: Pagy.root.join('locales', 'en.yml')) }).must_raise Pagy::I18nError
      _(proc { i18n_load(locale: 'en', filepath: Pagy.root.join('locales', 'xx.yml')) }).must_raise Errno::ENOENT
      custom_dictionary = Pagy.root.parent.join('test', 'files', 'custom.yml')
      i18n_load(locale: 'custom', filepath: custom_dictionary)
      _(Pagy::I18n.t('custom', 'pagy.nav.prev_label')).must_equal "Custom Prev"
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
      _(app.pagy_info(Pagy.new(count: 0))).must_equal '<span class="pagy-info">No items found</span>'
      _(app.pagy_info(Pagy.new(count: 1))).must_equal '<span class="pagy-info">Displaying <b>1</b> item</span>'
      _(app.pagy_info(Pagy.new(count: 13))).must_equal '<span class="pagy-info">Displaying <b>13</b> items</span>'
      _(app.pagy_info(Pagy.new(count: 100, page: 3))).must_equal '<span class="pagy-info">Displaying items <b>41-60</b> of <b>100</b> in total</span>'
    end
    it 'renders with existing i18n key' do
      Pagy::I18n::DATA['en'][0]['pagy.info.product.one']   = 'Product'
      Pagy::I18n::DATA['en'][0]['pagy.info.product.other'] = 'Products'
      _(app.pagy_info(Pagy.new(count: 0, item_i18n_key: 'pagy.info.product'))).must_equal '<span class="pagy-info">No Products found</span>'
      _(app.pagy_info(Pagy.new(count: 1, item_i18n_key: 'pagy.info.product'))).must_equal '<span class="pagy-info">Displaying <b>1</b> Product</span>'
      _(app.pagy_info(Pagy.new(count: 13, item_i18n_key: 'pagy.info.product'))).must_equal '<span class="pagy-info">Displaying <b>13</b> Products</span>'
      _(app.pagy_info(Pagy.new(count: 100, item_i18n_key: 'pagy.info.product', page: 3))).must_equal '<span class="pagy-info">Displaying Products <b>41-60</b> of <b>100</b> in total</span>'
      _(app.pagy_info(Pagy.new(count: 0), item_i18n_key: 'pagy.info.product')).must_equal '<span class="pagy-info">No Products found</span>'
      _(app.pagy_info(Pagy.new(count: 1), item_i18n_key: 'pagy.info.product')).must_equal '<span class="pagy-info">Displaying <b>1</b> Product</span>'
      _(app.pagy_info(Pagy.new(count: 13), item_i18n_key: 'pagy.info.product')).must_equal '<span class="pagy-info">Displaying <b>13</b> Products</span>'
      _(app.pagy_info(Pagy.new(count: 100, page: 3), item_i18n_key: 'pagy.info.product')).must_equal '<span class="pagy-info">Displaying Products <b>41-60</b> of <b>100</b> in total</span>'
      i18n_load(locale: 'en') # reset for other tests
    end
    it 'overrides the item_name and set pagy_id' do
      _(app.pagy_info(Pagy.new(count: 0), pagy_id: 'pagy-info', item_name: 'Widgets')).must_equal '<span id="pagy-info" class="pagy-info">No Widgets found</span>'
      _(app.pagy_info(Pagy.new(count: 1), pagy_id: 'pagy-info', item_name: 'Widget')).must_equal '<span id="pagy-info" class="pagy-info">Displaying <b>1</b> Widget</span>'
      _(app.pagy_info(Pagy.new(count: 13), pagy_id: 'pagy-info', item_name: 'Widgets')).must_equal '<span id="pagy-info" class="pagy-info">Displaying <b>13</b> Widgets</span>'
      _(app.pagy_info(Pagy.new(count: 100, page: 3), pagy_id: 'pagy-info', item_name: 'Widgets')).must_equal '<span id="pagy-info" class="pagy-info">Displaying Widgets <b>41-60</b> of <b>100</b> in total</span>'
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
