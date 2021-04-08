# frozen_string_literal: true

require_relative '../../test_helper'
require 'pagy/extras/countless'

describe Pagy::Backend do

  let(:controller) { MockController.new }

  let(:last_page) { 1000 / 20 }

  before do
    @default_page_param = Pagy::VARS[:page_param]
    @collection         = MockCollection.new
  end

  after do
    Pagy::VARS[:page_param] = @default_page_param
  end

  describe '#pagy_countless' do

    it 'shows current and next for first page' do
      pagy, = controller.send(:pagy_countless, @collection, { size: [1, 4, 4, 1], page: 1 })
      _(pagy.series).must_equal ['1', 2]
      _(pagy.prev).must_be_nil
      _(pagy.next).must_equal 2
    end

    it 'shows start-pages, :gap, before-pages, current and next for intermediate page' do
      pagy, = controller.send(:pagy_countless, @collection, {page: 25})
      _(pagy.series).must_equal [1, :gap, 21, 22, 23, 24, '25', 26]
      _(pagy.prev).must_equal 24
      _(pagy.next).must_equal 26
    end

    it 'shows start-pages, :gap, before-pages, current and next for last page' do
      pagy, = controller.send(:pagy_countless, @collection, {page: last_page})
      _(pagy.series).must_equal [1, :gap, 46, 47, 48, 49, '50']
      _(pagy.prev).must_equal 49
      _(pagy.next).must_be_nil
    end

    it 'returns empty series for empty :size variable for first page' do
      pagy, = controller.send(:pagy_countless, @collection, {size: [], page: 1})
      _(pagy.series).must_equal []
      _(pagy.prev).must_be_nil
      _(pagy.next).must_equal 2
    end

    it 'returns empty series for empty :size variable for intermediate page' do
      pagy, = controller.send(:pagy_countless, @collection, {size: [], page: 25})
      _(pagy.series).must_equal []
      _(pagy.prev).must_equal 24
      _(pagy.next).must_equal 26
    end

    it 'returns empty series for empty :size variable for last page' do
      pagy, = controller.send(:pagy_countless, @collection, {size: [], page: last_page})
      _(pagy.series).must_equal []
      _(pagy.prev).must_equal 49
      _(pagy.next).must_be_nil
    end
  end

  describe '#pagy_countless_get_vars' do

    let(:controller) { MockController.new({a: 'a', page: 3, page_number: 4}) }

    it 'sets :page_param from defaults' do
      Pagy::VARS[:page_param] = :page_number
      pagy, paged = controller.send(:pagy_countless, @collection)
      _(pagy.page).must_equal 4
      _(paged).must_equal Array(61..80)
    end

    it 'sets :page_param from vars' do
      Pagy::VARS[:page_param] = :page
      pagy, paged = controller.send(:pagy_countless, @collection, {page_param: :page_number})
      _(pagy.page).must_equal 4
      _(paged).must_equal Array(61..80)
    end

    it 'bypasses :page_param with :page variable' do
      Pagy::VARS[:page_param] = :another_page_number
      pagy, paged = controller.send(:pagy_countless, @collection, {page_param: :page_number, page: 1})
      _(pagy.page).must_equal 1
      _(paged).must_equal Array(1..20)
    end

  end
end
