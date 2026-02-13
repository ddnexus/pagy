# frozen_string_literal: true

require 'unit/test_helper'
require 'pagy/classes/calendar/calendar'

describe 'Pagy::Calendar::Unit Specs' do
  # Use a concrete subclass (Year) to test inherited behavior
  let(:unit_class) { Pagy::Calendar::Year }
  let(:period) { [Time.zone.local(2021, 10, 21), Time.zone.local(2023, 11, 13)] }
  let(:default_opts) { { period: period } }

  before do
    Time.zone = 'Etc/GMT+5'
  end

  after do
    Time.zone = 'Etc/UTC'
  end

  def build(opts = {})
    unit_class.new(**default_opts, **opts)
  end

  describe 'initialization validations' do
    it 'raises OptionError if period is not an Array' do
      _ { build(period: "invalid") }.must_raise Pagy::OptionError
    end

    it 'raises OptionError if period items are not TimeWithZone' do
      _ { build(period: [Time.now, Time.now + 100]) }.must_raise Pagy::OptionError
    end

    it 'raises OptionError if starting time > ending time' do
      _ { build(period: [period[1], period[0]]) }.must_raise Pagy::OptionError
    end
  end

  describe '#page_at' do
    let(:pagy) { build }

    it 'returns page number for time within range' do
      # 2022 is in the range, page 2 (Year unit)
      _(pagy.send(:page_at, Time.zone.local(2022, 5, 1))).must_equal 2
    end

    it 'raises RangeError for time out of range' do
      _ { pagy.send(:page_at, Time.zone.local(2020)) }.must_raise Pagy::RangeError
      _ { pagy.send(:page_at, Time.zone.local(2030)) }.must_raise Pagy::RangeError
    end

    it 'fits time to start/end with fit_time option' do
      # Before initial -> page 1
      _(pagy.send(:page_at, Time.zone.local(2020), fit_time: true)).must_equal 1
      # After final -> last page (3)
      _(pagy.send(:page_at, Time.zone.local(2030), fit_time: true)).must_equal 3
    end
  end

  describe '#assign_empty_page_variables' do
    # Triggered when page is out of range and raise_range_error is false (default)
    it 'sets variables relative to final edge for :asc order' do
      # Page 10 is out of range. Order default :asc
      p = build(page: 10)
      final = p.instance_variable_get(:@final)

      _(p.in).must_equal 0
      _(p.from).must_equal final
      _(p.to).must_equal final
      _(p.previous).must_equal 3 # last page
    end

    it 'sets variables relative to initial edge for :desc order' do
      p = build(page: 10, order: :desc)
      initial = p.instance_variable_get(:@initial)

      _(p.in).must_equal 0
      _(p.from).must_equal initial
      _(p.to).must_equal initial
      _(p.previous).must_equal 3 # last page
    end
  end

  describe '#localize' do
    it 'formats time using strftime' do
      p = build
      time = Time.zone.local(2022, 1, 1)
      _(p.send(:localize, time, format: '%Y-%m')).must_equal '2022-01'
    end
  end

  describe '#active_period' do
    it 'returns period clipped to period start/end' do
      # Page 1 (2021): covers 2021-01-01 to 2022-01-01
      # Real Period starts 2021-10-21.
      # Intersection start should be max(@starting, @from) -> 2021-10-21

      p = build(page: 1)
      start_period, end_period = p.send(:active_period)

      _(start_period).must_equal period[0]
      # End should be min(@to - 1, @ending)
      # @to is 2022-01-01. @ending is 2023...
      # So end is @to - 1 (last moment of 2021)
      _(end_period).must_equal(p.to - 1)
    end

    it 'returns period clipped to page bounds if fully inside' do
      # Page 2 (2022): 2022-01-01 to 2023-01-01
      # Period covers all 2022.
      p = build(page: 2)
      start_period, end_period = p.send(:active_period)

      _(start_period).must_equal p.from
      _(end_period).must_equal(p.to - 1)
    end
  end

  describe '#time_offset_for' do
    it 'calculates offset for asc' do
      p = build(order: :asc)
      # page 1 -> 0 offset
      _(p.send(:time_offset_for, 1)).must_equal 0
      _(p.send(:time_offset_for, 2)).must_equal 1
    end

    it 'calculates offset for desc' do
      p = build(order: :desc)
      # page 1 -> last (3) - 1 = 2 offset
      _(p.send(:time_offset_for, 1)).must_equal 2
      # page 3 -> last (3) - 3 = 0 offset
      _(p.send(:time_offset_for, 3)).must_equal 0
    end
  end
end
