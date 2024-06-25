# frozen_string_literal: true

require_relative '../test_helper'
require 'pagy/calendar'

Time.zone = 'EST'
Date.beginning_of_week = :sunday

def pagy(unit: :month, **vars)
  default = { period: [Time.zone.local(2021, 10, 21, 13, 18, 23, 0), Time.zone.local(2023, 11, 13, 15, 43, 40, 0)] }
  Pagy::Calendar.send(:create, unit, default.merge(vars))
end

describe 'pagy/calendar' do
  describe 'instance methods and variables' do
    it 'defines calendar specific accessors' do
      assert_respond_to pagy, :order
    end
    it 'raises Pagy::VariableError' do
      _ { pagy(unit: :unknown) }.must_raise Pagy::InternalError
      _ { pagy(period: [1, 10]) }.must_raise Pagy::VariableError
      _ { pagy(period: [Time.now]) }.must_raise Pagy::VariableError
      _ { pagy(period: [Time.now, 2]) }.must_raise Pagy::VariableError
      _ { pagy(period: [Time.now.utc, Time.now]) }.must_raise Pagy::VariableError
      _ { pagy(order: :unknown) }.must_raise Pagy::VariableError
      _ { pagy(unit: :year, format: :unknown) }.must_raise Pagy::VariableError
      _ { pagy(unit: :quarter, format: :unknown) }.must_raise Pagy::VariableError
      _ { pagy(unit: :month, format: :unknown) }.must_raise Pagy::VariableError
      _ { pagy(unit: :week, format: :unknown) }.must_raise Pagy::VariableError
      _ { pagy(unit: :day, format: :unknown) }.must_raise Pagy::VariableError
    end
  end

  describe 'it computes date variables for page 1 (default)' do
    it 'computes variables for :year' do
      p = pagy(unit: :year)
      _(p.instance_variable_get(:@initial)).must_equal Time.zone.local(2021)
      _(p.instance_variable_get(:@final)).must_equal Time.zone.local(2024)
      _(p.from).must_equal Time.zone.local(2021)
      _(p.to).must_equal Time.zone.local(2022)
      _(p.pages).must_equal 3
      _(p.last).must_equal 3
    end
    it 'computes variables for :year desc' do
      p = pagy(unit: :year, order: :desc)
      _(p.instance_variable_get(:@initial)).must_equal Time.zone.local(2021)
      _(p.instance_variable_get(:@final)).must_equal Time.zone.local(2024)
      _(p.from).must_equal Time.zone.local(2023)
      _(p.to).must_equal Time.zone.local(2024)
      _(p.pages).must_equal 3
      _(p.last).must_equal 3
    end
    it 'computes variables for :quarter' do
      p = pagy(unit: :quarter)
      _(p.instance_variable_get(:@initial)).must_equal Time.zone.local(2021, 10, 1)
      _(p.instance_variable_get(:@final)).must_equal Time.zone.local(2024, 1, 1)
      _(p.from).must_equal Time.zone.local(2021, 10, 1)
      _(p.to).must_equal Time.zone.local(2022, 1, 1)
      _(p.pages).must_equal 9
      _(p.last).must_equal 9
    end
    it 'computes variables for :quarter desc' do
      p = pagy(unit: :quarter, order: :desc)
      _(p.instance_variable_get(:@initial)).must_equal Time.zone.local(2021, 10, 1)
      _(p.instance_variable_get(:@final)).must_equal Time.zone.local(2024, 1, 1)
      _(p.from).must_equal Time.zone.local(2023, 10, 1)
      _(p.to).must_equal Time.zone.local(2024, 1, 1)
      _(p.pages).must_equal 9
      _(p.last).must_equal 9
    end
    it 'computes variables for :month' do
      p = pagy
      _(p.instance_variable_get(:@initial)).must_equal Time.zone.local(2021, 10, 1)
      _(p.instance_variable_get(:@final)).must_equal Time.zone.local(2023, 12, 1)
      _(p.from).must_equal Time.zone.local(2021, 10, 1)
      _(p.to).must_equal Time.zone.local(2021, 11, 1)
      _(p.pages).must_equal 26
      _(p.last).must_equal 26
    end
    it 'computes variables for :month desc' do
      p = pagy(unit: :month, order: :desc)
      _(p.instance_variable_get(:@initial)).must_equal Time.zone.local(2021, 10, 1)
      _(p.instance_variable_get(:@final)).must_equal Time.zone.local(2023, 12, 1)
      _(p.from).must_equal Time.zone.local(2023, 11, 1)
      _(p.to).must_equal Time.zone.local(2023, 12, 1)
      _(p.pages).must_equal 26
      _(p.last).must_equal 26
    end
    it 'computes variables for :week' do
      p = pagy(unit: :week)
      _(p.instance_variable_get(:@initial)).must_equal Time.zone.local(2021, 10, 17)
      _(p.instance_variable_get(:@final)).must_equal Time.zone.local(2023, 11, 19)
      _(p.from).must_equal Time.zone.local(2021, 10, 17)
      _(p.to).must_equal Time.zone.local(2021, 10, 24)
      _(p.pages).must_equal 109
      _(p.last).must_equal 109
    end
    it 'computes variables for :day' do
      p = pagy(unit: :day)
      _(p.instance_variable_get(:@initial)).must_equal Time.zone.local(2021, 10, 21)
      _(p.instance_variable_get(:@final)).must_equal Time.zone.local(2023, 11, 14)
      _(p.from).must_equal Time.zone.local(2021, 10, 21)
      _(p.to).must_equal Time.zone.local(2021, 10, 22)
      _(p.pages).must_equal 754
      _(p.last).must_equal 754
    end
  end

  describe 'it computes date variables for page 2' do
    it 'computes variables for :year' do
      p = pagy(unit: :year, page: 2)
      _(p.instance_variable_get(:@initial)).must_equal Time.zone.local(2021)
      _(p.instance_variable_get(:@final)).must_equal Time.zone.local(2024)
      _(p.from).must_equal Time.zone.local(2022)
      _(p.to).must_equal Time.zone.local(2023)
      _(p.pages).must_equal 3
      _(p.last).must_equal 3
    end
    it 'computes variables for :year desc' do
      p = pagy(unit: :year, page: 2, order: :desc)
      _(p.instance_variable_get(:@initial)).must_equal Time.zone.local(2021)
      _(p.instance_variable_get(:@final)).must_equal Time.zone.local(2024)
      _(p.from).must_equal Time.zone.local(2022)
      _(p.to).must_equal Time.zone.local(2023)
      _(p.pages).must_equal 3
      _(p.last).must_equal 3
    end
    it 'computes variables for :quarter' do
      p = pagy(unit: :quarter, page: 2)
      _(p.instance_variable_get(:@initial)).must_equal Time.zone.local(2021, 10, 1)
      _(p.instance_variable_get(:@final)).must_equal Time.zone.local(2024, 1, 1)
      _(p.from).must_equal Time.zone.local(2022, 1, 1)
      _(p.to).must_equal Time.zone.local(2022, 4, 1)
      _(p.pages).must_equal 9
      _(p.last).must_equal 9
    end
    it 'computes variables for :quarter desc' do
      p = pagy(unit: :quarter, page: 2, order: :desc)
      _(p.instance_variable_get(:@initial)).must_equal Time.zone.local(2021, 10, 1)
      _(p.instance_variable_get(:@final)).must_equal Time.zone.local(2024, 1, 1)
      _(p.from).must_equal Time.zone.local(2023, 7, 1)
      _(p.to).must_equal Time.zone.local(2023, 10, 1)
      _(p.pages).must_equal 9
      _(p.last).must_equal 9
    end
    it 'computes variables for :month' do
      p = pagy(page: 2)
      _(p.instance_variable_get(:@initial)).must_equal Time.zone.local(2021, 10, 1)
      _(p.instance_variable_get(:@final)).must_equal Time.zone.local(2023, 12, 1)
      _(p.from).must_equal Time.zone.local(2021, 11, 1)
      _(p.to).must_equal Time.zone.local(2021, 12, 1)
      _(p.pages).must_equal 26
      _(p.last).must_equal 26
    end
    it 'computes variables for :month desc' do
      p = pagy(page: 2, order: :desc)
      _(p.instance_variable_get(:@initial)).must_equal Time.zone.local(2021, 10, 1)
      _(p.instance_variable_get(:@final)).must_equal Time.zone.local(2023, 12, 1)
      _(p.from).must_equal Time.zone.local(2023, 10, 1)
      _(p.to).must_equal Time.zone.local(2023, 11, 1)
      _(p.pages).must_equal 26
      _(p.last).must_equal 26
    end
    it 'computes variables for :week' do
      p = pagy(unit: :week, page: 2)
      _(p.instance_variable_get(:@initial)).must_equal Time.zone.local(2021, 10, 17)
      _(p.instance_variable_get(:@final)).must_equal Time.zone.local(2023, 11, 19)
      _(p.from).must_equal Time.zone.local(2021, 10, 24)
      _(p.to).must_equal Time.zone.local(2021, 10, 31)
      _(p.pages).must_equal 109
      _(p.last).must_equal 109
    end
    it 'computes variables for :day' do
      p = pagy(unit: :day, page: 2)
      _(p.instance_variable_get(:@initial)).must_equal Time.zone.local(2021, 10, 21)
      _(p.instance_variable_get(:@final)).must_equal Time.zone.local(2023, 11, 14)
      _(p.from).must_equal Time.zone.local(2021, 10, 22)
      _(p.to).must_equal Time.zone.local(2021, 10, 23)
      _(p.pages).must_equal 754
      _(p.last).must_equal 754
    end
  end

  describe 'it computes date variables for last page and overflow' do
    it 'computes variables for :year' do
      p = pagy(unit: :year, page: 3)
      _(p.instance_variable_get(:@initial)).must_equal Time.zone.local(2021, 1, 1)
      _(p.instance_variable_get(:@final)).must_equal Time.zone.local(2024)
      _(p.from).must_equal Time.zone.local(2023)
      _(p.to).must_equal Time.zone.local(2024)
      _(p.pages).must_equal 3
      _(p.last).must_equal 3
      _(pagy(unit: :year, page: 3, cycle: true).next).must_equal 1
      _ { pagy(unit: :year, page: 4) }.must_raise Pagy::OverflowError
    end
    it 'computes variables for :quarter' do
      p = pagy(unit: :quarter, page: 9)
      _(p.instance_variable_get(:@initial)).must_equal Time.zone.local(2021, 10, 1)
      _(p.instance_variable_get(:@final)).must_equal Time.zone.local(2024, 1, 1)
      _(p.from).must_equal Time.zone.local(2023, 10, 1)
      _(p.to).must_equal Time.zone.local(2024, 1, 1)
      _(p.pages).must_equal 9
      _(p.last).must_equal 9
    end
    it 'computes variables for :month' do
      p = pagy(page: 26)
      _(p.instance_variable_get(:@initial)).must_equal Time.zone.local(2021, 10, 1)
      _(p.instance_variable_get(:@final)).must_equal Time.zone.local(2023, 12, 1)
      _(p.from).must_equal Time.zone.local(2023, 11, 1)
      _(p.to).must_equal Time.zone.local(2023, 12, 1)
      _(p.pages).must_equal 26
      _(p.last).must_equal 26
      _(pagy(page: 26, cycle: true).next).must_equal 1
      _ { pagy(page: 27) }.must_raise Pagy::OverflowError
    end
    it 'computes variables for :week' do
      p = pagy(unit: :week, page: 109)
      _(p.instance_variable_get(:@initial)).must_equal Time.zone.local(2021, 10, 17)
      _(p.instance_variable_get(:@final)).must_equal Time.zone.local(2023, 11, 19)
      _(p.from).must_equal Time.zone.local(2023, 11, 12)
      _(p.to).must_equal Time.zone.local(2023, 11, 19)
      _(p.pages).must_equal 109
      _(p.last).must_equal 109
      _(pagy(unit: :week, page: 109, cycle: true).next).must_equal 1
      _ { pagy(unit: :week, page: 110) }.must_raise Pagy::OverflowError
    end
    it 'computes variables for :day' do
      p = pagy(unit: :day, page: 754)
      _(p.instance_variable_get(:@initial)).must_equal Time.zone.local(2021, 10, 21)
      _(p.instance_variable_get(:@final)).must_equal Time.zone.local(2023, 11, 14)
      _(p.from).must_equal Time.zone.local(2023, 11, 13)
      _(p.to).must_equal Time.zone.local(2023, 11, 14)
      _(p.pages).must_equal 754
      _(p.last).must_equal 754
      _(pagy(unit: :day, page: 754, cycle: true).next).must_equal 1
      _ { pagy(unit: :day, page: 755) }.must_raise Pagy::OverflowError
    end
  end

  describe '#time_offset_for' do
    it 'inverts the order' do
      p = pagy(unit: :month, order: :desc)
      _(p.send(:time_offset_for, 1)).must_equal 25
      _(p.send(:time_offset_for, 2)).must_equal 24
      _(p.send(:time_offset_for, 3)).must_equal 23
      _(p.send(:time_offset_for, 24)).must_equal 2
      _(p.send(:time_offset_for, 25)).must_equal 1
      _(p.send(:time_offset_for, 26)).must_equal 0
    end
  end

  describe '#label' do
    it 'uses the default and custom format' do
      p = pagy(unit: :month, order: :desc, page: 2)
      _(p.label).must_equal 'Oct'
      _(p.label(format: '%B %Y')).must_equal 'October 2023'
    end
  end

  describe '#label_for' do
    %i[year quarter month week day].each do |unit|
      it "labels the #{unit}" do
        p = pagy(unit: unit)
        _(p.label_for(1)).must_rematch  :p1
        _(p.label_for(2)).must_rematch  :p2
      end
    end
    it 'raises direct instantiation' do
      _ { Pagy::Calendar::Unit.new({}) }.must_raise Pagy::InternalError
    end
  end

  # [Time.zone.local(2021, 10, 21, 13, 18, 23, 0), Time.zone.local(2023, 11, 13, 15, 43, 40, 0)]
  describe '#page_at' do
    it 'returns the page number for :year' do
      p = pagy(unit: :year)
      _(p.send(:page_at, Time.zone.local(2021, 10, 21, 13, 18, 23, 0))).must_equal 1
      _(p.send(:page_at, Time.zone.local(2022, 1, 1, 13, 18, 23, 0))).must_equal 2
      _(p.send(:page_at, Time.zone.local(2023, 11, 13, 15, 43, 40, 0))).must_equal 3
      _(p.send(:page_at, Time.zone.local(2100), fit_time: true)).must_equal 3
      _(p.send(:page_at, Time.zone.local(2000), fit_time: true)).must_equal 1
      _ { p.send(:page_at, Time.zone.local(2100)) }.must_raise Pagy::Calendar::OutOfRangeError
      _ { p.send(:page_at, Time.zone.local(2000)) }.must_raise Pagy::Calendar::OutOfRangeError
    end
    it 'returns the page number for :year desc' do
      p = pagy(unit: :year, order: :desc)
      _(p.send(:page_at, Time.zone.local(2021, 10, 21, 13, 18, 23, 0))).must_equal 3
      _(p.send(:page_at, Time.zone.local(2022, 1, 1, 13, 18, 23, 0))).must_equal 2
      _(p.send(:page_at, Time.zone.local(2023, 11, 13, 15, 43, 40, 0))).must_equal 1
      _(p.send(:page_at, Time.zone.local(2100), fit_time: true)).must_equal 1
      _(p.send(:page_at, Time.zone.local(2000), fit_time: true)).must_equal 3
      _ { p.send(:page_at, Time.zone.local(2100)) }.must_raise Pagy::Calendar::OutOfRangeError
      _ { p.send(:page_at, Time.zone.local(2000)) }.must_raise Pagy::Calendar::OutOfRangeError
    end

    it 'returns the page number for :quarter' do
      p = pagy(unit: :quarter)
      _(p.send(:page_at, Time.zone.local(2021, 10, 21, 13, 18, 23, 0))).must_equal 1
      _(p.send(:page_at, Time.zone.local(2022, 1, 1, 13, 18, 23, 0))).must_equal 2
      _(p.send(:page_at, Time.zone.local(2023, 11, 13, 15, 43, 40, 0))).must_equal 9
      _(p.send(:page_at, Time.zone.local(2100), fit_time: true)).must_equal 9
      _(p.send(:page_at, Time.zone.local(2000), fit_time: true)).must_equal 1
      _ { p.send(:page_at, Time.zone.local(2100)) }.must_raise Pagy::Calendar::OutOfRangeError
      _ { p.send(:page_at, Time.zone.local(2000)) }.must_raise Pagy::Calendar::OutOfRangeError
    end
    it 'returns the page number for :quarter desc' do
      p = pagy(unit: :quarter, order: :desc)
      _(p.send(:page_at, Time.zone.local(2021, 10, 21, 13, 18, 23, 0))).must_equal 9
      _(p.send(:page_at, Time.zone.local(2022, 1, 1, 13, 18, 23, 0))).must_equal 8
      _(p.send(:page_at, Time.zone.local(2023, 11, 13, 15, 43, 40, 0))).must_equal 1
      _(p.send(:page_at, Time.zone.local(2100), fit_time: true)).must_equal 1
      _(p.send(:page_at, Time.zone.local(2000), fit_time: true)).must_equal 9
      _ { p.send(:page_at, Time.zone.local(2100)) }.must_raise Pagy::Calendar::OutOfRangeError
      _ { p.send(:page_at, Time.zone.local(2000)) }.must_raise Pagy::Calendar::OutOfRangeError
    end
    it 'returns the page number for :month' do
      p = pagy(unit: :month)
      _(p.send(:page_at, Time.zone.local(2021, 10, 21, 13, 18, 23, 0))).must_equal 1
      _(p.send(:page_at, Time.zone.local(2022, 1, 1, 13, 18, 23, 0))).must_equal 4
      _(p.send(:page_at, Time.zone.local(2023, 11, 13, 15, 43, 40, 0))).must_equal 26
      _(p.send(:page_at, Time.zone.local(2100), fit_time: true)).must_equal 26
      _(p.send(:page_at, Time.zone.local(2000), fit_time: true)).must_equal 1
      _ { p.send(:page_at, Time.zone.local(2100)) }.must_raise Pagy::Calendar::OutOfRangeError
      _ { p.send(:page_at, Time.zone.local(2000)) }.must_raise Pagy::Calendar::OutOfRangeError
    end
    it 'returns the page number for :month desc' do
      p = pagy(unit: :month, order: :desc)
      _(p.send(:page_at, Time.zone.local(2021, 10, 21, 13, 18, 23, 0))).must_equal 26
      _(p.send(:page_at, Time.zone.local(2022, 1, 1, 13, 18, 23, 0))).must_equal 23
      _(p.send(:page_at, Time.zone.local(2023, 11, 13, 15, 43, 40, 0))).must_equal 1
      _(p.send(:page_at, Time.zone.local(2100), fit_time: true)).must_equal 1
      _(p.send(:page_at, Time.zone.local(2000), fit_time: true)).must_equal 26
      _ { p.send(:page_at, Time.zone.local(2100)) }.must_raise Pagy::Calendar::OutOfRangeError
      _ { p.send(:page_at, Time.zone.local(2000)) }.must_raise Pagy::Calendar::OutOfRangeError
    end

    it 'returns the page number for :week' do
      p = pagy(unit: :week)
      _(p.send(:page_at, Time.zone.local(2021, 10, 21))).must_equal 1
      _(p.send(:page_at, Time.zone.local(2021, 10, 26))).must_equal 2
      _(p.send(:page_at, Time.zone.local(2023, 11, 13))).must_equal 109
      _(p.send(:page_at, Time.zone.local(2100), fit_time: true)).must_equal 109
      _(p.send(:page_at, Time.zone.local(2000), fit_time: true)).must_equal 1
      _ { p.send(:page_at, Time.zone.local(2100)) }.must_raise Pagy::Calendar::OutOfRangeError
      _ { p.send(:page_at, Time.zone.local(2000)) }.must_raise Pagy::Calendar::OutOfRangeError
    end
    it 'returns the page number for :week desc' do
      p = pagy(unit: :week, order: :desc)
      _(p.send(:page_at, Time.zone.local(2021, 10, 21))).must_equal 109
      _(p.send(:page_at, Time.zone.local(2021, 10, 26))).must_equal 108
      _(p.send(:page_at, Time.zone.local(2023, 11, 13))).must_equal 1
      _(p.send(:page_at, Time.zone.local(2100), fit_time: true)).must_equal 1
      _(p.send(:page_at, Time.zone.local(2000), fit_time: true)).must_equal 109
      _ { p.send(:page_at, Time.zone.local(2100)) }.must_raise Pagy::Calendar::OutOfRangeError
      _ { p.send(:page_at, Time.zone.local(2000)) }.must_raise Pagy::Calendar::OutOfRangeError
    end
    it 'returns the page number for :day' do
      p = pagy(unit: :day)
      _(p.send(:page_at, Time.zone.local(2021, 10, 21))).must_equal 1
      _(p.send(:page_at, Time.zone.local(2021, 10, 26))).must_equal 6
      _(p.send(:page_at, Time.zone.local(2023, 11, 13))).must_equal 754
      _(p.send(:page_at, Time.zone.local(2100), fit_time: true)).must_equal 754
      _(p.send(:page_at, Time.zone.local(2000), fit_time: true)).must_equal 1
      _ { p.send(:page_at, Time.zone.local(2100)) }.must_raise Pagy::Calendar::OutOfRangeError
      _ { p.send(:page_at, Time.zone.local(2000)) }.must_raise Pagy::Calendar::OutOfRangeError
    end
    it 'returns the page number for :day desc' do
      p = pagy(unit: :day, order: :desc)
      _(p.send(:page_at, Time.zone.local(2021, 10, 21))).must_equal 754
      _(p.send(:page_at, Time.zone.local(2021, 10, 26))).must_equal 749
      _(p.send(:page_at, Time.zone.local(2023, 11, 13))).must_equal 1
      _(p.send(:page_at, Time.zone.local(2100), fit_time: true)).must_equal 1
      _(p.send(:page_at, Time.zone.local(2000), fit_time: true)).must_equal 754
      _ { p.send(:page_at, Time.zone.local(2100)) }.must_raise Pagy::Calendar::OutOfRangeError
      _ { p.send(:page_at, Time.zone.local(2000)) }.must_raise Pagy::Calendar::OutOfRangeError
    end
  end

  describe 'Deprecated support' do
    it 'sets the beginning_of_week from :offset' do
      pagy(unit: :week, offset: 0)
      _(Date.beginning_of_week).must_equal :sunday
    end
  end
end
