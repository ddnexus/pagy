# frozen_string_literal: true

require_relative '../../../test_helper'
require_relative '../../../../gem/lib/pagy/toolbox/methods/support/series' # just to check the series

# Lazy trick to load ActiveSupport and crap while silencing the warnings
calendar = Pagy::Calendar
calendar.is_a?(Pagy)

Time.zone = 'EST'
Date.beginning_of_week = :sunday

DAY    = 60 * 60 * 24
PERIOD = [Time.zone.local(2021, 11, 4), Time.zone.local(2021, 11, 4) + 10.days].freeze

describe 'range' do
  # all empty page options
  let(:pagy_vars)      { { page: 100, limit: 10, count: 103 } }
  let(:calendar_vars)  { { period: PERIOD, page: 100 } }
  let(:countless_vars) { { page: 100, last: 50, limit: 10} }
  before do
    @pagy           = Pagy::Offset.new(**pagy_vars)
    @pagy_calendar  = Pagy::Calendar::Day.new(**calendar_vars)
    @pagy_countless = Pagy::Offset::Countless.new(**countless_vars).send(:finalize, 0)
  end

  describe "in_range?" do
    it 'wont be in_range?' do
      _(@pagy).wont_be :in_range?
      _(@pagy_calendar).wont_be :in_range?
      _(@pagy_countless).wont_be :in_range?
    end
    it 'is in_range?' do
      _(Pagy::Offset.new(**pagy_vars, page: 2)).must_be :in_range?
      _(Pagy::Offset::Countless.new(page: 2, last: 2, limit: 10).send(:finalize, 5)).must_be :in_range?
      _(Pagy::Calendar::Day.new(**calendar_vars, page: 2)).must_be :in_range?
    end
  end

  describe 'initialize' do
    it 'raises RangeError' do
      _ { Pagy::Offset.new(**pagy_vars, raise_range_error: true) }.must_raise Pagy::RangeError
      _ { Pagy::Calendar::Day.new(**calendar_vars, raise_range_error: true) }.must_raise Pagy::RangeError
      _ { Pagy::Offset::Countless.new(**countless_vars, raise_range_error: true).send(:finalize, 0) }.must_raise Pagy::RangeError
    end
    it 'works with empty_page in Pagy' do
      pagy = Pagy::Offset.new(**pagy_vars)
      _(pagy.page).must_equal 100
      _(pagy.options[:limit]).must_equal 10
      _(pagy.in).must_equal 0
      _(pagy.from).must_equal 0
      _(pagy.to).must_equal 0
      _(pagy.previous).must_equal pagy.last
    end
    it 'works with empty_page in in Pagy::Calendar' do
      pagy = Pagy::Calendar::Day.new(**calendar_vars)
      _(pagy.page).must_equal 100
      _(pagy.from).must_equal pagy.instance_variable_get(:@final)
      _(pagy.to).must_equal pagy.instance_variable_get(:@final)
      _(pagy.previous).must_equal pagy.last
      pagy = Pagy::Calendar::Day.new(**calendar_vars, range_rescue: :empty_page, order: :desc)
      _(pagy.page).must_equal 100
      _(pagy.from).must_equal pagy.instance_variable_get(:@initial)
      _(pagy.to).must_equal pagy.instance_variable_get(:@initial)
      _(pagy.previous).must_equal pagy.last
    end
    it 'works with empty_page in Pagy::Offset::Countless' do
      pagy = @pagy_countless
      _(pagy.page).must_equal 100
      _(pagy.in).must_equal 0
      _(pagy.from).must_equal 0
      _(pagy.to).must_equal 0
      _(pagy.previous).must_equal 50
    end
  end

  describe "series singleton for :empty_page" do
    it 'computes series for empty page for Pagy' do
      pagy = Pagy::Offset.new(**pagy_vars)
      series = pagy.send(:series)
      _(series).must_equal [1, :gap, 7, 8, 9, 10, 11]
      _(pagy.page).must_equal 100
    end
    it 'computes series for empty page for Pagy::Calendar' do
      pagy = Pagy::Calendar::Day.new(**calendar_vars)
      series = pagy.send(:series)
      _(series).must_equal([1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11])
      _(pagy.page).must_equal 100
    end
    it 'computes series for Pagy::Offset::Countless' do
      series = @pagy_countless.send(:series)
      _(series).must_equal [1, :gap, 46, 47, 48, 49, 50]
      _(@pagy_countless.page).must_equal 100   # reduce error by 1
    end
  end
end
