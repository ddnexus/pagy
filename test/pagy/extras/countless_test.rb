require 'byebug'
require_relative '../../test_helper'
require 'pagy/extras/countless'

SingleCov.covered!

describe Pagy::Backend do

  let(:backend) { TestController.new }

  let(:last_page) { 1000 / 20 }

  before do
    @collection = TestCollection.new((1..1000).to_a)
  end

  describe "#pagy_countless" do

    it 'vars[:size] = [1, 4, 4, 1], on first page only show Next page' do
      pagy, _ = backend.send(:pagy_countless, @collection, { size: [1, 4, 4, 1], page: 1 })
      pagy.series.must_equal ['1', 2]
      pagy.prev.must_be_nil
      pagy.next.must_equal 2
    end

    it 'vars[:size] = [1, 4, 4, 1] on 25 page, show one next page and previous pages with :gap' do
      pagy, _ = backend.send(:pagy_countless, @collection, {page: 25})
      pagy.series.must_equal [1, :gap, 21, 22, 23, 24, '25', 26]
      pagy.prev.must_equal 24
      pagy.next.must_equal 26
    end

    it 'vars[:size] = [1, 4, 4, 1] on last page show previous pages with :gap' do
      pagy, _ = backend.send(:pagy_countless, @collection, {page: last_page})
      pagy.series.must_equal [1, :gap, 46, 47, 48, 49, '50']
      pagy.prev.must_equal 49
      pagy.next.must_be_nil
    end

    it 'vars[:size] = [], on first page, should hide seris' do
      pagy, _ = backend.send(:pagy_countless, @collection, {size: [], page: 1})
      pagy.series.must_equal []
      pagy.prev.must_be_nil
      pagy.next.must_equal 2
    end

    it 'vars[:size] = [], in the middle, should hide seris' do
      pagy, _ = backend.send(:pagy_countless, @collection, {size: [], page: 25})
      pagy.series.must_equal []
      pagy.prev.must_equal 24
      pagy.next.must_equal 26
    end

    it 'vars[:size] = [], on last page, should hide seris' do
      pagy, _ = backend.send(:pagy_countless, @collection, {size: [], page: last_page})
      pagy.series.must_equal []
      pagy.prev.must_equal 49
      pagy.next.must_be_nil
    end
  end

  describe 'page_param in privete method "pagy_countless_get_vars"' do

    let(:backend) { TestController.new({a: 'a', page: 3, page_number: 4}) }
    
    it 'page_param from defaults' do
      Pagy::VARS[:page_param] = :page_number
      pagy, items = backend.send(:pagy_countless, @collection)
      pagy.page.must_equal 4
      items.must_equal Array(61..80)
    end

    it 'page_param from vars' do
      Pagy::VARS[:page_param] = :page
      pagy, items = backend.send(:pagy_countless, @collection, {page_param: :page_number})
      pagy.page.must_equal 4
      items.must_equal Array(61..80)
    end

    it 'bypass page_param with vars[:page]' do
      Pagy::VARS[:page_param] = :page_number
      pagy, items = backend.send(:pagy_countless, @collection, {page_param: :page_number, page: 1})
      pagy.page.must_equal 1
      items.must_equal Array(1..20)
    end
    
  end
end
