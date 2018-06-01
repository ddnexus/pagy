require_relative '../test_helper'
require 'rack'

SingleCov.covered!

describe Pagy::Frontend do

  class TestView
    include Pagy::Frontend

    def request
      Rack::Request.new('SCRIPT_NAME' => '/foo')
    end
  end

  class TestViewOverride < TestView
    def pagy_get_params(params)
      params.except(:a).merge!(k: 'k')
    end
  end

  let(:frontend) { TestView.new }

  describe "#pagy_nav" do
    before do
      @array = (1..103).to_a.extend(Pagy::Array::PageMethod)
    end

    def test_pagy_nav_page_1
      pagy, _ = @array.pagy(1)

      assert_equal(
      '<nav class="pagy-nav pagination" role="navigation" aria-label="pager">' \
        '<span class="page prev disabled">&lsaquo;&nbsp;Prev</span> ' \
        '<span class="page active">1</span> ' \
        '<span class="page"><a href="/foo?page=2" rel="next">2</a></span> ' \
        '<span class="page"><a href="/foo?page=3">3</a></span> ' \
        '<span class="page"><a href="/foo?page=4">4</a></span> ' \
        '<span class="page"><a href="/foo?page=5">5</a></span> ' \
        '<span class="page"><a href="/foo?page=6">6</a></span> ' \
        '<span class="page next"><a href="/foo?page=2" rel="next" aria-label="next">Next&nbsp;&rsaquo;</a></span>' \
        '</nav>',
      frontend.pagy_nav(pagy)
      )
    end

    def test_pagy_nav_page_3
      pagy, _ = @array.pagy(3)

      assert_equal(
      '<nav class="pagy-nav pagination" role="navigation" aria-label="pager">' \
        '<span class="page prev"><a href="/foo?page=2" rel="prev" aria-label="previous">&lsaquo;&nbsp;Prev</a></span> ' \
        '<span class="page"><a href="/foo?page=1">1</a></span> ' \
        '<span class="page"><a href="/foo?page=2" rel="prev">2</a></span> ' \
        '<span class="page active">3</span> ' \
        '<span class="page"><a href="/foo?page=4" rel="next">4</a></span> ' \
        '<span class="page"><a href="/foo?page=5">5</a></span> ' \
        '<span class="page"><a href="/foo?page=6">6</a></span> ' \
        '<span class="page next"><a href="/foo?page=4" rel="next" aria-label="next">Next&nbsp;&rsaquo;</a></span>' \
        '</nav>',
      frontend.pagy_nav(pagy)
      )
    end

    def test_pagy_nav_page_6
      pagy, _ = @array.pagy(6)

      assert_equal(
      '<nav class="pagy-nav pagination" role="navigation" aria-label="pager">' \
        '<span class="page prev"><a href="/foo?page=5" rel="prev" aria-label="previous">&lsaquo;&nbsp;Prev</a></span> ' \
        '<span class="page"><a href="/foo?page=1">1</a></span> ' \
        '<span class="page"><a href="/foo?page=2">2</a></span> ' \
        '<span class="page"><a href="/foo?page=3">3</a></span> ' \
        '<span class="page"><a href="/foo?page=4">4</a></span> ' \
        '<span class="page"><a href="/foo?page=5" rel="prev">5</a></span> ' \
        '<span class="page active">6</span> ' \
        '<span class="page next disabled">Next&nbsp;&rsaquo;</span>' \
        '</nav>',
      frontend.pagy_nav(pagy)
      )
    end

    def test_pagy_nav_page_10
      @array = (1..1000).to_a.extend(Pagy::Array::PageMethod)
      pagy, _ = @array.pagy(10)

      assert_equal(
        '<nav class="pagy-nav pagination" role="navigation" aria-label="pager">' \
          '<span class="page prev"><a href="/foo?page=9" rel="prev" aria-label="previous">&lsaquo;&nbsp;Prev</a></span> ' \
          '<span class="page"><a href="/foo?page=1">1</a></span> ' \
          '<span class="page gap">&hellip;</span> ' \
          '<span class="page"><a href="/foo?page=6">6</a></span> ' \
          '<span class="page"><a href="/foo?page=7">7</a></span> ' \
          '<span class="page"><a href="/foo?page=8">8</a></span> ' \
          '<span class="page"><a href="/foo?page=9" rel="prev">9</a></span> ' \
          '<span class="page active">10</span> ' \
          '<span class="page"><a href="/foo?page=11" rel="next">11</a></span> ' \
          '<span class="page"><a href="/foo?page=12">12</a></span> ' \
          '<span class="page"><a href="/foo?page=13">13</a></span> ' \
          '<span class="page"><a href="/foo?page=14">14</a></span> ' \
          '<span class="page gap">&hellip;</span> ' \
          '<span class="page"><a href="/foo?page=50">50</a></span> ' \
          '<span class="page next"><a href="/foo?page=11" rel="next" aria-label="next">Next&nbsp;&rsaquo;</a></span></nav>',
        frontend.pagy_nav(pagy)
      )
    end

    def test_link_extras
      pagy, _ = @array.pagy(1, link_extra: "X")
      frontend.pagy_nav(pagy).must_include '?page=2" X rel'
    end
  end

  describe "#pagy_link_proc" do
    it "renders with extras" do
      @array = (1..103).to_a.extend(Pagy::Array::PageMethod)
      pagy, _ = @array.pagy(1)
      frontend.pagy_link_proc(pagy, "X").call(1).must_equal '<a href="/foo?page=1" X>1</a>'
    end
  end

  describe "#pagy_t" do
    def test_data
      assert_equal "&lsaquo;&nbsp;Prev", Pagy::Frontend::I18N_DATA['pagy']['nav']['prev']
      assert_equal "&hellip;", Pagy::Frontend::I18N_DATA['pagy']['nav']['gap']
    end

    def test_translation
      assert_equal "&lsaquo;&nbsp;Prev", frontend.pagy_t('pagy.nav.prev')

      assert_equal "items", frontend.pagy_t('pagy.info.item_name', count: 0)
      assert_equal "item", frontend.pagy_t('pagy.info.item_name', count: 1)
      assert_equal "items", frontend.pagy_t('pagy.info.item_name', count: 10)

      assert_equal "No %{item_name} found",
                   frontend.pagy_t('pagy.info.single_page', count: 0)
      assert_equal "Displaying <b>1</b> %{item_name}",
                   frontend.pagy_t('pagy.info.single_page', count: 1)
      assert_equal "Displaying <b>all 10</b> %{item_name}",
                   frontend.pagy_t('pagy.info.single_page', count: 10)
      assert_equal "Displaying %{item_name} <b>%{from}-%{to}</b> of <b>10</b> in total",
                   frontend.pagy_t('pagy.info.multiple_pages', count: 10)
    end

    def test_missing
      assert_equal 'translation missing: "pagy.nav.not_here"', frontend.pagy_t('pagy.nav.not_here')
    end

  end

  describe "#pagy_info" do
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

    def test_render_info_with_existing_118n_key
      Pagy::Frontend::I18N_DATA['pagy']['info']['product'] = { 'zero'  => 'Products',
                                                               'one'   => 'Product',
                                                               'other' => 'Products' }
      pagy = Pagy.new count: 0, item_path: 'pagy.info.product'
      assert_equal "No Products found", frontend.pagy_info(pagy)
      pagy = Pagy.new count: 1, item_path: 'pagy.info.product'
      assert_equal "Displaying <b>1</b> Product", frontend.pagy_info(pagy)
      pagy = Pagy.new count: 13, item_path: 'pagy.info.product'
      assert_equal "Displaying <b>all 13</b> Products", frontend.pagy_info(pagy)
      pagy = Pagy.new count: 100, page: 3, item_path: 'pagy.info.product'
      assert_equal "Displaying Products <b>41-60</b> of <b>100</b> in total", frontend.pagy_info(pagy)
    end
  end

  describe '#pagy_url_for' do

    def test_basic_url
      pagy = Pagy.new count: 1000, page: 3
      assert_equal '/foo?page=5', frontend.pagy_url_for(5, pagy)
    end

    def test_url_with_params
      pagy = Pagy.new count: 1000, page: 3, params: {a: 3, b: 4}
      assert_equal '/foo?page=5&a=3&b=4', frontend.pagy_url_for(5, pagy)
    end

    def test_url_with_anchor
      pagy = Pagy.new count: 1000, page: 3, anchor: '#anchor'
      assert_equal '/foo?page=6#anchor', frontend.pagy_url_for(6, pagy)
    end

    def test_url_with_params_and_anchor
      pagy = Pagy.new count: 1000, page: 3, params: {a: 3, b: 4}, anchor: '#anchor'
      assert_equal '/foo?page=5&a=3&b=4#anchor', frontend.pagy_url_for(5, pagy)
    end

  end

  describe '#pagy_get_params' do

    def text_changed_params
      overridden = TestViewOverridden.new
      pagy = Pagy.new count: 1000, page: 3, params: {a: 3, b: 4}, anchor: '#anchor'
      assert_equal '/foo?page=5&&b=4&k=k#anchor', overridden.pagy_url_for(5, pagy)
    end

  end

end
