require_relative '../../test_helper'
require 'i18n'
require 'pagy/extras/i18n'

SingleCov.covered!

describe Pagy::Frontend do

  let(:frontend) { TestView.new }

  describe "#pagy_t with I18n" do

    it 'pluralizes' do
      frontend.pagy_t('pagy.nav.prev').must_equal "&lsaquo;&nbsp;Prev"
      frontend.pagy_t('pagy.info.item_name', count: 0).must_equal 'items'
      frontend.pagy_t('pagy.info.item_name', count: 1).must_equal  'item'
      frontend.pagy_t('pagy.info.item_name', count: 10).must_equal 'items'
    end

    it 'handles missing paths' do
      frontend.pagy_t('pagy.nav.not_here').must_equal 'translation missing: en.pagy.nav.not_here'
    end

  end

  describe '#pagy_info with I18n' do

    it 'renders info' do
      frontend.pagy_info(Pagy.new count: 0).must_equal "No items found"
      frontend.pagy_info(Pagy.new count: 1).must_equal "Displaying <b>1</b> item"
      frontend.pagy_info(Pagy.new count: 13).must_equal "Displaying <b>all 13</b> items"
      frontend.pagy_info(Pagy.new count: 100, page: 3).must_equal "Displaying items <b>41-60</b> of <b>100</b> in total"
    end

  end

end
