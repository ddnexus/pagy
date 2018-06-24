require_relative '../../test_helper'
require 'i18n'
require 'pagy/extras/i18n'

SingleCov.covered!

describe Pagy::Frontend do

  let(:frontend) { TestView.new }

  describe "#pagy_t" do
    def test_data
      assert_equal "&lsaquo;&nbsp;Prev", Pagy::Frontend::I18N[:data]['pagy']['nav']['prev']
      assert_equal "&hellip;", Pagy::Frontend::I18N[:data]['pagy']['nav']['gap']
    end

    def test_translation
      assert_equal "&lsaquo;&nbsp;Prev", frontend.pagy_t('pagy.nav.prev')

      assert_equal "items", frontend.pagy_t('pagy.info.item_name', count: 0)
      assert_equal "item", frontend.pagy_t('pagy.info.item_name', count: 1)
      assert_equal "items", frontend.pagy_t('pagy.info.item_name', count: 10)

    end

    def test_missing
      assert_equal 'translation missing: en.pagy.nav.not_here', frontend.pagy_t('pagy.nav.not_here')
    end

    def test_render_info_no_118n_key
      pagy = Pagy.new count: 0
      assert_equal "No items found", frontend.pagy_info(pagy)
      pagy = Pagy.new count: 1
      assert_equal "Displaying <b>1</b> item", frontend.pagy_info(pagy)
      pagy = Pagy.new count: 13
      assert_equal "Displaying <b>all 13</b> items", frontend.pagy_info(pagy)
      pagy = Pagy.new count: 100, page: 3
      assert_equal "Displaying items <b>41-60</b> of <b>100</b> in total", frontend.pagy_info(pagy)
    end

  end

end
