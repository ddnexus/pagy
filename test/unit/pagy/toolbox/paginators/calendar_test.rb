# frozen_string_literal: true

require 'unit/test_helper'
require 'pagy/toolbox/paginators/calendar'
require 'mocks/app'

describe 'Pagy::CalendarPaginator' do
  let(:collection) { Event.all }
  # Period covering the seeded events (2021-10-21 to 2023-11-13)
  let(:period) { [Time.zone.local(2021, 10, 21), Time.zone.local(2023, 11, 13)] }
  let(:conf) { { period: period } }

  describe '#paginate' do
    it 'validates options' do
      app = MockApp::Calendar.new
      # Pass invalid key :foo
      _ { app.pagy(:calendar, collection, year: conf, foo: 'bar') }.must_raise ArgumentError
    end

    it 'paginates with defaults (MockApp::Calendar)' do
      # Request page 2 of year via params at initialization
      app = MockApp::Calendar.new(params: { 'year_page' => '2' })

      calendar, pagy, records = app.pagy(:calendar, collection, year: conf)

      _(calendar).must_be_kind_of Pagy::Calendar
      _(calendar[:year]).must_be_kind_of Pagy::Calendar::Year
      _(calendar[:year].page).must_equal 2

      _(pagy).must_be_kind_of Pagy::Offset
      _(records).must_be_kind_of ActiveRecord::Relation

      # Verify filtering: Page 2 of year (2022) should result in records only from 2022
      # Seeds have events in 2022.
      records.each do |r|
        _(r.time.year).must_equal 2022
      end
    end

    it 'handles disabled: true' do
      # Default MockApp params: page 3
      app = MockApp::Calendar.new

      # When disabled, calendar is skipped (nil), filtering is skipped
      calendar, pagy, records = app.pagy(:calendar, collection, year: conf, disabled: true)

      _(calendar).must_be_nil
      _(pagy).must_be_kind_of Pagy::Offset

      # No filtering applied on collection, so it should be the full set (paginated by offset)
      # Offset default page 3 (from MockApp), limit 20
      # Event has 504 records. Page 3 has 20 records.
      _(records.count).must_equal 20
    end

    it 'handles pagy_calendar_counts callback' do
      # MockApp::CalendarCounts implements pagy_calendar_counts
      app = MockApp::CalendarCounts.new

      calendar, _pagy, _records = app.pagy(:calendar, collection, year: conf)

      # Check if counts were calculated and assigned
      counts = calendar[:year].instance_variable_get(:@options)[:counts]

      _(counts).wont_be_nil
      _(counts).must_be_kind_of Array
      _(counts.size).must_equal 3 # 2021, 2022, 2023

      # Sum of counts must equal total events in the period (504)
      _(counts.sum).must_equal 504
    end

    it 'handles missing pagy_calendar_counts' do
      # MockApp::Calendar does NOT implement pagy_calendar_counts
      app = MockApp::Calendar.new

      calendar, _pagy, _records = app.pagy(:calendar, collection, year: conf)

      counts = calendar[:year].instance_variable_get(:@options)[:counts]
      _(counts).must_be_nil
    end
  end
end
