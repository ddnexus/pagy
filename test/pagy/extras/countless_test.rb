# encoding: utf-8
# frozen_string_literal: true

require_relative '../../test_helper'
require 'pagy/extras/countless'

SingleCov.covered! unless ENV['SKIP_SINGLECOV']

describe Pagy::Backend do

  let(:backend) { TestController.new }

  let(:last_page) { 1000 / 20 }

  before do
    @default_page_param = Pagy::VARS[:page_param]
    @collection = TestCollection.new((1..1000).to_a)
  end

  after do
    Pagy::VARS[:page_param] = @default_page_param
  end

  describe "#pagy_countless" do

    it 'shows current and next for first page' do
      pagy, _ = backend.send(:pagy_countless, @collection, { size: [1, 4, 4, 1], page: 1 })
      pagy.series.must_equal ['1', 2]
      pagy.prev.must_be_nil
      pagy.next.must_equal 2
    end

    it 'shows start-pages, :gap, before-pages, current and next for intermediate page' do
      pagy, _ = backend.send(:pagy_countless, @collection, {page: 25})
      pagy.series.must_equal [1, :gap, 21, 22, 23, 24, '25', 26]
      pagy.prev.must_equal 24
      pagy.next.must_equal 26
    end

    it 'shows start-pages, :gap, before-pages, current and next for last page' do
      pagy, _ = backend.send(:pagy_countless, @collection, {page: last_page})
      pagy.series.must_equal [1, :gap, 46, 47, 48, 49, '50']
      pagy.prev.must_equal 49
      pagy.next.must_be_nil
    end

    it 'returns empty series for empty :size variable for first page' do
      pagy, _ = backend.send(:pagy_countless, @collection, {size: [], page: 1})
      pagy.series.must_equal []
      pagy.prev.must_be_nil
      pagy.next.must_equal 2
    end

    it 'returns empty series for empty :size variable for intermediate page' do
      pagy, _ = backend.send(:pagy_countless, @collection, {size: [], page: 25})
      pagy.series.must_equal []
      pagy.prev.must_equal 24
      pagy.next.must_equal 26
    end

    it 'returns empty series for empty :size variable for last page' do
      pagy, _ = backend.send(:pagy_countless, @collection, {size: [], page: last_page})
      pagy.series.must_equal []
      pagy.prev.must_equal 49
      pagy.next.must_be_nil
    end
  end

  describe '#pagy_countless_get_vars' do

    let(:backend) { TestController.new({a: 'a', page: 3, page_number: 4}) }

    it 'sets :page_param from defaults' do
      Pagy::VARS[:page_param] = :page_number
      pagy, items = backend.send(:pagy_countless, @collection)
      pagy.page.must_equal 4
      items.must_equal Array(61..80)
    end

    it 'sets :page_param from vars' do
      Pagy::VARS[:page_param] = :page
      pagy, items = backend.send(:pagy_countless, @collection, {page_param: :page_number})
      pagy.page.must_equal 4
      items.must_equal Array(61..80)
    end

    it 'bypasses :page_param with :page variable' do
      Pagy::VARS[:page_param] = :another_page_number
      pagy, items = backend.send(:pagy_countless, @collection, {page_param: :page_number, page: 1})
      pagy.page.must_equal 1
      items.must_equal Array(1..20)
    end

  end
end
