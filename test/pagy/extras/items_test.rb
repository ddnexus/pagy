require_relative '../../test_helper'
require 'pagy/extras/items'

SingleCov.covered!

describe Pagy::Backend do

  describe "#pagy_get_vars" do
    before do
      @collection = TestCollection.new((1..1000).to_a)
    end

    def test_extra_items_default
      vars   = {}
      backend = TestController.new
      merged = backend.send :pagy_get_vars, @collection, vars
      assert_includes(merged.keys, :items)
      assert_nil(merged[:items])
    end

    def test_extra_items_vars
      vars   = {items: 15}     # force items
      params = {:a=>"a", :page=>3, :items=>12}

      backend = TestController.new params
      assert_equal(params, backend.params)

      pagy, _ = backend.send :pagy, @collection, vars
      assert_equal(15, pagy.items)
    end

    def test_extra_items_params
      vars   = {}
      params = {:a=>"a", :page=>3, :items=>12}

      backend = TestController.new params
      assert_equal(params, backend.params)

      pagy, _ = backend.send :pagy, @collection, vars
      assert_equal(12, pagy.items)
    end

    def test_extra_items_params_override
      vars   = {items: 21}
      params = {:a=>"a", :page=>3, :items=>12}

      backend = TestController.new params
      assert_equal(params, backend.params)

      pagy, _ = backend.send :pagy, @collection, vars
      assert_equal(21, pagy.items)
    end


    def test_extra_items_bigger_than_max
      vars   = {}
      params = {:a=>"a", :page=>3, :items=>120}

      backend = TestController.new params
      assert_equal(params, backend.params)

      pagy, _ = backend.send :pagy, @collection, vars
      assert_equal(100, pagy.items)
    end


    def test_extra_items_unlimited
      vars   = {max_items: nil}
      params = {:a=>"a", :items=>1000}

      backend = TestController.new params
      assert_equal(params, backend.params)

      pagy, _ = backend.send :pagy, @collection, vars
      assert_equal(1000, pagy.items)
    end

    def test_extra_items_unlimited_vars
      fork{
      vars = {}
      Pagy::VARS[:max_items] = nil
      params = {:a=>"a", :items=>1000}

      backend = TestController.new params
      assert_equal(params, backend.params)

      pagy, _ = backend.send :pagy, @collection, vars
      assert_equal(1000, pagy.items)
      }
    end

    def test_extra_items_param
      vars   = {items_param: :custom}
      params = {:a=>"a", :page=>3, :items_param=>:custom, :custom=>14}

      backend = TestController.new params
      assert_equal(params, backend.params)

      pagy, _ = backend.send :pagy, @collection, vars
      assert_equal(14, pagy.items)
    end

    def test_extra_items_param_global
      fork{
      vars = {}
      Pagy::VARS[:items_param] = :custom
      params = {:a=>"a", :page=>3, :custom=>15}

      backend = TestController.new params
      assert_equal(params, backend.params)

      pagy, _ = backend.send :pagy, @collection, vars
      assert_equal(15, pagy.items)
      }
    end

  end

end

describe Pagy::Frontend do

  let(:frontend) { TestView.new }

  describe '#pagy_url_for' do

    def test_extra_items_basic_url
      pagy = Pagy.new count: 1000, page: 3
      assert_equal '/foo?page=5&items=20', frontend.pagy_url_for(5, pagy)
    end

    def test_extra_items_url_with_items_param
      pagy = Pagy.new count: 1000, page: 3, items_param: :custom
      assert_equal '/foo?page=5&custom=20', frontend.pagy_url_for(5, pagy)
    end

    def test_extra_items_url_with_items
      pagy = Pagy.new count: 1000, page: 3, items: 50
      assert_equal '/foo?page=6&items=50', frontend.pagy_url_for(6, pagy)
    end

    def test_extra_items_url_with_params_and_anchor_and_items
      pagy = Pagy.new count: 1000, page: 3, params: {a: 3, b: 4}, anchor: '#anchor', items: 40
      assert_equal '/foo?page=5&items=40&a=3&b=4#anchor', frontend.pagy_url_for(5, pagy)
    end

  end

  describe '#pagy_items_selector' do

    def test_extra_items_pagy_items_selector
      @pagy = Pagy.new count: 1000, page: 3
      html, id = frontend.pagy_items_selector(@pagy), caller(0,1)[0].hash

      assert_equal(
      %(<span id="pagy-items-#{id}">) +
        %(<a href="/foo?page=#{Pagy::Frontend::MARKER}-page-&items=#{Pagy::Frontend::MARKER}-items-"></a>) +
        %(Show <input type="number" min="1" max="100" value="20" style="padding: 0; text-align: center; width: 3rem;"> items per page) +
      %(</span>) +
      %(<script type="application/json" class="pagy-items">["#{id}", "#{Pagy::Frontend::MARKER}", 41]</script>),

      html
      )
    end


  end
end
