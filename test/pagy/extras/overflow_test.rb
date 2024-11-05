# frozen_string_literal: true

require_relative '../../test_helper'
require 'pagy/calendar'
require 'pagy/countless'
require 'pagy/extras/overflow'

Time.zone = 'EST'
Date.beginning_of_week = :sunday

DAY    = 60 * 60 * 24
PERIOD = [Time.zone.local(2021, 11, 4), Time.zone.local(2021, 11, 4) + 10.days].freeze

describe 'pagy/extras/overflow' do
  let(:pagy_vars)      { { page: 100, limit: 10, count: 103 } }
  let(:countless_vars) { { page: 100, limit: 10 } }
  let(:calendar_vars)  { { period: PERIOD, page: 100 } }
  before do
    @pagy           = Pagy.new(**pagy_vars)
    @pagy_calendar  = Pagy::Calendar::Day.new(**calendar_vars)
    @pagy_countless = Pagy::Countless.new(**countless_vars).finalize(0)
  end

  describe "variables" do
    it 'has pagy_vars defaults' do
      _(Pagy::DEFAULT[:overflow]).must_equal :empty_page  # default for countless
    end
  end

  describe "#overflow?" do
    it 'must be overflow?' do
      _(@pagy).must_be :overflow?
      _(@pagy_calendar).must_be :overflow?
      _(@pagy_countless).must_be :overflow?
    end
    it 'is not overflow?' do
      _(Pagy.new(**pagy_vars, page: 2)).wont_be :overflow?
      _(Pagy::Countless.new(**pagy_vars, page: 2)).wont_be :overflow?
      _(Pagy::Calendar::Day.new(**calendar_vars, page: 2)).wont_be :overflow?
    end
  end

  describe '#initialize' do
    it 'works in :last_page mode in Pagy' do
      pagy = Pagy.new(**pagy_vars, overflow: :last_page)
      _(pagy).must_be_instance_of Pagy
      _(pagy.pages).must_equal 11
      _(pagy.page).must_equal pagy.last
      _(pagy.vars[:page]).must_equal 100
      _(pagy.offset).must_equal 100
      _(pagy.limit).must_equal 10
      _(pagy.from).must_equal 101
      _(pagy.to).must_equal 103
      _(pagy.prev).must_equal 10
    end
    it 'works in :last_page mode in Pagy::Calendar' do
      pagy = Pagy::Calendar::Day.new(**calendar_vars, overflow: :last_page)
      _(pagy).must_be_instance_of Pagy::Calendar::Day
      _(pagy.pages).must_equal 11
      _(pagy.page).must_equal pagy.last
      _(pagy.vars[:page]).must_equal 100
      _(pagy.from).must_equal pagy.instance_variable_get(:@final) - DAY
      _(pagy.to).must_equal pagy.instance_variable_get(:@final)
      _(pagy.prev).must_equal 10
    end
    it 'raises OverflowError in :exception mode' do
      _ { Pagy.new(**pagy_vars, overflow: :exception) }.must_raise Pagy::OverflowError
      _ { Pagy::Calendar::Day.new(**calendar_vars, overflow: :exception) }.must_raise Pagy::OverflowError
      _ { Pagy::Countless.new(**countless_vars, overflow: :exception).finalize(0) }.must_raise Pagy::OverflowError
    end
    it 'works in :empty_page mode in Pagy' do
      pagy = Pagy.new(**pagy_vars, overflow: :empty_page)
      _(pagy.page).must_equal 100
      _(pagy.offset).must_equal 990
      _(pagy.limit).must_equal 10
      _(pagy.in).must_equal 0
      _(pagy.from).must_equal 0
      _(pagy.to).must_equal 0
      _(pagy.prev).must_equal pagy.last
    end
    it 'works in :empty_page mode in Pagy::Calendar' do
      pagy = Pagy::Calendar::Day.new(**calendar_vars, overflow: :empty_page)
      _(pagy.page).must_equal 100
      _(pagy.from).must_equal pagy.instance_variable_get(:@final)
      _(pagy.to).must_equal pagy.instance_variable_get(:@final)
      _(pagy.prev).must_equal pagy.last
      pagy = Pagy::Calendar::Day.new(**calendar_vars, overflow: :empty_page, order: :desc)
      _(pagy.page).must_equal 100
      _(pagy.from).must_equal pagy.instance_variable_get(:@initial)
      _(pagy.to).must_equal pagy.instance_variable_get(:@initial)
      _(pagy.prev).must_equal pagy.last
    end
    it 'works in :empty_page mode in Pagy::Countless' do
      pagy = @pagy_countless
      _(pagy.page).must_equal 100
      _(pagy.offset).must_equal 0
      _(pagy.limit).must_equal 0
      _(pagy.in).must_be_nil
      _(pagy.from).must_equal 0
      _(pagy.to).must_equal 0
      _(pagy.prev).must_be_nil
    end
    it 'raises Pagy::VariableError' do
      _ { Pagy.new(**pagy_vars, overflow: :unknown) }.must_raise Pagy::VariableError
      _ { Pagy::Calendar::Day.new(**calendar_vars, overflow: :unknown) }.must_raise Pagy::VariableError
      _ { Pagy::Countless.new(**countless_vars, overflow: :unknown).finalize(0) }.must_raise Pagy::VariableError
    end
  end

  describe "#series singleton for :empty_page mode" do
    it 'computes series for empty page for Pagy' do
      pagy = Pagy.new(**pagy_vars, overflow: :empty_page)
      series = pagy.series
      _(series).must_equal [1, :gap, 7, 8, 9, 10, 11]
      _(pagy.page).must_equal 100
    end
    it 'computes series for empty page for Pagy::Calendar' do
      pagy = Pagy::Calendar::Day.new(**calendar_vars, overflow: :empty_page)
      series = pagy.series
      _(series).must_equal([1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11])
      _(pagy.page).must_equal 100
    end
    it 'computes empty series for Pagy::Countless' do
      series = @pagy_countless.series
      _(series).must_equal []
      _(@pagy_countless.page).must_equal 100
    end
  end
end
