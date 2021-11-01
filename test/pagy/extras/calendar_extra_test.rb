# frozen_string_literal: true

require_relative '../../test_helper'
require 'pagy/extras/calendar'

require_relative '../../mock_helpers/calendar_collection'
require_relative '../../mock_helpers/app'
require "ostruct"

describe 'pagy/extras/calendar' do
  let(:app) { MockApp::Calendar.new }
  before do
    @collection = MockCalendarCollection.new
  end

  describe '#pagy_calendar' do
    it 'returns a Pagy::Calendar instance' do
      pagy, _records = MockApp::Calendar.new.send(:pagy_calendar, @collection, page: 1, local_minmax: [Time.now, Time.now + 5000])
      _(pagy).must_be_kind_of Pagy::Calendar
    end
    it 'should raise a NoMethodError' do
      _ { MockApp.new.send(:pagy_calendar, @collection, page: 1, local_minmax: [Time.now, Time.now + 5000]) }.must_raise NoMethodError
    end
    it 'selects :year for the pages and check the total' do
      total = 0
      pagy, entries = app.send(:pagy_calendar, @collection, unit: :year, size: [1, 4, 4, 1], page: 1 )
      _(pagy.series).must_equal ["1", 2, 3]
      _(pagy.pages).must_equal 3
      _(pagy.prev).must_be_nil
      _(pagy.next).must_equal 2
      _(entries.to_a).must_rematch
      total += entries.size
      pagy, entries = app.send(:pagy_calendar, @collection, unit: :year, page: 2 )
      _(pagy.series).must_equal [1, "2", 3]
      _(pagy.pages).must_equal 3
      _(pagy.prev).must_equal 1
      _(pagy.next).must_equal 3
      _(entries.to_a).must_rematch
      total += entries.size
      pagy, entries = app.send(:pagy_calendar, @collection, unit: :year, page: 3)
      _(pagy.series).must_equal [1, 2, '3']
      _(pagy.prev).must_equal 2
      _(pagy.next).must_be_nil
      _(entries.to_a).must_rematch
      total += entries.size
      _(total).must_equal @collection.size
    end
    it 'selects :month for the first page' do
      pagy, entries = app.send(:pagy_calendar, @collection, size: [1, 4, 4, 1], page: 1 )
      _(pagy.series).must_equal ["1", 2, 3, 4, 5, :gap, 26]
      _(pagy.pages).must_equal 26
      _(pagy.prev).must_be_nil
      _(pagy.next).must_equal 2
      _(entries.to_a).must_rematch
    end
    it 'selects :month for an intermediate page' do
      pagy, entries = app.send(:pagy_calendar, @collection, page: 25)
      _(pagy.series).must_equal [1, :gap, 21, 22, 23, 24, '25', 26]
      _(pagy.prev).must_equal 24
      _(pagy.next).must_equal 26
      _(entries.to_a).must_rematch
    end
    it 'selects :month for the last page' do
      pagy, entries = app.send(:pagy_calendar, @collection, page: 26)
      _(pagy.series).must_equal [1, :gap, 22, 23, 24, 25, '26']
      _(pagy.prev).must_equal 25
      _(pagy.next).must_be_nil
      _(entries.to_a).must_rematch
    end
    it 'selects :week for the first page' do
      pagy, entries = app.send(:pagy_calendar, @collection, unit: :week, size: [1, 4, 4, 1], page: 1 )
      _(pagy.series).must_equal ["1", 2, 3, 4, 5, :gap, 109]
      _(pagy.pages).must_equal 109
      _(pagy.prev).must_be_nil
      _(pagy.next).must_equal 2
      _(entries.to_a).must_rematch
    end
    it 'selects :week for an intermediate page' do
      pagy, entries = app.send(:pagy_calendar, @collection, unit: :week, page: 25 )
      _(pagy.series).must_equal [1, :gap, 21, 22, 23, 24, "25", 26, 27, 28, 29, :gap, 109]
      _(pagy.prev).must_equal 24
      _(pagy.next).must_equal 26
      _(entries.to_a).must_rematch
    end
    it 'selects :week for the last page' do
      pagy, entries = app.send(:pagy_calendar, @collection, unit: :week, page: 109)
      _(pagy.series).must_equal [1, :gap, 105, 106, 107, 108, "109"]
      _(pagy.prev).must_equal 108
      _(pagy.next).must_be_nil
      _(entries.to_a).must_rematch
    end
    it 'selects :day for the first page' do
      collection = MockCalendarCollection.new(@collection[0,40])
      pagy, entries = app.send(:pagy_calendar, collection, unit: :day, size: [1, 4, 4, 1], page: 1 )
      _(pagy.series).must_equal ["1", 2, 3, 4, 5, :gap, 60]
      _(pagy.pages).must_equal 60
      _(pagy.prev).must_be_nil
      _(pagy.next).must_equal 2
      _(entries.to_a).must_rematch
    end
    it 'selects :day for an intermediate page' do
      collection = MockCalendarCollection.new(@collection[0,40])
      pagy, entries = app.send(:pagy_calendar, collection, unit: :day, page: 25 )
      _(pagy.series).must_equal [1, :gap, 21, 22, 23, 24, "25", 26, 27, 28, 29, :gap, 60]
      _(pagy.prev).must_equal 24
      _(pagy.next).must_equal 26
      _(entries.to_a).must_rematch
    end
    it 'selects :day for the last page' do
      collection = MockCalendarCollection.new(@collection[0,40])
      pagy, entries = app.send(:pagy_calendar, collection, unit: :day, page: 60)
      _(pagy.series).must_equal [1, :gap, 56, 57, 58, 59, "60"]
      _(pagy.prev).must_equal 59
      _(pagy.next).must_be_nil
      _(entries.to_a).must_rematch
    end
  end

  describe '#pagy_labeler' do
    it 'labels the :year nav' do
      pagy, _entries = app.send(:pagy_calendar, @collection, unit: :year, size: [1, 4, 4, 1], page: 1 )
      _(app.pagy_nav(pagy)).must_rematch
    end
    it 'labels the :month nav' do
      pagy, _entries = app.send(:pagy_calendar, @collection, unit: :month, size: [1, 4, 4, 1], page: 1 )
      _(app.pagy_nav(pagy)).must_rematch
    end
    it 'labels the :week nav' do
      pagy, _entries = app.send(:pagy_calendar, @collection, unit: :week, size: [1, 4, 4, 1], page: 1 )
      _(app.pagy_nav(pagy)).must_rematch
    end
    it 'labels the :day nav' do
      pagy, _entries = app.send(:pagy_calendar, @collection, unit: :day, size: [1, 4, 4, 1], page: 1 )
      _(app.pagy_nav(pagy)).must_rematch
    end
    it 'return nothing for unknown unit' do
      pagy, _entries = app.send(:pagy_calendar, @collection)
      pagy.instance_variable_set('@unit', :unknown)
      _ { app.pagy_labeler(pagy, 2) }.must_raise Pagy::InternalError
    end
    it 'wont interfere with other classes' do
      pagy = Pagy.new(count: 1000)
      _(app.pagy_nav(pagy)).must_rematch
    end
  end
end
