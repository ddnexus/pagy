# frozen_string_literal: true

require_relative '../../test_helper'

# Lazy trick to load ActiveSupport and crap while silencing the warnings
calendar = Pagy::Offset::Calendar
calendar.is_a?(Pagy)

Time.zone = 'EST'
Date.beginning_of_week = :sunday

DAY    = 60 * 60 * 24
PERIOD = [Time.zone.local(2021, 11, 4), Time.zone.local(2021, 11, 4) + 10.days].freeze

describe 'range_rescue' do
  let(:pagy_vars)      { { page: 100, limit: 10, count: 103, range_rescue: :empty_page } }
  let(:calendar_vars)  { { period: PERIOD, page: 100, range_rescue: :empty_page } }
  let(:countless_vars) { { page: 100, last: 50, limit: 10, range_rescue: :empty_page} }
  before do
    @pagy           = Pagy::Offset.new(**pagy_vars)
    @pagy_calendar  = Pagy::Offset::Calendar::Day.new(**calendar_vars)
    @pagy_countless = Pagy::Offset::Countless.new(**countless_vars).finalize(0)
  end

  describe "#range_rescued?" do
    it 'must be range_rescued?' do
      _(@pagy).must_be :range_rescued?
      _(@pagy_calendar).must_be :range_rescued?
      _(@pagy_countless).must_be :range_rescued?
    end
    it 'is not range_rescued?' do
      _(Pagy::Offset.new(**pagy_vars, page: 2)).wont_be :range_rescued?
      _(Pagy::Offset::Countless.new(**pagy_vars, page: 2, last: 2)).wont_be :range_rescued?
      _(Pagy::Offset::Calendar::Day.new(**calendar_vars, page: 2, range_rescue: :empty_page)).wont_be :range_rescued?
    end
  end

  describe '#initialize' do
    it 'works in :last_page mode in Pagy' do
      pagy = Pagy::Offset.new(**pagy_vars, range_rescue: :last_page)
      _(pagy).must_be_instance_of Pagy::Offset
      _(pagy.pages).must_equal 11
      _(pagy.page).must_equal pagy.last
      _(pagy.vars[:page]).must_equal 100
      _(pagy.offset).must_equal 100
      _(pagy.limit).must_equal 10
      _(pagy.from).must_equal 101
      _(pagy.to).must_equal 103
      _(pagy.prev).must_equal 10
    end
    it 'works in :last_page mode in Pagy::Offset::Calendar' do
      pagy = Pagy::Offset::Calendar::Day.new(**calendar_vars, range_rescue: :last_page)
      _(pagy).must_be_instance_of Pagy::Offset::Calendar::Day
      _(pagy.pages).must_equal 11
      _(pagy.page).must_equal pagy.last
      _(pagy.vars[:page]).must_equal 100
      _(pagy.from).must_equal pagy.instance_variable_get(:@final) - DAY
      _(pagy.to).must_equal pagy.instance_variable_get(:@final)
      _(pagy.prev).must_equal 10
    end
    it 'raises RangeError in :exception mode' do
      _ { Pagy::Offset.new(**pagy_vars, range_rescue: :exception) }.must_raise Pagy::RangeError
      _ { Pagy::Offset::Calendar::Day.new(**calendar_vars, range_rescue: :exception) }.must_raise Pagy::RangeError
      _ { Pagy::Offset::Countless.new(**countless_vars, range_rescue: :exception).finalize(0) }.must_raise Pagy::RangeError
    end
    it 'works in :empty_page mode in Pagy' do
      pagy = Pagy::Offset.new(**pagy_vars, range_rescue: :empty_page)
      _(pagy.page).must_equal 100
      _(pagy.offset).must_equal 0
      _(pagy.limit).must_equal 0
      _(pagy.vars[:limit]).must_equal 10
      _(pagy.in).must_equal 0
      _(pagy.from).must_equal 0
      _(pagy.to).must_equal 0
      _(pagy.prev).must_equal pagy.last
    end
    it 'works in :empty_page mode in Pagy::Offset::Calendar' do
      pagy = Pagy::Offset::Calendar::Day.new(**calendar_vars, range_rescue: :empty_page)
      _(pagy.page).must_equal 100
      _(pagy.from).must_equal pagy.instance_variable_get(:@final)
      _(pagy.to).must_equal pagy.instance_variable_get(:@final)
      _(pagy.prev).must_equal pagy.last
      pagy = Pagy::Offset::Calendar::Day.new(**calendar_vars, range_rescue: :empty_page, order: :desc)
      _(pagy.page).must_equal 100
      _(pagy.from).must_equal pagy.instance_variable_get(:@initial)
      _(pagy.to).must_equal pagy.instance_variable_get(:@initial)
      _(pagy.prev).must_equal pagy.last
    end
    # TODO: add case for last_page for countless
    it 'works in :empty_page mode in Pagy::Offset::Countless' do
      pagy = @pagy_countless
      _(pagy.page).must_equal 99    # reduce error by 1
      _(pagy.offset).must_equal 0
      _(pagy.limit).must_equal 0
      _(pagy.in).must_equal 0
      _(pagy.from).must_equal 0
      _(pagy.to).must_equal 0
      _(pagy.prev).must_equal 99
    end
    it 'raises Pagy::VariableError' do
      _ { Pagy::Offset.new(**pagy_vars, range_rescue: :unknown) }.must_raise Pagy::VariableError
      _ { Pagy::Offset::Calendar::Day.new(**calendar_vars, range_rescue: :unknown) }.must_raise Pagy::VariableError
      _ { Pagy::Offset::Countless.new(**countless_vars, range_rescue: :unknown).finalize(0) }.must_raise Pagy::VariableError
    end
  end

  describe "#series singleton for :empty_page mode" do
    it 'computes series for empty page for Pagy' do
      pagy = Pagy::Offset.new(**pagy_vars, range_rescue: :empty_page)
      series = pagy.series
      _(series).must_equal [1, :gap, 7, 8, 9, 10, 11]
      _(pagy.page).must_equal 100
    end
    it 'computes series for empty page for Pagy::Offset::Calendar' do
      pagy = Pagy::Offset::Calendar::Day.new(**calendar_vars, range_rescue: :empty_page)
      series = pagy.series
      _(series).must_equal([1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11])
      _(pagy.page).must_equal 100
    end
    it 'computes series for Pagy::Offset::Countless' do
      series = @pagy_countless.series
      _(series).must_equal [1, :gap, 95, 96, 97, 98, 99]
      _(@pagy_countless.page).must_equal 99   # reduce error by 1
    end
  end
end
