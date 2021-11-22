# frozen_string_literal: true

require_relative '../../test_helper'
require 'pagy/extras/calendar'

require_relative '../../mock_helpers/collection'
require_relative '../../mock_helpers/app'
require "ostruct"

def app(**opts)
  MockApp::Calendar.new(**opts)
end

describe 'pagy/extras/calendar' do
  before do
    @collection = MockCollection::Calendar.new
  end

  describe 'instance methods' do
    it 'returns a Pagy::Calendar::Month instance' do
      calendar, pagy, _records = app(params: { page: 1 }).send(:pagy_calendar, @collection,
                                                               month: { period: [Time.now, Time.now + 5000] },
                                                               pagy: {})
      _(calendar[:month]).must_be_instance_of Pagy::Calendar::Month
      _(pagy).must_be_instance_of Pagy
    end
    it 'skips the calendar' do
      calendar, pagy, records = app(params: { page: 1 }).send(:pagy_calendar, @collection,
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
      _(error.message).must_rematch
    end
    it 'raises NoMethodError for #pagy_calendar_filter' do
      error = assert_raises(NoMethodError) { MockApp.new.send(:pagy_calendar_filter) }
      _(error.message).must_rematch
    end
    it 'raises ArgumentError for wrong conf' do
      _ { MockApp::Calendar.new.send(:pagy_calendar, @collection, []) }.must_raise ArgumentError
      _ { MockApp::Calendar.new.send(:pagy_calendar, @collection, unknown: {}) }.must_raise ArgumentError
      _ { MockApp::Calendar.new.send(:pagy_calendar, @collection, year: []) }.must_raise ArgumentError
    end
    it 'selects :year for the pages and check the total' do
      total = 0
      calendar, _pagy, entries = app(params: { year_page: 1 }).send(:pagy_calendar, @collection,
                                                                    year: { size: [1, 4, 4, 1] },
                                                                    pagy: { items: 600 })
      _(calendar[:year].series).must_equal ["1", 2, 3]
      _(calendar[:year].pages).must_equal 3
      _(calendar[:year].prev).must_be_nil
      _(calendar[:year].next).must_equal 2
      _(entries.to_a).must_rematch
      total += entries.size
      calendar, _pagy, entries = app(params: { year_page: 2 }).send(:pagy_calendar, @collection,
                                                                    year: {},
                                                                    pagy: { items: 600 })
      _(calendar[:year].series).must_equal [1, "2", 3]
      _(calendar[:year].pages).must_equal 3
      _(calendar[:year].prev).must_equal 1
      _(calendar[:year].next).must_equal 3
      _(entries.to_a).must_rematch
      total += entries.size
      calendar, _pagy, entries = app(params: { year_page: 3 }).send(:pagy_calendar, @collection,
                                                                    year: {},
                                                                    pagy: { items: 600 })
      _(calendar[:year].series).must_equal [1, 2, '3']
      _(calendar[:year].prev).must_equal 2
      _(calendar[:year].next).must_be_nil
      _(entries.to_a).must_rematch
      total += entries.size
      _(total).must_equal @collection.size
    end
    it 'selects :month for the first page' do
      calendar, _pagy, entries = app(params: { month_page: 1 }).send(:pagy_calendar, @collection,
                                                                     month: { size: [1, 4, 4, 1] },
                                                                     pagy: { items: 600 })
      _(calendar[:month].series).must_equal ["1", 2, 3, 4, 5, :gap, 26]
      _(calendar[:month].pages).must_equal 26
      _(calendar[:month].prev).must_be_nil
      _(calendar[:month].next).must_equal 2
      _(entries.to_a).must_rematch
    end
    it 'selects :month for an intermediate page' do
      calendar, _pagy, entries = app(params: { month_page: 25 }).send(:pagy_calendar, @collection,
                                                                      month: {},
                                                                      pagy: { items: 600 })
      _(calendar[:month].series).must_equal [1, :gap, 21, 22, 23, 24, '25', 26]
      _(calendar[:month].prev).must_equal 24
      _(calendar[:month].next).must_equal 26
      _(entries.to_a).must_rematch
    end
    it 'selects :month for the last page' do
      calendar, _pagy, entries = app(params: { month_page: 26 }).send(:pagy_calendar, @collection,
                                                                      month: {},
                                                                      pagy: { items: 600 })
      _(calendar[:month].series).must_equal [1, :gap, 22, 23, 24, 25, '26']
      _(calendar[:month].prev).must_equal 25
      _(calendar[:month].next).must_be_nil
      _(entries.to_a).must_rematch
    end
    it 'selects :week for the first page' do
      calendar, _pagy, entries = app(params: { week_page: 1 }).send(:pagy_calendar, @collection,
                                                                    week: {},
                                                                    pagy: { items: 600 })
      _(calendar[:week].series).must_equal ["1", 2, 3, 4, 5, :gap, 109]
      _(calendar[:week].pages).must_equal 109
      _(calendar[:week].prev).must_be_nil
      _(calendar[:week].next).must_equal 2
      _(entries.to_a).must_rematch
    end
    it 'selects :week for an intermediate page' do
      calendar, _pagy, entries = app(params: { week_page: 25 }).send(:pagy_calendar, @collection,
                                                                     week: {},
                                                                     pagy: { items: 600 })
      _(calendar[:week].series).must_equal [1, :gap, 21, 22, 23, 24, "25", 26, 27, 28, 29, :gap, 109]
      _(calendar[:week].prev).must_equal 24
      _(calendar[:week].next).must_equal 26
      _(entries.to_a).must_rematch
    end
    it 'selects :week for the last page' do
      calendar, _pagy, entries = app(params: { week_page: 109 }).send(:pagy_calendar, @collection,
                                                                      week: {},
                                                                      pagy: { items: 600 })
      _(calendar[:week].series).must_equal [1, :gap, 105, 106, 107, 108, "109"]
      _(calendar[:week].prev).must_equal 108
      _(calendar[:week].next).must_be_nil
      _(entries.to_a).must_rematch
    end
    it 'selects :day for the first page' do
      collection = MockCollection::Calendar.new(@collection[0, 40])
      calendar, _pagy, entries = app(params: { day_page: 1 }).send(:pagy_calendar, collection,
                                                                   day: {},
                                                                   pagy: { items: 600 })

      _(calendar[:day].series).must_equal ["1", 2, 3, 4, 5, :gap, 60]
      _(calendar[:day].pages).must_equal 60
      _(calendar[:day].prev).must_be_nil
      _(calendar[:day].next).must_equal 2
      _(entries.to_a).must_rematch
    end
    it 'selects :day for an intermediate page' do
      collection = MockCollection::Calendar.new(@collection[0, 40])
      calendar, _pagy, entries = app(params: { day_page: 25 }).send(:pagy_calendar, collection,
                                                                    day: {},
                                                                    pagy: { items: 600 })
      _(calendar[:day].series).must_equal [1, :gap, 21, 22, 23, 24, "25", 26, 27, 28, 29, :gap, 60]
      _(calendar[:day].prev).must_equal 24
      _(calendar[:day].next).must_equal 26
      _(entries.to_a).must_rematch
    end
    it 'selects :day for the last page' do
      collection = MockCollection::Calendar.new(@collection[0, 40])
      calendar, _pagy, entries = app(params: { day_page: 60 }).send(:pagy_calendar, collection,
                                                                    day: {},
                                                                    pagy: { items: 600 })
      _(calendar[:day].series).must_equal [1, :gap, 56, 57, 58, 59, "60"]
      _(calendar[:day].prev).must_equal 59
      _(calendar[:day].next).must_be_nil
      _(entries.to_a).must_rematch
    end
  end
end
