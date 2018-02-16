require "test_helper"

class I18nTest < Minitest::Test

  class TestI18n;
    include Pagy::Frontend
  end

  def setup
    @I18n = TestI18n.new
  end

  def test_data
    assert_equal "&lsaquo; Prev", Pagy::Frontend::I18N['pagy']['nav']['prev']
    assert_equal "&hellip;", Pagy::Frontend::I18N['pagy']['nav']['gap']
  end

  def test_translation
    assert_equal "&lsaquo; Prev", @I18n.pagy_t('pagy.nav.prev')

    assert_equal "items", @I18n.pagy_t('pagy.info.item', count: 0)
    assert_equal "item", @I18n.pagy_t('pagy.info.item', count: 1)
    assert_equal "items", @I18n.pagy_t('pagy.info.item', count: 10)

    assert_equal "No %{item_name} found",
                 @I18n.pagy_t('pagy.info.single_page', count: 0)
    assert_equal "Displaying <b>1</b> %{item_name}",
                 @I18n.pagy_t('pagy.info.single_page', count: 1)
    assert_equal "Displaying <b>all 10</b> %{item_name}",
                 @I18n.pagy_t('pagy.info.single_page', count: 10)
    assert_equal "Displaying %{item_name} <b>%{from}-%{to}</b> of <b>10</b> in total",
                 @I18n.pagy_t('pagy.info.multiple_pages', count: 10)
  end

  def test_missing
    assert_equal 'translation missing: "pagy.nav.not_here"', @I18n.pagy_t('pagy.nav.not_here')
  end

  def test_render_info_no_118n_key
    pagy = Pagy.new count: 0
    assert_equal "No items found", @I18n.pagy_info(pagy)
    pagy = Pagy.new count: 1
    assert_equal "Displaying <b>1</b> item", @I18n.pagy_info(pagy)
    pagy = Pagy.new count: 13
    assert_equal "Displaying <b>all 13</b> items", @I18n.pagy_info(pagy)
    pagy = Pagy.new count: 100, page: 3
    assert_equal "Displaying items <b>41-60</b> of <b>100</b> in total", @I18n.pagy_info(pagy)
  end

  def test_render_info_with_missing_118n_key
    pagy = Pagy.new count: 0, i18n_key: :missing_key
    assert_equal "No items found", @I18n.pagy_info(pagy)
    pagy = Pagy.new count: 1, i18n_key: :missing_key
    assert_equal "Displaying <b>1</b> item", @I18n.pagy_info(pagy)
    pagy = Pagy.new count: 13, i18n_key: :missing_key
    assert_equal "Displaying <b>all 13</b> items", @I18n.pagy_info(pagy)
    pagy = Pagy.new count: 100, page: 3, i18n_key: :missing_key
    assert_equal "Displaying items <b>41-60</b> of <b>100</b> in total", @I18n.pagy_info(pagy)
  end

  def test_render_info_with_existing_118n_key
    Pagy::Frontend::I18N['pagy']['info']['product'] = { 'zero'  => 'Products',
                                                      'one'   => 'Product',
                                                      'other' => 'Products' }
    pagy = Pagy.new count: 0, i18n_key: 'pagy.info.product'
    assert_equal "No Products found", @I18n.pagy_info(pagy)
    pagy = Pagy.new count: 1, i18n_key: 'pagy.info.product'
    assert_equal "Displaying <b>1</b> Product", @I18n.pagy_info(pagy)
    pagy = Pagy.new count: 13, i18n_key: 'pagy.info.product'
    assert_equal "Displaying <b>all 13</b> Products", @I18n.pagy_info(pagy)
    pagy = Pagy.new count: 100, page: 3, i18n_key: 'pagy.info.product'
    assert_equal "Displaying Products <b>41-60</b> of <b>100</b> in total", @I18n.pagy_info(pagy)
  end

end
