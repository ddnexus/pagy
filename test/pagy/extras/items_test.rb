# encoding: utf-8
# frozen_string_literal: true

require_relative '../../test_helper'
require 'pagy/extras/countless'
require 'pagy/extras/items'

SingleCov.covered! unless ENV['SKIP_SINGLECOV']

describe Pagy::Backend do

  describe "#pagy_get_vars and #pagy_countless_get_vars" do

    before do
      @collection = TestCollection.new((1..1000).to_a)
    end

    it 'uses the defaults' do
      vars    = {}
      backend = TestController.new
      merged  = backend.send :pagy_get_vars, @collection, vars
      merged.keys.must_include :items
      merged[:items].must_be_nil
      merged_countless  = backend.send :pagy_countless_get_vars, @collection, vars
      merged_countless.keys.must_include :items
      merged_countless[:items].must_be_nil
    end

    it 'uses the vars' do
      vars    = {items: 15}     # force items
      params  = {:a=>"a", :page=>3, :items=>12}
      backend = TestController.new params
      backend.params.must_equal params
      pagy, _ = backend.send :pagy, @collection, vars
      pagy.items.must_equal 15
      pagy_countless, _ = backend.send :pagy_countless, @collection, vars
      pagy_countless.items.must_equal 15
    end

    it 'uses the params' do
      vars    = {}
      params  = {:a=>"a", :page=>3, :items=>12}
      backend = TestController.new params
      backend.params.must_equal params
      pagy, _ = backend.send :pagy, @collection, vars
      pagy.items.must_equal 12
      pagy_countless, _ = backend.send :pagy_countless, @collection, vars
      pagy_countless.items.must_equal 12
    end

    it 'overrides the params' do
      vars    = {items: 21}
      params  = {:a=>"a", :page=>3, :items=>12}
      backend = TestController.new params
      backend.params.must_equal params
      pagy, _ = backend.send :pagy, @collection, vars
      pagy.items.must_equal 21
      pagy_countless, _ = backend.send :pagy_countless, @collection, vars
      pagy_countless.items.must_equal 21
    end

    it 'uses the max_items default' do
      vars    = {}
      params  = {:a=>"a", :page=>3, :items=>120}
      backend = TestController.new params
      backend.params.must_equal params
      pagy, _ = backend.send :pagy, @collection, vars
      pagy.items.must_equal 100
      pagy_countless, _ = backend.send :pagy_countless, @collection, vars
      pagy_countless.items.must_equal 100
    end

    it 'doesn\'t limit the items from vars' do
      vars    = {max_items: nil}
      params  = {:a=>"a", :items=>1000}
      backend = TestController.new params
      backend.params.must_equal params
      pagy, _ = backend.send :pagy, @collection, vars
      pagy.items.must_equal 1000
      pagy_countless, _ = backend.send :pagy_countless, @collection, vars
      pagy_countless.items.must_equal 1000
    end

    it 'doesn\'t limit the items from default' do
      vars = {}
      params = {:a=>"a", :items=>1000}
      backend = TestController.new params
      backend.params.must_equal params
      Pagy::VARS[:max_items] = nil
      pagy, _ = backend.send :pagy, @collection, vars
      Pagy::VARS[:max_items] = 100
      pagy.items.must_equal 1000
      pagy_countless, _ = backend.send :pagy_countless, @collection, vars
      pagy_countless.items.must_equal 1000
    end

    it 'uses items_param from vars' do
      vars    = {items_param: :custom}
      params  = {:a=>"a", :page=>3, :items_param=>:custom, :custom=>14}
      backend = TestController.new params
      backend.params.must_equal params
      pagy, _ = backend.send :pagy, @collection, vars
      pagy.items.must_equal 14
      pagy_countless, _ = backend.send :pagy_countless, @collection, vars
      pagy_countless.items.must_equal 14
    end

    it 'uses items_param from default' do
      vars = {}
      params = {:a=>"a", :page=>3, :custom=>15}
      backend = TestController.new params
      backend.params.must_equal params
      Pagy::VARS[:items_param] = :custom
      pagy, _ = backend.send :pagy, @collection, vars
      Pagy::VARS[:items_param] = :items
      pagy.items.must_equal 15
      pagy_countless, _ = backend.send :pagy_countless, @collection, vars
      pagy_countless.items.must_equal 15
    end

  end

end

describe Pagy::Frontend do

  let(:frontend) { TestView.new }

  describe '#pagy_url_for' do

    it 'renders basic url' do
      pagy = Pagy.new count: 1000, page: 3
      frontend.pagy_url_for(5, pagy).must_equal '/foo?page=5&items=20'
    end

    it 'renders basic url and items var' do
      pagy = Pagy.new count: 1000, page: 3, items: 50
      frontend.pagy_url_for(5, pagy).must_equal '/foo?page=5&items=50'
    end

    it 'renders url with items_params' do
      pagy = Pagy.new count: 1000, page: 3, items_param: :custom
      frontend.pagy_url_for(5, pagy).must_equal '/foo?page=5&custom=20'
    end

    it 'renders url with anchor' do
      pagy = Pagy.new count: 1000, page: 3, anchor: '#anchor'
      frontend.pagy_url_for(6, pagy).must_equal '/foo?page=6&items=20#anchor'
    end

    it 'renders url with params and anchor' do
      pagy = Pagy.new count: 1000, page: 3, params: {a: 3, b: 4}, anchor: '#anchor', items: 40
      frontend.pagy_url_for(5, pagy).must_equal '/foo?page=5&items=40&a=3&b=4#anchor'
    end

  end

  describe '#pagy_items_selector' do

    it 'renders items selector' do
      @pagy = Pagy.new count: 1000, page: 3
      html = frontend.pagy_items_selector(@pagy, 'test-id')

      html.must_equal \
        %(<span id="test-id">) +
          %(<a href="/foo?page=#{Pagy::Frontend::MARKER}-page-&items=#{Pagy::Frontend::MARKER}-items-"></a>) +
          %(Show <input type="number" min="1" max="100" value="20" style="padding: 0; text-align: center; width: 3rem;"> items per page) +
        %(</span>) +
        %(<script type="application/json" class="pagy-json">["items","test-id","#{Pagy::Frontend::MARKER}",41]</script>)
    end

  end

end
