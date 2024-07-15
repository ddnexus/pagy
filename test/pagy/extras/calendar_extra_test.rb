# frozen_string_literal: true

require_relative '../../test_helper'
require 'pagy/extras/calendar'

require_relative '../../files/models'
require_relative '../../mock_helpers/app'

Time.zone = 'GMT'
Date.beginning_of_week = :sunday

def app(**opts)
  MockApp::Calendar.new(**opts)
end

describe 'pagy/extras/calendar' do
  describe 'instance methods' do
    it 'returns a Pagy::Calendar::Month instance' do
      calendar, pagy, _records = app(params: { page: 1 }).send(:pagy_calendar,
                                                               Event.all,
                                                               month: { period: [Time.now, Time.now + 5000] },
                                                               pagy: {})
      _(calendar[:month]).must_be_instance_of Pagy::Calendar::Month
      _(pagy).must_be_instance_of Pagy
    end
    it 'skips the calendar' do
      calendar, pagy, records = app(params: { page: 1 }).send(:pagy_calendar,
                                                              Event.all,
                                                              month: { period: [Time.now, Time.now + 5000] },
                                                              pagy: {},
                                                              active: false)
      _(calendar).must_be_nil
      _(records.size).must_equal 20
      _(pagy).must_be_instance_of Pagy
      _(pagy.count).must_equal 505
      _(pagy.pages).must_equal 26
    end
    it 'raises NoMethodError for #pagy_calendar_period' do
      error = assert_raises(NoMethodError) { MockApp.new.send(:pagy_calendar_period) }
      _(error.message).must_match 'the pagy_calendar_period method must be implemented by the application'
    end
    it 'raises NoMethodError for #pagy_calendar_filter' do
      error = assert_raises(NoMethodError) { MockApp.new.send(:pagy_calendar_filter) }
      _(error.message).must_match 'the pagy_calendar_filter method must be implemented by the application'
    end
    it 'raises ArgumentError for wrong conf' do
      _ { MockApp::Calendar.new.send(:pagy_calendar, Event.all, []) }.must_raise ArgumentError
      _ { MockApp::Calendar.new.send(:pagy_calendar, Event.all, unknown: {}) }.must_raise ArgumentError
      _ { MockApp::Calendar.new.send(:pagy_calendar, Event.all, year: []) }.must_raise TypeError
      _ { MockApp::Calendar.new.send(:pagy_calendar, Event.all, {}) }.must_raise ArgumentError
    end
    it 'selects :year for the pages and check the total' do
      total = 0
      calendar, _pagy, entries = app(params: { year_page: 1 }).send(:pagy_calendar,
                                                                    Event.all,
                                                                    year: {},
                                                                    pagy: { items: 600 })
      _(calendar[:year].series).must_equal ["1", 2, 3]
      _(calendar[:year].pages).must_equal 3
      _(calendar[:year].prev).must_be_nil
      _(calendar[:year].next).must_equal 2
      _(entries.map(&:time)).must_rematch :entries
      total += entries.size
      calendar, _pagy, entries = app(params: { year_page: 2 })
                                 .send(:pagy_calendar,
                                       Event.all,
                                       year: {},
                                       pagy: { items: 600 })
      _(calendar[:year].series).must_equal [1, "2", 3]
      _(calendar[:year].pages).must_equal 3
      _(calendar[:year].prev).must_equal 1
      _(calendar[:year].next).must_equal 3
      _(entries.map(&:time)).must_rematch :entries_2
      total += entries.size
      calendar, _pagy, entries = app(params: { year_page: 3 })
                                 .send(:pagy_calendar,
                                       Event.all,
                                       year: {},
                                       pagy: { items: 600 })
      _(calendar[:year].series).must_equal [1, 2, '3']
      _(calendar[:year].prev).must_equal 2
      _(calendar[:year].next).must_be_nil
      _(entries.map(&:time)).must_rematch :entries_3
      total += entries.size
      _(total).must_equal Event.all.size
    end
    it 'selects :quarter for the first page' do
      calendar, _pagy, entries = app(params: { quarter_page: 1 })
                                 .send(:pagy_calendar,
                                       Event.all,
                                       quarter: {},
                                       pagy: { items: 600 })
      _(calendar[:quarter].series).must_equal ["1", 2, 3, 4]
      _(calendar[:quarter].pages).must_equal 9
      _(calendar[:quarter].prev).must_be_nil
      _(calendar[:quarter].next).must_equal 2
      _(entries.map(&:time)).must_rematch :entries
    end
    it 'selects :quarter for an intermediate page' do
      calendar, _pagy, entries = app(params: { quarter_page: 4 })
                                 .send(:pagy_calendar,
                                       Event.all,
                                       quarter: {},
                                       pagy: { items: 600 })
      _(calendar[:quarter].series).must_equal [3, "4", 5, 6]
      _(calendar[:quarter].pages).must_equal 9
      _(calendar[:quarter].prev).must_equal 3
      _(calendar[:quarter].next).must_equal 5
      _(entries.map(&:time)).must_rematch :entries
    end
    it 'selects :quarter for last page' do
      calendar, _pagy, entries = app(params: { quarter_page: 9 })
                                 .send(:pagy_calendar,
                                       Event.all,
                                       quarter: {},
                                       pagy: { items: 600 })
      _(calendar[:quarter].series).must_equal [6, 7, 8, "9"]
      _(calendar[:quarter].pages).must_equal 9
      _(calendar[:quarter].prev).must_equal 8
      _(calendar[:quarter].next).must_be_nil
      _(entries.map(&:time)).must_rematch :entries
    end
    it 'selects :month for the first page' do
      calendar, _pagy, entries = app(params: { month_page: 1 })
                                 .send(:pagy_calendar,
                                       Event.all,
                                       month: {},
                                       pagy: { items: 600 })
      _(calendar[:month].series).must_equal ["1", 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12]
      _(calendar[:month].pages).must_equal 26
      _(calendar[:month].prev).must_be_nil
      _(calendar[:month].next).must_equal 2
      _(entries.map(&:time)).must_rematch :entries
    end
    it 'selects :month for an intermediate page' do
      calendar, _pagy, entries = app(params: { month_page: 25 })
                                 .send(:pagy_calendar,
                                       Event.all,
                                       month: {},
                                       pagy: { items: 600 })
      _(calendar[:month].series).must_equal [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, "25", 26]
      _(calendar[:month].prev).must_equal 24
      _(calendar[:month].next).must_equal 26
      _(entries.map(&:time)).must_rematch :entries
    end
    it 'selects :month for the last page' do
      calendar, _pagy, entries = app(params: { month_page: 26 })
                                 .send(:pagy_calendar,
                                       Event.all,
                                       month: {},
                                       pagy: { items: 600 })
      _(calendar[:month].series).must_equal [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, "26"]
      _(calendar[:month].prev).must_equal 25
      _(calendar[:month].next).must_be_nil
      _(entries.map(&:time)).must_rematch :entries
    end
    it 'selects :week for the first page' do
      calendar, _pagy, entries = app(params: { week_page: 1 })
                                 .send(:pagy_calendar,
                                       Event.all,
                                       week: { first_weekday: :sunday },
                                       pagy: { items: 600 })
      _(calendar[:week].series).must_equal ["1", 2, 3, 4, 5, :gap, 109]
      _(calendar[:week].pages).must_equal 109
      _(calendar[:week].prev).must_be_nil
      _(calendar[:week].next).must_equal 2
      _(entries.map(&:time)).must_rematch :entries
    end
    it 'selects :week for an intermediate page' do
      calendar, _pagy, entries = app(params: { week_page: 25 })
                                 .send(:pagy_calendar,
                                       Event.all,
                                       week: { first_weekday: :sunday },
                                       pagy: { items: 600 })
      _(calendar[:week].series).must_equal [1, :gap, 24, "25", 26, :gap, 109]
      _(calendar[:week].prev).must_equal 24
      _(calendar[:week].next).must_equal 26
      _(entries.map(&:time)).must_rematch :entries
    end
    it 'selects :week for the last page' do
      calendar, _pagy, entries = app(params: { week_page: 109 })
                                 .send(:pagy_calendar,
                                       Event.all,
                                       week: { first_weekday: :sunday },
                                       pagy: { items: 600 })
      _(calendar[:week].series).must_equal [1, :gap, 105, 106, 107, 108, "109"]
      _(calendar[:week].prev).must_equal 108
      _(calendar[:week].next).must_be_nil
      _(entries.map(&:time)).must_rematch :entries
    end
    it 'selects :day for the first page' do
      calendar, _pagy, entries = app(params: { day_page: 1 })
                                 .send(:pagy_calendar,
                                       Event40.all,
                                       day: {},
                                       pagy: { items: 600 })
      _(calendar[:day].series).must_equal ["1", 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31]

      _(calendar[:day].pages).must_equal 60
      _(calendar[:day].prev).must_be_nil
      _(calendar[:day].next).must_equal 2
      _(entries.map(&:time)).must_rematch :entries
    end
    it 'selects :day for an intermediate page' do
      calendar, _pagy, entries = app(params: { day_page: 25 })
                                 .send(:pagy_calendar,
                                       Event40.all,
                                       day: {},
                                       pagy: { items: 600 })
      _(calendar[:day].series).must_equal([10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, "25", 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40])

      _(calendar[:day].prev).must_equal 24
      _(calendar[:day].next).must_equal 26
      _(entries.map(&:time)).must_rematch :entries
    end
    it 'selects :day for the last page' do
      calendar, _pagy, entries = app(params: { day_page: 60 })
                                 .send(:pagy_calendar,
                                       Event40.all,
                                       day: {},
                                       pagy: { items: 600 })
      _(calendar[:day].series).must_equal [30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, "60"]
      _(calendar[:day].prev).must_equal 59
      _(calendar[:day].next).must_be_nil
      _(entries.map(&:time)).must_rematch :entries
    end
    it 'runs multiple units' do
      calendar, pagy, entries = app(params: { year_page: 2, month_page: 7, page: 2 })
                                .send(:pagy_calendar,
                                      Event.all, year: {},
                                      month: {},
                                      pagy: { items: 10 })
      _(calendar[:year].series).must_equal [1, "2", 3]
      _(calendar[:month].series).must_equal [1, 2, 3, 4, 5, 6, "7", 8, 9, 10, 11, 12]
      _(pagy.series).must_equal [1, "2", 3]
      _(entries.map(&:time)).must_rematch :entries
    end
  end

  describe 'pagy_calendar_url_at' do
    it 'returns the url' do
      calendar, _pagy, _entries = app(params: { year_page: 2, month_page: 7, page: 2 })
                                  .send(:pagy_calendar,
                                        Event.all,
                                        year: {},
                                        month: {},
                                        pagy: { items: 10 })
      _(app.send(:pagy_calendar_url_at, calendar, Time.zone.local(2021, 12, 21)))
        .must_equal "/foo?page=1&year_page=1&month_page=3"

      _(app.send(:pagy_calendar_url_at, calendar, Time.zone.local(2022, 2, 10)))
        .must_equal  "/foo?page=1&year_page=2&month_page=2"

      _(app.send(:pagy_calendar_url_at, calendar, Time.zone.local(2023, 11, 10)))
        .must_equal  "/foo?page=1&year_page=3&month_page=11"

      _(app.send(:pagy_calendar_url_at, calendar, Time.zone.local(2100), fit_time: true))
        .must_equal "/foo?page=1&year_page=3&month_page=11"

      _(app.send(:pagy_calendar_url_at, calendar, Time.zone.local(2000), fit_time: true))
        .must_equal "/foo?page=1&year_page=1&month_page=1"

      _ { app.send(:pagy_calendar_url_at, calendar, Time.zone.local(2100)) }
        .must_raise Pagy::Calendar::OutOfRangeError

      _ { app.send(:pagy_calendar_url_at, calendar, Time.zone.local(2000)) }
        .must_raise Pagy::Calendar::OutOfRangeError
    end
  end
  describe "#showtime" do
    it "returns the showtime" do
      calendar, _pagy, _entries = app(params: { year_page: 2, month_page: 7, page: 2 })
                                  .send(:pagy_calendar, Event.all,
                                        year: {},
                                        month: {},
                                        pagy: { items: 10 })
      _(calendar.showtime).must_equal Time.zone.local(2022, 7, 1)
    end
  end
  describe "Counts feature" do
    [MockApp::CalendarCounts, MockApp::CalendarCountsSkip].each do |c|
      it "works with #{c}" do
        app_counts = c.new(params: { year_page: 2,
                                     month_page: 7,
                                     day_page: 4,
                                     page: 1 })
        calendar, _pagy, _entries = app_counts.send(:pagy_calendar,
                                                    Event.all,
                                                    year: {},
                                                    month: {},
                                                    day: {},
                                                    pagy: { items: 10 })
        _(app_counts.pagy_nav(calendar[:year])).must_rematch :year
        _(app_counts.pagy_nav(calendar[:month])).must_rematch :month
        _(app_counts.pagy_nav(calendar[:day])).must_rematch :day
      end
    end
    it 'works with anchor_string' do
      c = MockApp::CalendarCounts
      app_counts = c.new(params: { year_page: 2,
                                   page: 1 })
      calendar, _pagy, _entries = app_counts.send(:pagy_calendar,
                                                  Event.all,
                                                  year: {},
                                                  pagy: { items: 10 })
      _(app_counts.pagy_nav(calendar[:year], anchor_string: 'data-foo="bar"')).must_rematch :year
    end
  end
end
