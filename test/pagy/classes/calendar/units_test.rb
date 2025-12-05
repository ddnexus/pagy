# frozen_string_literal: true

require 'test_helper'
require 'pagy/classes/calendar/calendar'
require 'pagy/toolbox/helpers/support/a_lambda' # just to check the page_label

Time.zone = 'Etc/GMT+5'
Date.beginning_of_week = :sunday

def pagy(cclass = Pagy::Calendar::Month, **)
  default = { period: [Time.zone.local(2021, 10, 21, 13, 18, 23, 0), Time.zone.local(2023, 11, 13, 15, 43, 40, 0)] }
  cclass.new(**default, **)
end

describe 'Pagy Calendar' do
  describe 'instance helpers and variables' do
    it 'defines calendar specific accessors' do
      _(pagy(Pagy::Calendar::Month)).must_respond_to :order
    end
    it 'raises Pagy::OptionError' do
      _ { Pagy::Calendar.new.send(:create, :unknown) }.must_raise Pagy::InternalError
      _ { pagy(Pagy::Calendar::Month, period: [1, 10]) }.must_raise Pagy::OptionError
      _ { pagy(Pagy::Calendar::Month, period: [Time.now]) }.must_raise Pagy::OptionError
      _ { pagy(Pagy::Calendar::Month, period: [Time.now, 2]) }.must_raise Pagy::OptionError
      _ { pagy(Pagy::Calendar::Month, period: [Time.now.utc, Time.now]) }.must_raise Pagy::OptionError
    end
  end

  describe 'it computes date variables for page 1 (default)' do
    it 'computes variables for :year' do
      p = pagy(Pagy::Calendar::Year)

      _(p.instance_variable_get(:@initial)).must_equal Time.zone.local(2021)
      _(p.instance_variable_get(:@final)).must_equal Time.zone.local(2024)
      _(p.from).must_equal Time.zone.local(2021)
      _(p.to).must_equal Time.zone.local(2022)
      _(p.last).must_equal 3
    end
    it 'computes variables for :year desc' do
      p = pagy(Pagy::Calendar::Year, order: :desc)

      _(p.instance_variable_get(:@initial)).must_equal Time.zone.local(2021)
      _(p.instance_variable_get(:@final)).must_equal Time.zone.local(2024)
      _(p.from).must_equal Time.zone.local(2023)
      _(p.to).must_equal Time.zone.local(2024)
      _(p.last).must_equal 3
    end
    it 'computes variables for :quarter' do
      p = pagy(Pagy::Calendar::Quarter)

      _(p.instance_variable_get(:@initial)).must_equal Time.zone.local(2021, 10, 1)
      _(p.instance_variable_get(:@final)).must_equal Time.zone.local(2024, 1, 1)
      _(p.from).must_equal Time.zone.local(2021, 10, 1)
      _(p.to).must_equal Time.zone.local(2022, 1, 1)
      _(p.last).must_equal 9
    end
    it 'computes variables for :quarter desc' do
      p = pagy(Pagy::Calendar::Quarter, order: :desc)

      _(p.instance_variable_get(:@initial)).must_equal Time.zone.local(2021, 10, 1)
      _(p.instance_variable_get(:@final)).must_equal Time.zone.local(2024, 1, 1)
      _(p.from).must_equal Time.zone.local(2023, 10, 1)
      _(p.to).must_equal Time.zone.local(2024, 1, 1)
      _(p.last).must_equal 9
    end
    it 'computes variables for :month' do
      p = pagy(Pagy::Calendar::Month)

      _(p.instance_variable_get(:@initial)).must_equal Time.zone.local(2021, 10, 1)
      _(p.instance_variable_get(:@final)).must_equal Time.zone.local(2023, 12, 1)
      _(p.from).must_equal Time.zone.local(2021, 10, 1)
      _(p.to).must_equal Time.zone.local(2021, 11, 1)
      _(p.last).must_equal 26
    end
    it 'computes variables for :month desc' do
      p = pagy(Pagy::Calendar::Month, order: :desc)

      _(p.instance_variable_get(:@initial)).must_equal Time.zone.local(2021, 10, 1)
      _(p.instance_variable_get(:@final)).must_equal Time.zone.local(2023, 12, 1)
      _(p.from).must_equal Time.zone.local(2023, 11, 1)
      _(p.to).must_equal Time.zone.local(2023, 12, 1)
      _(p.last).must_equal 26
    end
    it 'computes variables for :week' do
      p = pagy(Pagy::Calendar::Week)

      _(p.instance_variable_get(:@initial)).must_equal Time.zone.local(2021, 10, 17)
      _(p.instance_variable_get(:@final)).must_equal Time.zone.local(2023, 11, 19)
      _(p.from).must_equal Time.zone.local(2021, 10, 17)
      _(p.to).must_equal Time.zone.local(2021, 10, 24)
      _(p.last).must_equal 109
    end
    it 'computes variables for :day' do
      p = pagy(Pagy::Calendar::Day)

      _(p.instance_variable_get(:@initial)).must_equal Time.zone.local(2021, 10, 21)
      _(p.instance_variable_get(:@final)).must_equal Time.zone.local(2023, 11, 14)
      _(p.from).must_equal Time.zone.local(2021, 10, 21)
      _(p.to).must_equal Time.zone.local(2021, 10, 22)
      _(p.last).must_equal 754
    end
  end

  describe 'it computes date variables for page 2' do
    it 'computes variables for :year' do
      p = pagy(Pagy::Calendar::Year, page: 2)

      _(p.instance_variable_get(:@initial)).must_equal Time.zone.local(2021)
      _(p.instance_variable_get(:@final)).must_equal Time.zone.local(2024)
      _(p.from).must_equal Time.zone.local(2022)
      _(p.to).must_equal Time.zone.local(2023)
      _(p.last).must_equal 3
    end
    it 'computes variables for :year desc' do
      p = pagy(Pagy::Calendar::Year, page: 2, order: :desc)

      _(p.instance_variable_get(:@initial)).must_equal Time.zone.local(2021)
      _(p.instance_variable_get(:@final)).must_equal Time.zone.local(2024)
      _(p.from).must_equal Time.zone.local(2022)
      _(p.to).must_equal Time.zone.local(2023)
      _(p.last).must_equal 3
    end
    it 'computes variables for :quarter' do
      p = pagy(Pagy::Calendar::Quarter, page: 2)

      _(p.instance_variable_get(:@initial)).must_equal Time.zone.local(2021, 10, 1)
      _(p.instance_variable_get(:@final)).must_equal Time.zone.local(2024, 1, 1)
      _(p.from).must_equal Time.zone.local(2022, 1, 1)
      _(p.to).must_equal Time.zone.local(2022, 4, 1)
      _(p.last).must_equal 9
    end
    it 'computes variables for :quarter desc' do
      p = pagy(Pagy::Calendar::Quarter, page: 2, order: :desc)

      _(p.instance_variable_get(:@initial)).must_equal Time.zone.local(2021, 10, 1)
      _(p.instance_variable_get(:@final)).must_equal Time.zone.local(2024, 1, 1)
      _(p.from).must_equal Time.zone.local(2023, 7, 1)
      _(p.to).must_equal Time.zone.local(2023, 10, 1)
      _(p.last).must_equal 9
    end
    it 'computes variables for :month' do
      p = pagy(page: 2)

      _(p.instance_variable_get(:@initial)).must_equal Time.zone.local(2021, 10, 1)
      _(p.instance_variable_get(:@final)).must_equal Time.zone.local(2023, 12, 1)
      _(p.from).must_equal Time.zone.local(2021, 11, 1)
      _(p.to).must_equal Time.zone.local(2021, 12, 1)
      _(p.last).must_equal 26
    end
    it 'computes variables for :month desc' do
      p = pagy(page: 2, order: :desc)

      _(p.instance_variable_get(:@initial)).must_equal Time.zone.local(2021, 10, 1)
      _(p.instance_variable_get(:@final)).must_equal Time.zone.local(2023, 12, 1)
      _(p.from).must_equal Time.zone.local(2023, 10, 1)
      _(p.to).must_equal Time.zone.local(2023, 11, 1)
      _(p.last).must_equal 26
    end
    it 'computes variables for :week' do
      p = pagy(Pagy::Calendar::Week, page: 2)

      _(p.instance_variable_get(:@initial)).must_equal Time.zone.local(2021, 10, 17)
      _(p.instance_variable_get(:@final)).must_equal Time.zone.local(2023, 11, 19)
      _(p.from).must_equal Time.zone.local(2021, 10, 24)
      _(p.to).must_equal Time.zone.local(2021, 10, 31)
      _(p.last).must_equal 109
    end
    it 'computes variables for :day' do
      p = pagy(Pagy::Calendar::Day, page: 2)

      _(p.instance_variable_get(:@initial)).must_equal Time.zone.local(2021, 10, 21)
      _(p.instance_variable_get(:@final)).must_equal Time.zone.local(2023, 11, 14)
      _(p.from).must_equal Time.zone.local(2021, 10, 22)
      _(p.to).must_equal Time.zone.local(2021, 10, 23)
      _(p.last).must_equal 754
    end
  end

  describe 'it computes date variables for last page and range' do
    it 'computes variables for :year' do
      p = pagy(Pagy::Calendar::Year, page: 3)

      _(p.instance_variable_get(:@initial)).must_equal Time.zone.local(2021, 1, 1)
      _(p.instance_variable_get(:@final)).must_equal Time.zone.local(2024)
      _(p.from).must_equal Time.zone.local(2023)
      _(p.to).must_equal Time.zone.local(2024)
      _(p.last).must_equal 3
      _ { pagy(Pagy::Calendar::Year, page: 4, raise_range_error: true) }.must_raise Pagy::RangeError
    end
    it 'computes variables for :quarter' do
      p = pagy(Pagy::Calendar::Quarter, page: 9)

      _(p.instance_variable_get(:@initial)).must_equal Time.zone.local(2021, 10, 1)
      _(p.instance_variable_get(:@final)).must_equal Time.zone.local(2024, 1, 1)
      _(p.from).must_equal Time.zone.local(2023, 10, 1)
      _(p.to).must_equal Time.zone.local(2024, 1, 1)
      _(p.last).must_equal 9
    end
    it 'computes variables for :month' do
      p = pagy(page: 26)

      _(p.instance_variable_get(:@initial)).must_equal Time.zone.local(2021, 10, 1)
      _(p.instance_variable_get(:@final)).must_equal Time.zone.local(2023, 12, 1)
      _(p.from).must_equal Time.zone.local(2023, 11, 1)
      _(p.to).must_equal Time.zone.local(2023, 12, 1)
      _(p.last).must_equal 26
      _ { pagy(page: 27, raise_range_error: true) }.must_raise Pagy::RangeError
    end
    it 'computes variables for :week' do
      p = pagy(Pagy::Calendar::Week, page: 109)

      _(p.instance_variable_get(:@initial)).must_equal Time.zone.local(2021, 10, 17)
      _(p.instance_variable_get(:@final)).must_equal Time.zone.local(2023, 11, 19)
      _(p.from).must_equal Time.zone.local(2023, 11, 12)
      _(p.to).must_equal Time.zone.local(2023, 11, 19)
      _(p.last).must_equal 109
      _ { pagy(Pagy::Calendar::Week, page: 110, raise_range_error: true) }.must_raise Pagy::RangeError
    end
    it 'computes variables for :day' do
      p = pagy(Pagy::Calendar::Day, page: 754)

      _(p.instance_variable_get(:@initial)).must_equal Time.zone.local(2021, 10, 21)
      _(p.instance_variable_get(:@final)).must_equal Time.zone.local(2023, 11, 14)
      _(p.from).must_equal Time.zone.local(2023, 11, 13)
      _(p.to).must_equal Time.zone.local(2023, 11, 14)
      _(p.last).must_equal 754
      _ { pagy(Pagy::Calendar::Day, page: 755, raise_range_error: true) }.must_raise Pagy::RangeError
    end
  end

  describe 'time_offset_for' do
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

  describe 'label' do
    it 'uses the default and custom format' do
      p = pagy(unit: :month, order: :desc, page: 2)

      _(p.send(:page_label, 2)).must_equal 'Oct'
      _(p.send(:page_label, 2, format: '%B %Y')).must_equal 'October 2023'
    end
  end

  describe 'label' do
    [Pagy::Calendar::Year, Pagy::Calendar::Quarter, Pagy::Calendar::Month, Pagy::Calendar::Week, Pagy::Calendar::Day].each do |unit|
      it "labels the #{unit}" do
        p = pagy(unit)
        _(p.send(:page_label, 1)).must_rematch  :p1
        _(p.send(:page_label, 2)).must_rematch  :p2
      end
    end
  end

  # [Time.zone.local(2021, 10, 21, 13, 18, 23, 0), Time.zone.local(2023, 11, 13, 15, 43, 40, 0)]
  describe 'page_at' do
    it 'returns the page number for :year' do
      p = pagy(Pagy::Calendar::Year)

      _(p.send(:page_at, Time.zone.local(2021, 10, 21, 13, 18, 23, 0))).must_equal 1
      _(p.send(:page_at, Time.zone.local(2022, 1, 1, 13, 18, 23, 0))).must_equal 2
      _(p.send(:page_at, Time.zone.local(2023, 11, 13, 15, 43, 40, 0))).must_equal 3
      _(p.send(:page_at, Time.zone.local(2100), fit_time: true)).must_equal 3
      _(p.send(:page_at, Time.zone.local(2000), fit_time: true)).must_equal 1
      _ { p.send(:page_at, Time.zone.local(2100)) }.must_raise Pagy::RangeError
      _ { p.send(:page_at, Time.zone.local(2000)) }.must_raise Pagy::RangeError
    end
    it 'returns the page number for :year desc' do
      p = pagy(Pagy::Calendar::Year, order: :desc)

      _(p.send(:page_at, Time.zone.local(2021, 10, 21, 13, 18, 23, 0))).must_equal 3
      _(p.send(:page_at, Time.zone.local(2022, 1, 1, 13, 18, 23, 0))).must_equal 2
      _(p.send(:page_at, Time.zone.local(2023, 11, 13, 15, 43, 40, 0))).must_equal 1
      _(p.send(:page_at, Time.zone.local(2100), fit_time: true)).must_equal 1
      _(p.send(:page_at, Time.zone.local(2000), fit_time: true)).must_equal 3
      _ { p.send(:page_at, Time.zone.local(2100)) }.must_raise Pagy::RangeError
      _ { p.send(:page_at, Time.zone.local(2000)) }.must_raise Pagy::RangeError
    end

    it 'returns the page number for :quarter' do
      p = pagy(Pagy::Calendar::Quarter)

      _(p.send(:page_at, Time.zone.local(2021, 10, 21, 13, 18, 23, 0))).must_equal 1
      _(p.send(:page_at, Time.zone.local(2022, 1, 1, 13, 18, 23, 0))).must_equal 2
      _(p.send(:page_at, Time.zone.local(2023, 11, 13, 15, 43, 40, 0))).must_equal 9
      _(p.send(:page_at, Time.zone.local(2100), fit_time: true)).must_equal 9
      _(p.send(:page_at, Time.zone.local(2000), fit_time: true)).must_equal 1
      _ { p.send(:page_at, Time.zone.local(2100)) }.must_raise Pagy::RangeError
      _ { p.send(:page_at, Time.zone.local(2000)) }.must_raise Pagy::RangeError
    end
    it 'returns the page number for :quarter desc' do
      p = pagy(Pagy::Calendar::Quarter, order: :desc)

      _(p.send(:page_at, Time.zone.local(2021, 10, 21, 13, 18, 23, 0))).must_equal 9
      _(p.send(:page_at, Time.zone.local(2022, 1, 1, 13, 18, 23, 0))).must_equal 8
      _(p.send(:page_at, Time.zone.local(2023, 11, 13, 15, 43, 40, 0))).must_equal 1
      _(p.send(:page_at, Time.zone.local(2100), fit_time: true)).must_equal 1
      _(p.send(:page_at, Time.zone.local(2000), fit_time: true)).must_equal 9
      _ { p.send(:page_at, Time.zone.local(2100)) }.must_raise Pagy::RangeError
      _ { p.send(:page_at, Time.zone.local(2000)) }.must_raise Pagy::RangeError
    end
    it 'returns the page number for :month' do
      p = pagy

      _(p.send(:page_at, Time.zone.local(2021, 10, 21, 13, 18, 23, 0))).must_equal 1
      _(p.send(:page_at, Time.zone.local(2022, 1, 1, 13, 18, 23, 0))).must_equal 4
      _(p.send(:page_at, Time.zone.local(2023, 11, 13, 15, 43, 40, 0))).must_equal 26
      _(p.send(:page_at, Time.zone.local(2100), fit_time: true)).must_equal 26
      _(p.send(:page_at, Time.zone.local(2000), fit_time: true)).must_equal 1
      _ { p.send(:page_at, Time.zone.local(2100)) }.must_raise Pagy::RangeError
      _ { p.send(:page_at, Time.zone.local(2000)) }.must_raise Pagy::RangeError
    end
    it 'returns the page number for :month desc' do
      p = pagy(order: :desc)

      _(p.send(:page_at, Time.zone.local(2021, 10, 21, 13, 18, 23, 0))).must_equal 26
      _(p.send(:page_at, Time.zone.local(2022, 1, 1, 13, 18, 23, 0))).must_equal 23
      _(p.send(:page_at, Time.zone.local(2023, 11, 13, 15, 43, 40, 0))).must_equal 1
      _(p.send(:page_at, Time.zone.local(2100), fit_time: true)).must_equal 1
      _(p.send(:page_at, Time.zone.local(2000), fit_time: true)).must_equal 26
      _ { p.send(:page_at, Time.zone.local(2100)) }.must_raise Pagy::RangeError
      _ { p.send(:page_at, Time.zone.local(2000)) }.must_raise Pagy::RangeError
    end

    it 'returns the page number for :week' do
      p = pagy(Pagy::Calendar::Week)

      _(p.send(:page_at, Time.zone.local(2021, 10, 21))).must_equal 1
      _(p.send(:page_at, Time.zone.local(2021, 10, 26))).must_equal 2
      _(p.send(:page_at, Time.zone.local(2023, 11, 13))).must_equal 109
      _(p.send(:page_at, Time.zone.local(2100), fit_time: true)).must_equal 109
      _(p.send(:page_at, Time.zone.local(2000), fit_time: true)).must_equal 1
      _ { p.send(:page_at, Time.zone.local(2100)) }.must_raise Pagy::RangeError
      _ { p.send(:page_at, Time.zone.local(2000)) }.must_raise Pagy::RangeError
    end
    it 'returns the page number for :week desc' do
      p = pagy(Pagy::Calendar::Week, order: :desc)

      _(p.send(:page_at, Time.zone.local(2021, 10, 21))).must_equal 109
      _(p.send(:page_at, Time.zone.local(2021, 10, 26))).must_equal 108
      _(p.send(:page_at, Time.zone.local(2023, 11, 13))).must_equal 1
      _(p.send(:page_at, Time.zone.local(2100), fit_time: true)).must_equal 1
      _(p.send(:page_at, Time.zone.local(2000), fit_time: true)).must_equal 109
      _ { p.send(:page_at, Time.zone.local(2100)) }.must_raise Pagy::RangeError
      _ { p.send(:page_at, Time.zone.local(2000)) }.must_raise Pagy::RangeError
    end
    it 'returns the page number for :day' do
      p = pagy(Pagy::Calendar::Day)

      _(p.send(:page_at, Time.zone.local(2021, 10, 21))).must_equal 1
      _(p.send(:page_at, Time.zone.local(2021, 10, 26))).must_equal 6
      _(p.send(:page_at, Time.zone.local(2023, 11, 13))).must_equal 754
      _(p.send(:page_at, Time.zone.local(2100), fit_time: true)).must_equal 754
      _(p.send(:page_at, Time.zone.local(2000), fit_time: true)).must_equal 1
      _ { p.send(:page_at, Time.zone.local(2100)) }.must_raise Pagy::RangeError
      _ { p.send(:page_at, Time.zone.local(2000)) }.must_raise Pagy::RangeError
    end
    it 'returns the page number for :day desc' do
      p = pagy(Pagy::Calendar::Day, order: :desc)

      _(p.send(:page_at, Time.zone.local(2021, 10, 21))).must_equal 754
      _(p.send(:page_at, Time.zone.local(2021, 10, 26))).must_equal 749
      _(p.send(:page_at, Time.zone.local(2023, 11, 13))).must_equal 1
      _(p.send(:page_at, Time.zone.local(2100), fit_time: true)).must_equal 1
      _(p.send(:page_at, Time.zone.local(2000), fit_time: true)).must_equal 754
      _ { p.send(:page_at, Time.zone.local(2100)) }.must_raise Pagy::RangeError
      _ { p.send(:page_at, Time.zone.local(2000)) }.must_raise Pagy::RangeError
    end
  end

  describe 'Deprecated resources' do
    it 'sets the beginning_of_week from :offset' do
      pagy(Pagy::Calendar::Week, offset: 0)

      _(Date.beginning_of_week).must_equal :sunday
    end
  end
end
