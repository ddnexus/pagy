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

    it 'serves page 1 for a malformed unit page param' do
      %w[abc 0 -1].each do |page|
        calendar, = MockApp::Calendar.new(params: { 'year_page' => page }).pagy(:calendar, collection, year: conf)

        _(calendar[:year].page).must_equal 1
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

  # A calendar link starts the new period from the first offset page
  describe 'offset page param in the calendar links' do
    let(:unit_params) { { 'year_page' => '2', 'month_page' => '3' } }
    let(:clean_url)   { '/foo?year_page=2&month_page=5' }

    # Return the month nav link and the url_at for the same month, and the offset pagy
    def links_for(params, **offset)
      calendar, pagy, = MockApp::Calendar.new(params:).pagy(:calendar, collection, year: {}, month: {}, offset:)
      urls            = [calendar[:month].send(:compose_page_url, 5), calendar.url_at(Time.zone.local(2022, 5, 15))]
      [urls.map { CGI.unescape(_1) }, pagy]
    end

    it 'drops it with the page_key set in the Pagy::OPTIONS' do
      Pagy::OPTIONS[:page_key] = 'p'
      urls, pagy = links_for(unit_params.merge('p' => '2'), limit: 2)

      _(pagy.page).must_equal 2
      _(urls).must_equal [clean_url, clean_url]
    ensure
      Pagy::OPTIONS.delete(:page_key)
    end

    it 'drops it with the root_key, keeping the other nested params and the request params' do
      urls, pagy = links_for(unit_params.merge('r' => { 'page' => '2', 'foo' => 'bar' }), root_key: 'r', limit: 2)

      _(pagy.page).must_equal 2
      _(urls).must_equal ["#{clean_url}&r[foo]=bar"] * 2
      _(CGI.unescape(pagy.send(:compose_page_url, 3))).must_equal '/foo?year_page=2&month_page=3&r[page]=3&r[foo]=bar'
    end

    it 'drops the root param left empty' do
      urls, = links_for(unit_params.merge('r' => { 'page' => '2' }), root_key: 'r')

      _(urls).must_equal [clean_url, clean_url]
    end

    it 'handles a missing or non-Hash root param' do
      urls, = links_for(unit_params, root_key: 'r')

      _(urls).must_equal [clean_url, clean_url]

      urls, pagy = links_for(unit_params.merge('r' => '2'), root_key: 'r')

      _(pagy.page).must_equal 1
      _(urls).must_equal ["#{clean_url}&r=2"] * 2
    end

    it 'drops it with jsonapi and a custom page_key' do
      params = { 'year_number' => '2', 'month_number' => '3', 'page' => { 'number' => '2', 'size' => '2' } }
      urls, pagy = links_for(params, jsonapi: true, page_key: 'number', limit_key: 'size', client_limit: 10)

      _(pagy.page).must_equal 2
      _(urls).must_equal ['/foo?year_number=2&month_number=5&page[size]=2'] * 2
    end
  end
end
