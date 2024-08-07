# frozen_string_literal: true

require_relative '../../test_helper'
require 'pagy/extras/countless'
require 'pagy/extras/gearbox'
require 'pagy/extras/limit'
Pagy::DEFAULT[:limit_extra] = false

describe 'pagy/extras/gearbox' do
  describe '#assign_limit' do
    it 'raises VariableErrors for wrong limit types' do
      _ { Pagy.new(count: 3, page: 1,  gearbox_limit: [-1, 10]) }.must_raise Pagy::VariableError
      _ { Pagy.new(count: 3, page: 1,  gearbox_limit: [0, 10]) }.must_raise Pagy::VariableError
      _ { Pagy.new(count: 3, page: 1,  gearbox_limit: [5, "10"]) }.must_raise Pagy::VariableError
    end
    it 'can skips gearbox in Pagy' do
      _(Pagy.new(count: 0, page: 1, limit_extra: true).limit).must_equal 20
      _(Pagy.new(count: 0, page: 1, gearbox_extra: false).limit).must_equal 20
    end
    it 'sets the limit in Pagy' do
      _(Pagy.new(count: 0,    page: 1).limit).must_equal 15
      _(Pagy.new(count: 15,   page: 1).limit).must_equal 15
      _(Pagy.new(count: 45,   page: 2).limit).must_equal 30
      _(Pagy.new(count: 1000, page: 3).limit).must_equal 60
      _(Pagy.new(count: 1000, page: 4).limit).must_equal 100
      _(Pagy.new(count: 0,   page: 1,  gearbox_limit: [3, 10]).limit).must_equal 3
      _(Pagy.new(count: 3,   page: 1,  gearbox_limit: [3, 10]).limit).must_equal 3
      _(Pagy.new(count: 13,  page: 2,  gearbox_limit: [3, 10]).limit).must_equal 10
      _(Pagy.new(count: 103, page: 1,  gearbox_limit: [3, 10]).limit).must_equal 3
      _(Pagy.new(count: 103, page: 2,  gearbox_limit: [3, 10]).limit).must_equal 10
      _(Pagy.new(count: 103, page: 3,  gearbox_limit: [3, 10]).limit).must_equal 10
      _(Pagy.new(count: 103, page: 11, gearbox_limit: [3, 10]).limit).must_equal 10
    end
    it 'can skips gearbox in Pagy::Countless' do
      _(Pagy::Countless.new(page: 1, limit_extra: true).limit).must_equal 20
      _(Pagy::Countless.new(page: 1, gearbox_extra: false).limit).must_equal 20
    end
    it 'sets the limit in Pagy::Countless' do
      _(Pagy::Countless.new(page: 1).limit).must_equal 15
      _(Pagy::Countless.new(page: 1).limit).must_equal 15
      _(Pagy::Countless.new(page: 2).limit).must_equal 30
      _(Pagy::Countless.new(page: 3).limit).must_equal 60
      _(Pagy::Countless.new(page: 4).limit).must_equal 100
      _(Pagy::Countless.new(page: 1, gearbox_limit: [3, 10]).limit).must_equal 3
      _(Pagy::Countless.new(page: 1, gearbox_limit: [3, 10]).limit).must_equal 3
      _(Pagy::Countless.new(page: 2, gearbox_limit: [3, 10]).limit).must_equal 10
      _(Pagy::Countless.new(page: 1, gearbox_limit: [3, 10]).limit).must_equal 3
      _(Pagy::Countless.new(page: 2, gearbox_limit: [3, 10]).limit).must_equal 10
      _(Pagy::Countless.new(page: 3, gearbox_limit: [3, 10]).limit).must_equal 10
      _(Pagy::Countless.new(page: 11, gearbox_limit: [3, 10]).limit).must_equal 10
    end
  end

  describe '#assign_last' do
    it 'can skip gearbox for last' do
      _(Pagy.new(count: 90, page: 1, limit_extra: true).last).must_equal 5
      _(Pagy.new(count: 103, page: 1, gearbox_extra: false).last).must_equal 6
    end
    it 'sets the last' do
      _(Pagy.new(count: 0,   page: 1,  gearbox_limit: [3, 10]).last).must_equal 1
      _(Pagy.new(count: 3,   page: 1,  gearbox_limit: [3, 10]).last).must_equal 1
      _(Pagy.new(count: 13,  page: 2,  gearbox_limit: [3, 10]).last).must_equal 2
      _(Pagy.new(count: 103, page: 1,  gearbox_limit: [3, 10]).last).must_equal 11
      _(Pagy.new(count: 103, page: 2,  gearbox_limit: [3, 10]).last).must_equal 11
      _(Pagy.new(count: 103, page: 3,  gearbox_limit: [3, 10]).last).must_equal 11
      _(Pagy.new(count: 103, page: 11, gearbox_limit: [3, 10]).last).must_equal 11
      # max_pages
      _(Pagy.new(count: 24, page: 2, gearbox_limit: [3, 10], max_pages: 2).last).must_equal 2
      _ { Pagy.new(count: 24, page: 3, gearbox_limit: [3, 10], max_pages: 2) }.must_raise Pagy::OverflowError
    end
    it "checks the last in Pagy::Countless" do
      _(Pagy::Countless.new(page: 1, gearbox_limit: [3, 10]).finalize(2).last).must_equal 1
      _(Pagy::Countless.new(page: 1, gearbox_limit: [3, 10]).finalize(4).last).must_equal 2
      _(Pagy::Countless.new(page: 3, gearbox_limit: [3, 10]).finalize(7).last).must_equal 3
      _(Pagy::Countless.new(page: 3, gearbox_limit: [3, 10]).finalize(11).last).must_equal 4
      # max_pages
      _(Pagy::Countless.new(page: 2, gearbox_limit: [3, 10], max_pages: 2).finalize(11).last).must_equal 2
      _ { Pagy::Countless.new(page: 3, gearbox_limit: [3, 10], max_pages: 2).finalize(11) }.must_raise Pagy::OverflowError
    end
  end

  describe '#assign_offset' do
    it "checks the offset in Pagy" do
      _(Pagy.new(count: 2, page: 1,  gearbox_limit: [3, 10]).offset).must_equal 0
      _(Pagy.new(count: 3, page: 1,  gearbox_limit: [3, 10]).offset).must_equal 0
      _(Pagy.new(count: 4, page: 1,  gearbox_limit: [3, 10]).offset).must_equal 0
      _(Pagy.new(count: 10, page: 2,  gearbox_limit: [3, 10]).offset).must_equal 3
      _(Pagy.new(count: 13, page: 2,  gearbox_limit: [3, 10]).offset).must_equal 3
      _(Pagy.new(count: 60, page: 3,  gearbox_limit: [3, 10]).offset).must_equal 13
      _(Pagy.new(count: 80, page: 4,  gearbox_limit: [3, 10]).offset).must_equal 23
    end
    it "checks the offset in Pagy::Countless" do
      _(Pagy::Countless.new(page: 1, gearbox_limit: [3, 10]).offset).must_equal 0
      _(Pagy::Countless.new(page: 2, gearbox_limit: [3, 10]).offset).must_equal 3
      _(Pagy::Countless.new(page: 3, gearbox_limit: [3, 10]).offset).must_equal 13
      _(Pagy::Countless.new(page: 4, gearbox_limit: [3, 10]).offset).must_equal 23
    end
  end
end
