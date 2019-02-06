# encoding: utf-8
# frozen_string_literal: true

require_relative '../test_helper'

SingleCov.covered! unless ENV['SKIP_SINGLECOV']

describe Pagy::Frontend do

  let(:frontend) { TestView.new }

  describe "#pagy_nav" do

    before do
      @array = (1..103).to_a.extend(Pagy::Array::PageMethod)
    end

    it 'renders page 1' do
      pagy, _ = @array.pagy(1)
      frontend.pagy_nav(pagy).must_equal \
      '<nav class="pagy-nav pagination" role="navigation" aria-label="pager">' \
        '<span class="page prev disabled">&lsaquo;&nbsp;Prev</span> ' \
        '<span class="page active">1</span> ' \
        '<span class="page"><a href="/foo?page=2"   rel="next" >2</a></span> ' \
        '<span class="page"><a href="/foo?page=3"   >3</a></span> ' \
        '<span class="page"><a href="/foo?page=4"   >4</a></span> ' \
        '<span class="page"><a href="/foo?page=5"   >5</a></span> ' \
        '<span class="page"><a href="/foo?page=6"   >6</a></span> ' \
        '<span class="page next"><a href="/foo?page=2"   rel="next" aria-label="next">Next&nbsp;&rsaquo;</a></span>' \
        '</nav>'
    end

    it 'renders page 3' do
      pagy, _ = @array.pagy(3)
      frontend.pagy_nav(pagy).must_equal \
        '<nav class="pagy-nav pagination" role="navigation" aria-label="pager">' \
        '<span class="page prev"><a href="/foo?page=2"   rel="prev" aria-label="previous">&lsaquo;&nbsp;Prev</a></span> ' \
        '<span class="page"><a href="/foo?page=1"   >1</a></span> ' \
        '<span class="page"><a href="/foo?page=2"   rel="prev" >2</a></span> ' \
        '<span class="page active">3</span> ' \
        '<span class="page"><a href="/foo?page=4"   rel="next" >4</a></span> ' \
        '<span class="page"><a href="/foo?page=5"   >5</a></span> ' \
        '<span class="page"><a href="/foo?page=6"   >6</a></span> ' \
        '<span class="page next"><a href="/foo?page=4"   rel="next" aria-label="next">Next&nbsp;&rsaquo;</a></span>' \
        '</nav>'
    end


    it 'renders page 6' do
      pagy, _ = @array.pagy(6)
      frontend.pagy_nav(pagy).must_equal \
      '<nav class="pagy-nav pagination" role="navigation" aria-label="pager">' \
        '<span class="page prev"><a href="/foo?page=5"   rel="prev" aria-label="previous">&lsaquo;&nbsp;Prev</a></span> ' \
        '<span class="page"><a href="/foo?page=1"   >1</a></span> ' \
        '<span class="page"><a href="/foo?page=2"   >2</a></span> ' \
        '<span class="page"><a href="/foo?page=3"   >3</a></span> ' \
        '<span class="page"><a href="/foo?page=4"   >4</a></span> ' \
        '<span class="page"><a href="/foo?page=5"   rel="prev" >5</a></span> ' \
        '<span class="page active">6</span> ' \
        '<span class="page next disabled">Next&nbsp;&rsaquo;</span>' \
        '</nav>'
    end

    it 'renders page 10' do
      @array = (1..1000).to_a.extend(Pagy::Array::PageMethod)
      pagy, _ = @array.pagy(10)
      frontend.pagy_nav(pagy).must_equal \
      '<nav class="pagy-nav pagination" role="navigation" aria-label="pager">' \
          '<span class="page prev"><a href="/foo?page=9"   rel="prev" aria-label="previous">&lsaquo;&nbsp;Prev</a></span> ' \
          '<span class="page"><a href="/foo?page=1"   >1</a></span> ' \
          '<span class="page gap">&hellip;</span> ' \
          '<span class="page"><a href="/foo?page=6"   >6</a></span> ' \
          '<span class="page"><a href="/foo?page=7"   >7</a></span> ' \
          '<span class="page"><a href="/foo?page=8"   >8</a></span> ' \
          '<span class="page"><a href="/foo?page=9"   rel="prev" >9</a></span> ' \
          '<span class="page active">10</span> ' \
          '<span class="page"><a href="/foo?page=11"   rel="next" >11</a></span> ' \
          '<span class="page"><a href="/foo?page=12"   >12</a></span> ' \
          '<span class="page"><a href="/foo?page=13"   >13</a></span> ' \
          '<span class="page"><a href="/foo?page=14"   >14</a></span> ' \
          '<span class="page gap">&hellip;</span> ' \
          '<span class="page"><a href="/foo?page=50"   >50</a></span> ' \
          '<span class="page next"><a href="/foo?page=11"   rel="next" aria-label="next">Next&nbsp;&rsaquo;</a></span></nav>'
    end

    it 'renders with link_extras' do
      pagy, _ = @array.pagy(1, link_extra: "X")
      frontend.pagy_nav(pagy).must_include '?page=2" X  rel'
    end

  end

  describe "#pagy_link_proc" do

    it 'renders with extras' do
      @array = (1..103).to_a.extend(Pagy::Array::PageMethod)
      pagy, _ = @array.pagy(1)
      frontend.pagy_link_proc(pagy, "X").call(1).must_equal '<a href="/foo?page=1"  X >1</a>'
    end

 end

  describe "#pagy_t" do

    it 'pluralizes' do
      frontend.pagy_t('pagy.nav.prev').must_equal "&lsaquo;&nbsp;Prev"
      frontend.pagy_t('pagy.info.item_name', count: 0).must_equal "items"
      frontend.pagy_t('pagy.info.item_name', count: 1).must_equal "item"
      frontend.pagy_t('pagy.info.item_name', count: 10).must_equal "items"
    end

    it 'interpolates' do
      frontend.pagy_t('pagy.info.single_page', count: 0).must_equal "No %{item_name} found"
      frontend.pagy_t('pagy.info.single_page', count: 1).must_equal "Displaying <b>1</b> %{item_name}"
      frontend.pagy_t('pagy.info.single_page', count: 10).must_equal "Displaying <b>all 10</b> %{item_name}"
      frontend.pagy_t('pagy.info.multiple_pages', count: 10).must_equal "Displaying %{item_name} <b>%{from}-%{to}</b> of <b>10</b> in total"
      frontend.pagy_t('pagy.info.multiple_pages', item_name: 'Products', count: 300, from: 101, to: 125).must_equal "Displaying Products <b>101-125</b> of <b>300</b> in total"
    end

    it 'handles missing paths' do
      frontend.pagy_t('pagy.nav.not_here').must_equal '[translation missing: "pagy.nav.not_here"]'
      frontend.pagy_t('pagy.nav.gap.not_here').must_equal '[translation missing: "pagy.nav.gap.not_here"]'
    end


  end

  describe "I18N" do

    it 'loads custom :locale, :filepath and :pluralize' do
      proc{ Pagy::Frontend::I18N.load(locale: 'xx') }.must_raise Errno::ENOENT
      proc{ Pagy::Frontend::I18N.load(locale: 'xx', filepath: Pagy.root.join('locales', 'en.yml'))}.must_raise ArgumentError
      proc{ Pagy::Frontend::I18N.load(locale: 'en', filepath: Pagy.root.join('locales', 'xx.yml')) }.must_raise Errno::ENOENT
      custom_dictionary = File.join(File.dirname(__FILE__), 'custom.yml')
      Pagy::Frontend::I18N.load(locale: 'custom', filepath: custom_dictionary)
      # frontend.pagy_t('pagy.nav.prev').must_equal "&lsaquo;&nbsp;Custom Prev"
      Pagy::Frontend::I18N.load(locale: 'en', pluralize: lambda{|_| 'one' }) # returns always 'one' regardless the count
      frontend.pagy_t('pagy.info.item_name', count: 0).must_equal "item"
      frontend.pagy_t('pagy.info.item_name', count: 1).must_equal "item"
      frontend.pagy_t('pagy.info.item_name', count: 10).must_equal "item"
      Pagy::Frontend::I18N.load(locale: 'en') # reset for other tests
    end

    it 'switches :locale according to @pagy_locale' do
      Pagy::Frontend::I18N.load({locale: 'de'}, {locale: 'en'}, {locale: 'nl'})
      frontend.instance_variable_set(:'@pagy_locale', 'nl')
      frontend.pagy_t('pagy.info.item_name', count: 1).must_equal "stuk"
      frontend.instance_variable_set(:'@pagy_locale', 'en')
      frontend.pagy_t('pagy.info.item_name', count: 1).must_equal "item"
      frontend.instance_variable_set(:'@pagy_locale', nil)
      frontend.pagy_t('pagy.info.item_name', count: 1).must_equal "Eintrag"
      frontend.instance_variable_set(:'@pagy_locale', 'unknown')
      frontend.pagy_t('pagy.info.item_name', count: 1).must_equal "Eintrag" # silently serves the first loaded locale
      Pagy::Frontend::I18N.load(locale: 'en') # reset for other tests
      frontend.instance_variable_set(:'@pagy_locale', nil)      # reset for other tests
    end
  end

  describe "#pagy_info" do

    it 'renders without i18n path' do
      frontend.pagy_info(Pagy.new count: 0).must_equal "No items found"
      frontend.pagy_info(Pagy.new count: 1).must_equal "Displaying <b>1</b> item"
      frontend.pagy_info(Pagy.new count: 13).must_equal "Displaying <b>all 13</b> items"
      frontend.pagy_info(Pagy.new count: 100, page: 3).must_equal "Displaying items <b>41-60</b> of <b>100</b> in total"
    end

    it 'renders with existing i18n path' do
      Pagy::Frontend::I18N['en'][0]['pagy.info.product.zero']  = lambda{|_| 'Products'}
      Pagy::Frontend::I18N['en'][0]['pagy.info.product.one']   = lambda{|_| 'Product'}
      Pagy::Frontend::I18N['en'][0]['pagy.info.product.other'] = lambda{|_| 'Products'}
      frontend.pagy_info(Pagy.new count: 0, item_path: 'pagy.info.product').must_equal "No Products found"
      frontend.pagy_info(Pagy.new count: 1, item_path: 'pagy.info.product').must_equal "Displaying <b>1</b> Product"
      frontend.pagy_info(Pagy.new count: 13, item_path: 'pagy.info.product').must_equal "Displaying <b>all 13</b> Products"
      frontend.pagy_info(Pagy.new count: 100, item_path: 'pagy.info.product', page: 3).must_equal "Displaying Products <b>41-60</b> of <b>100</b> in total"
      Pagy::Frontend::I18N.load(locale: 'en') # reset for other tests
    end
  end

  describe '#pagy_url_for' do

    it 'renders basic url' do
      pagy = Pagy.new count: 1000, page: 3
      frontend.pagy_url_for(5, pagy). must_equal '/foo?page=5'
    end

    it 'renders url with params' do
      pagy = Pagy.new count: 1000, page: 3, params: {a: 3, b: 4}
      frontend.pagy_url_for(5, pagy).must_equal '/foo?page=5&a=3&b=4'
    end

    it 'renders url with anchor' do
      pagy = Pagy.new count: 1000, page: 3, anchor: '#anchor'
      frontend.pagy_url_for(6, pagy).must_equal '/foo?page=6#anchor'
    end

    it 'renders url with params and anchor' do
      pagy = Pagy.new count: 1000, page: 3, params: {a: 3, b: 4}, anchor: '#anchor'
      frontend.pagy_url_for(5, pagy).must_equal '/foo?page=5&a=3&b=4#anchor'
    end

  end

  describe '#pagy_get_params' do

    it 'overrides params' do
      overridden = TestViewOverride.new
      pagy = Pagy.new count: 1000, page: 3, params: {a: 3, b: 4}, anchor: '#anchor'
      overridden.pagy_url_for(5, pagy).must_equal '/foo?page=5&b=4&k=k#anchor'
    end

  end

end
