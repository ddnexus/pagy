# frozen_string_literal: true

require_relative '../../test_helper'
require 'pagy/extras/countless'
require 'pagy/extras/gearbox'
require 'pagy/extras/items'
Pagy::DEFAULT[:items_extra] = false

describe 'pagy/extras/gearbox' do
  describe '#set_items_var' do
    it 'raises VariableErrors for wrong items types' do
      _ { Pagy.new(count: 3, page: 1,  gearbox_items: [-1, 10]) }.must_raise Pagy::VariableError
      _ { Pagy.new(count: 3, page: 1,  gearbox_items: [0, 10]) }.must_raise Pagy::VariableError
      _ { Pagy.new(count: 3, page: 1,  gearbox_items: [5, "10"]) }.must_raise Pagy::VariableError
    end
    it 'can skips gearbox in Pagy' do
      _(Pagy.new(count: 0, page: 1, items_extra: true).items).must_equal 20
      _(Pagy.new(count: 0, page: 1, gearbox_extra: false).items).must_equal 20
    end
    it 'sets the items in Pagy' do
      _(Pagy.new(count: 0,    page: 1).items).must_equal 15
      _(Pagy.new(count: 15,   page: 1).items).must_equal 15
      _(Pagy.new(count: 45,   page: 2).items).must_equal 30
      _(Pagy.new(count: 1000, page: 3).items).must_equal 60
      _(Pagy.new(count: 1000, page: 4).items).must_equal 100
      _(Pagy.new(count: 0,   page: 1,  gearbox_items: [3, 10]).items).must_equal 3
      _(Pagy.new(count: 3,   page: 1,  gearbox_items: [3, 10]).items).must_equal 3
      _(Pagy.new(count: 13,  page: 2,  gearbox_items: [3, 10]).items).must_equal 10
      _(Pagy.new(count: 103, page: 1,  gearbox_items: [3, 10]).items).must_equal 3
      _(Pagy.new(count: 103, page: 2,  gearbox_items: [3, 10]).items).must_equal 10
      _(Pagy.new(count: 103, page: 3,  gearbox_items: [3, 10]).items).must_equal 10
      _(Pagy.new(count: 103, page: 11, gearbox_items: [3, 10]).items).must_equal 10
    end
    it 'can skips gearbox in Pagy::Countless' do
      _(Pagy::Countless.new(count: 0, page: 1, items_extra: true).items).must_equal 20
      _(Pagy::Countless.new(count: 0, page: 1, gearbox_extra: false).items).must_equal 20
    end
    it 'sets the items in Pagy::Countless' do
      _(Pagy::Countless.new(count: 0,    page: 1).items).must_equal 15
      _(Pagy::Countless.new(count: 15,   page: 1).items).must_equal 15
      _(Pagy::Countless.new(count: 45,   page: 2).items).must_equal 30
      _(Pagy::Countless.new(count: 1000, page: 3).items).must_equal 60
      _(Pagy::Countless.new(count: 1000, page: 4).items).must_equal 100
      _(Pagy::Countless.new(count: 0,   page: 1,  gearbox_items: [3, 10]).items).must_equal 3
      _(Pagy::Countless.new(count: 3,   page: 1,  gearbox_items: [3, 10]).items).must_equal 3
      _(Pagy::Countless.new(count: 13,  page: 2,  gearbox_items: [3, 10]).items).must_equal 10
      _(Pagy::Countless.new(count: 103, page: 1,  gearbox_items: [3, 10]).items).must_equal 3
      _(Pagy::Countless.new(count: 103, page: 2,  gearbox_items: [3, 10]).items).must_equal 10
      _(Pagy::Countless.new(count: 103, page: 3,  gearbox_items: [3, 10]).items).must_equal 10
      _(Pagy::Countless.new(count: 103, page: 11, gearbox_items: [3, 10]).items).must_equal 10
    end
  end

  describe '#set_pages_var' do
    it 'can skip gearbox for pages' do
      _(Pagy.new(count: 90, page: 1, items_extra: true).pages).must_equal 5
      _(Pagy.new(count: 103, page: 1, gearbox_extra: false).pages).must_equal 6
    end
    it 'sets the pages' do
      _(Pagy.new(count: 0,   page: 1,  gearbox_items: [3, 10]).pages).must_equal 1
      _(Pagy.new(count: 3,   page: 1,  gearbox_items: [3, 10]).pages).must_equal 1
      _(Pagy.new(count: 13,  page: 2,  gearbox_items: [3, 10]).pages).must_equal 2
      _(Pagy.new(count: 103, page: 1,  gearbox_items: [3, 10]).pages).must_equal 11
      _(Pagy.new(count: 103, page: 2,  gearbox_items: [3, 10]).pages).must_equal 11
      _(Pagy.new(count: 103, page: 3,  gearbox_items: [3, 10]).pages).must_equal 11
      _(Pagy.new(count: 103, page: 11, gearbox_items: [3, 10]).pages).must_equal 11
    end
  end
end
