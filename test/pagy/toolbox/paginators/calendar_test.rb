# frozen_string_literal: true

require_relative '../../../test_helper'
require_relative '../../../files/models'
require_relative '../../../mock_helpers/app'
require_relative '../../../mock_helpers/collection'
require_relative '../../../../gem/lib/pagy/toolbox/helpers/support/series' # just to check the series
require_relative '../../../../gem/lib/pagy/toolbox/helpers/support/a_lambda' # just to check the a_lambda

def app(**)
  MockApp::Calendar.new(**)
end

describe 'calendar' do
  before do
    Time.zone = 'UTC'
    Date.beginning_of_week = :sunday
  end

  describe 'instance helpers' do
    it 'returns a Pagy::Calendar::Month instance' do
      calendar, pagy, _records = app(params: { page: 1 }).send(:pagy, :calendar,
                                                               Event.all,
                                                               month:  { period: [Time.now, Time.now + 5000] },
                                                               offset: {})

      _(calendar[:month]).must_be_instance_of Pagy::Calendar::Month
      _(pagy).must_be_instance_of Pagy::Offset
    end
    it 'skips the calendar' do
      calendar, pagy, records = app(params: { page: 1 }).send(:pagy, :calendar,
                                                              Event.all,
                                                              month:  { period: [Time.now, Time.now + 5000] },
                                                              offset: {},
                                                              disabled:   true)

      _(calendar).must_be_nil
      _(records.size).must_equal 20
      _(pagy).must_be_instance_of Pagy::Offset
      _(pagy.count).must_equal 505
      _(pagy.last).must_equal 26
    end
    it 'raises ArgumentError for wrong conf' do
      _ { MockApp::Calendar.new.send(:pagy, :calendar, Event.all, []) }.must_raise ArgumentError
      _ { MockApp::Calendar.new.send(:pagy, :calendar, Event.all, unknown: {}) }.must_raise ArgumentError
      _ { MockApp::Calendar.new.send(:pagy, :calendar, Event.all, year: []) }.must_raise TypeError
      _ { MockApp::Calendar.new.send(:pagy, :calendar, Event.all, {}) }.must_raise ArgumentError
    end
    it 'selects :year for the pages and check the total' do
      total                    = 0
      calendar, _pagy, entries = app(params: { year_page: 1 }).send(:pagy, :calendar,
                                                                    Event.all,
                                                                    year:   {},
                                                                    offset: { limit: 600 })

      _(calendar[:year].send(:series)).must_equal ["1", 2, 3]
      _(calendar[:year].last).must_equal 3
      _(calendar[:year].previous).must_be_nil
      _(calendar[:year].next).must_equal 2
      _(entries.map(&:time)).must_rematch :entries
      total                    += entries.size
      calendar, _pagy, entries = app(params: { year_page: 2 })
                                 .send(:pagy, :calendar,
                                       Event.all,
                                       year:   {},
                                       offset: { limit: 600 })

      _(calendar[:year].send(:series)).must_equal [1, "2", 3]
      _(calendar[:year].last).must_equal 3
      _(calendar[:year].previous).must_equal 1
      _(calendar[:year].next).must_equal 3
      _(entries.map(&:time)).must_rematch :entries_2
      total                    += entries.size
      calendar, _pagy, entries = app(params: { year_page: 3 })
                                 .send(:pagy, :calendar,
                                       Event.all,
                                       year:   {},
                                       offset: { limit: 600 })

      _(calendar[:year].send(:series)).must_equal [1, 2, '3']
      _(calendar[:year].previous).must_equal 2
      _(calendar[:year].next).must_be_nil
      _(entries.map(&:time)).must_rematch :entries_3
      total += entries.size

      _(total).must_equal Event.all.size
    end
    it 'selects :quarter for the first page' do
      calendar, _pagy, entries = app(params: { quarter_page: 1 })
                                 .send(:pagy, :calendar,
                                       Event.all,
                                       quarter: {},
                                       offset:  { limit: 600 })

      _(calendar[:quarter].send(:series)).must_equal ["1", 2, 3, 4]
      _(calendar[:quarter].last).must_equal 9
      _(calendar[:quarter].previous).must_be_nil
      _(calendar[:quarter].next).must_equal 2
      _(entries.map(&:time)).must_rematch :entries
    end
    it 'selects :quarter for an intermediate page' do
      calendar, _pagy, entries = app(params: { quarter_page: 4 })
                                 .send(:pagy, :calendar,
                                       Event.all,
                                       quarter: {},
                                       offset:  { limit: 600 })

      _(calendar[:quarter].send(:series)).must_equal [3, "4", 5, 6]
      _(calendar[:quarter].last).must_equal 9
      _(calendar[:quarter].previous).must_equal 3
      _(calendar[:quarter].next).must_equal 5
      _(entries.map(&:time)).must_rematch :entries
    end
    it 'selects :quarter for last page' do
      calendar, _pagy, entries = app(params: { quarter_page: 9 })
                                 .send(:pagy, :calendar,
                                       Event.all,
                                       quarter: {},
                                       offset:  { limit: 600 })

      _(calendar[:quarter].send(:series)).must_equal [6, 7, 8, "9"]
      _(calendar[:quarter].last).must_equal 9
      _(calendar[:quarter].previous).must_equal 8
      _(calendar[:quarter].next).must_be_nil
      _(entries.map(&:time)).must_rematch :entries
    end
    it 'selects :month for the first page' do
      calendar, _pagy, entries = app(params: { month_page: 1 })
                                 .send(:pagy, :calendar,
                                       Event.all,
                                       month:  {},
                                       offset: { limit: 600 })

      _(calendar[:month].send(:series)).must_equal ["1", 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12]
      _(calendar[:month].last).must_equal 26
      _(calendar[:month].previous).must_be_nil
      _(calendar[:month].next).must_equal 2
      _(entries.map(&:time)).must_rematch :entries
    end
    it 'selects :month for an intermediate page' do
      calendar, _pagy, entries = app(params: { month_page: 25 })
                                 .send(:pagy, :calendar,
                                       Event.all,
                                       month:  {},
                                       offset: { limit: 600 })

      _(calendar[:month].send(:series)).must_equal [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, "25", 26]
      _(calendar[:month].previous).must_equal 24
      _(calendar[:month].next).must_equal 26
      _(entries.map(&:time)).must_rematch :entries
    end
    it 'selects :month for the last page' do
      calendar, _pagy, entries = app(params: { month_page: 26 })
                                 .send(:pagy, :calendar,
                                       Event.all,
                                       month:  {},
                                       offset: { limit: 600 })

      _(calendar[:month].send(:series)).must_equal [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, "26"]
      _(calendar[:month].previous).must_equal 25
      _(calendar[:month].next).must_be_nil
      _(entries.map(&:time)).must_rematch :entries
    end
    it 'selects :week for the first page' do
      calendar, _pagy, entries = app(params: { week_page: 1 })
                                 .send(:pagy, :calendar,
                                       Event.all,
                                       week:   { first_weekday: :sunday },
                                       offset: { limit: 600 })

      _(calendar[:week].send(:series)).must_equal ["1", 2, 3, 4, 5, :gap, 109]
      _(calendar[:week].last).must_equal 109
      _(calendar[:week].previous).must_be_nil
      _(calendar[:week].next).must_equal 2
      _(entries.map(&:time)).must_rematch :entries
    end
    it 'selects :week for an intermediate page' do
      calendar, _pagy, entries = app(params: { week_page: 25 })
                                 .send(:pagy, :calendar,
                                       Event.all,
                                       week:   { first_weekday: :sunday },
                                       offset: { limit: 600 })

      _(calendar[:week].send(:series)).must_equal [1, :gap, 24, "25", 26, :gap, 109]
      _(calendar[:week].previous).must_equal 24
      _(calendar[:week].next).must_equal 26
      _(entries.map(&:time)).must_rematch :entries
    end
    it 'selects :week for the last page' do
      calendar, _pagy, entries = app(params: { week_page: 109 })
                                 .send(:pagy, :calendar,
                                       Event.all,
                                       week:   { first_weekday: :sunday },
                                       offset: { limit: 600 })

      _(calendar[:week].send(:series)).must_equal [1, :gap, 105, 106, 107, 108, "109"]
      _(calendar[:week].previous).must_equal 108
      _(calendar[:week].next).must_be_nil
      _(entries.map(&:time)).must_rematch :entries
    end
    it 'selects :day for the first page' do
      calendar, _pagy, entries = app(params: { day_page: 1 })
                                 .send(:pagy, :calendar,
                                       Event40.all,
                                       day:    {},
                                       offset: { limit: 600 })

      _(calendar[:day].send(:series)).must_equal ["1", 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31]

      _(calendar[:day].last).must_equal 60
      _(calendar[:day].previous).must_be_nil
      _(calendar[:day].next).must_equal 2
      _(entries.map(&:time)).must_rematch :entries
    end
    it 'selects :day for an intermediate page' do
      calendar, _pagy, entries = app(params: { day_page: 25 })
                                 .send(:pagy, :calendar,
                                       Event40.all,
                                       day:    {},
                                       offset: { limit: 600 })

      _(calendar[:day].send(:series)).must_equal([10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, "25", 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40])

      _(calendar[:day].previous).must_equal 24
      _(calendar[:day].next).must_equal 26
      _(entries.map(&:time)).must_rematch :entries
    end
    it 'selects :day for the last page' do
      calendar, _pagy, entries = app(params: { day_page: 60 })
                                 .send(:pagy, :calendar,
                                       Event40.all,
                                       day:    {},
                                       offset: { limit: 600 })

      _(calendar[:day].send(:series)).must_equal [30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, "60"]
      _(calendar[:day].previous).must_equal 59
      _(calendar[:day].next).must_be_nil
      _(entries.map(&:time)).must_rematch :entries
    end
    it 'runs multiple units' do
      calendar, pagy, entries = app(params: { year_page: 2, month_page: 7, page: 2 })
                                .send(:pagy, :calendar,
                                      Event.all,
                                      year:   {},
                                      month:  {},
                                      offset: { limit: 10 })

      _(calendar[:year].send(:series)).must_equal [1, "2", 3]
      _(calendar[:month].send(:series)).must_equal [1, 2, 3, 4, 5, 6, "7", 8, 9, 10, 11, 12]
      _(pagy.send(:series)).must_equal [1, "2", 3]
      _(entries.map(&:time)).must_rematch :entries
    end
  end

  describe 'calendar_url_at' do
    it 'returns the url' do
      calendar, _pagy, _entries = app(params: { year_page: 2, month_page: 7, page: 2 })
                                  .send(:pagy, :calendar,
                                        Event.all,
                                        year:   {},
                                        month:  {},
                                        offset: { limit: 10 })

      _(calendar.url_at(Time.zone.local(2021, 12, 21)))
        .must_equal "/foo?year_page=1&month_page=3&page=1"

      _(calendar.url_at(Time.zone.local(2022, 2, 10)))
        .must_equal "/foo?year_page=2&month_page=2&page=1"

      _(calendar.url_at(Time.zone.local(2023, 11, 10)))
        .must_equal "/foo?year_page=3&month_page=11&page=1"

      _(calendar.url_at(Time.zone.local(2100), fit_time: true))
        .must_equal "/foo?year_page=3&month_page=11&page=1"

      _(calendar.url_at(Time.zone.local(2000), fit_time: true))
        .must_equal "/foo?year_page=1&month_page=1&page=1"

      _ { calendar.url_at(Time.zone.local(2100)) }
        .must_raise Pagy::RangeError

      _ { calendar.url_at(Time.zone.local(2000)) }
        .must_raise Pagy::RangeError
    end
  end
  describe "#showtime" do
    it "returns the showtime" do
      calendar, _pagy, _entries = app(params: { year_page: 2, month_page: 7, page: 2 })
                                  .send(:pagy, :calendar, Event.all,
                                        year:   {},
                                        month:  {},
                                        offset: { limit: 10 })

      _(calendar.showtime).must_equal Time.zone.local(2022, 7, 1)
    end
  end
  describe 'a_lambda with counts' do
    it 'includes title and class in page anchor' do
      app_counts                = MockApp::CalendarCounts.new
      calendar, _pagy, _entries = app_counts.send(:pagy, :calendar,
                                                  Event.all,
                                                  year:   {},
                                                  month:  {},
                                                  day:    {},
                                                  offset: { limit: 10 })

      _(calendar[:day].send(:a_lambda).call(2, classes: 'a b c')).must_equal \
        "<a href=\"/foo?day_page=2\" title=\"No items found\" class=\"a b c empty-page\" rel=\"next\">22</a>"
    end
  end
  describe "Counts feature" do
    [MockApp::CalendarCounts, MockApp::CalendarCountsSkip].each do |c|
      it "works with #{c}" do
        app_counts                = c.new(params: { year_page:  2,
                                                    month_page: 7,
                                                    day_page:   4,
                                                    page:       1 })
        calendar, _pagy, _entries = app_counts.send(:pagy, :calendar,
                                                    Event.all,
                                                    year:   {},
                                                    month:  {},
                                                    day:    {},
                                                    offset: { limit: 10 })
        _(calendar[:year].series_nav).must_rematch :year
        _(calendar[:month].series_nav).must_rematch :month
        _(calendar[:day].series_nav).must_rematch :day
      end
    end
  end
end
