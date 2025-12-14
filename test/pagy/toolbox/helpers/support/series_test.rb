# frozen_string_literal: true

require 'test_helper'
require 'pagy/toolbox/helpers/support/series'

describe 'Pagy#series' do
  # Mock class to expose series logic
  let(:pagy_class) do
    Class.new(Pagy) do
      attr_accessor :page, :last

      def initialize(page: 1, last: 1, **options)
        @page = page
        @last = last
        assign_options(**options)
      end

      # Expose protected method
      public :series
    end
  end

  describe 'validations' do
    it 'raises OptionError for invalid slots' do
      p = pagy_class.new
      _ { p.series(slots: -1) }.must_raise Pagy::OptionError
      _ { p.series(slots: '5') }.must_raise Pagy::OptionError
    end

    it 'returns empty array for slots 0' do
      p = pagy_class.new(last: 10)
      _(p.series(slots: 0)).must_equal []
    end
  end

  describe 'calculations' do
    # Helper to generate series for a range of pages
    def verify_series(label, last:, **options)
      (1..last).each do |page|
        pagy = pagy_class.new(page: page, last: last)
        # Use a unique key for each page iteration to avoid collisions in Rematch
        _(pagy.series(**options)).must_rematch("#{label}_page_#{page}")
      end
    end

    it 'computes series for last <= slots' do
      # All pages should be shown
      verify_series(:last_le_slots, last: 5, slots: 7)
    end

    it 'computes series for last > slots (default 7)' do
      # Standard gaps logic
      verify_series(:default_gaps, last: 20)
    end

    it 'computes series for even slots (4)' do
      # Even slots affect the "half" calculation
      verify_series(:even_slots, last: 10, slots: 4)
    end

    it 'computes series with compact: true' do
      # No gaps should be generated (just the sliding window)
      verify_series(:compact, last: 20, slots: 5, compact: true)
    end

    it 'computes series for slots < SERIES_SLOTS (4) without compact' do
      # Should behave like compact (no gaps added) because slots (4) < 7
      verify_series(:small_slots_implicit_compact, last: 10, slots: 4)
    end

    it 'handles page missing from series (out of bounds)' do
      # Simulates a state where current page is not in the generated series (e.g. overflow)
      # Slots 5, Last 10, Page 20.
      # Series will generate roughly [6..10], page 20 is not included.
      # This hits the "current is nil" branch.
      pagy = pagy_class.new(page: 20, last: 10)

      series = pagy.series(slots: 5)

      # Ensure no element was converted to string (which signifies the current page)
      _(series.any?(String)).must_equal false
      _(series).wont_include 20
    end
  end
end
