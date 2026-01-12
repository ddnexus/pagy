# frozen_string_literal: true

require 'test_helper'
require 'pagy/toolbox/helpers/support/a_lambda'

describe 'Pagy#a_lambda' do
  let(:pagy_class) do
    Class.new(Pagy) do
      attr_accessor :previous, :next

      def initialize(options = {})
        @options  = options
        @previous = nil
        @next     = nil
      end

      # Mock Linkable#compose_page_url
      def compose_page_url(page, **_opts)
        "https://example.com/foo?page=#{page}"
      end

      # Mock Calendar methods
      def calendar?
        @options[:calendar]
      end

      def starting_time_for(page)
        # Mock returning a Time object based on page
        Time.utc(2023, 1, page)
      end

      def localize(time, **opts)
        # Mock localization
        format = opts[:format] || '%Y-%m-%d'
        time.strftime(format)
      end

      public :a_lambda, :page_label
    end
  end

  describe '#page_label' do
    it 'returns page string for standard pagination' do
      p = pagy_class.new
      _(p.page_label(1)).must_equal '1'
      _(p.page_label('5')).must_equal '5'
    end

    it 'returns localized time for calendar pagination' do
      p = pagy_class.new(calendar: true, format: '%B %d')
      # page 1 -> Jan 01
      _(p.page_label(1)).must_equal 'January 01'
      # Override format
      _(p.page_label(2, format: '%Y-%m-%d')).must_equal '2023-01-02'
    end
  end

  describe '#a_lambda' do
    let(:pagy) { pagy_class.new }

    it 'generates a basic link lambda' do
      output = pagy.a_lambda.call(3)
      _(output).must_equal '<a href="https://example.com/foo?page=3">3</a>'
    end

    it 'supports custom text' do
      output = pagy.a_lambda.call(3, 'Three')
      _(output).must_equal '<a href="https://example.com/foo?page=3">Three</a>'
    end

    it 'supports classes' do
      output = pagy.a_lambda.call(3, '3', classes: 'my-class')
      _(output).must_equal '<a href="https://example.com/foo?page=3" class="my-class">3</a>'
    end

    it 'supports aria-label' do
      output = pagy.a_lambda.call(3, '3', aria_label: 'Go to page 3')
      _(output).must_equal '<a href="https://example.com/foo?page=3" aria-label="Go to page 3">3</a>'
    end

    it 'supports anchor_string injection' do
      # anchor_string is passed to the factory method, not the lambda
      output_lambda = pagy.a_lambda(anchor_string: 'data-remote="true"')
      output = output_lambda.call(3)
      _(output).must_equal '<a href="https://example.com/foo?page=3" data-remote="true">3</a>'
    end

    it 'reads anchor_string from @options when not passed directly' do
      pagy_with_anchor = pagy_class.new(anchor_string: 'data-turbo="true" data-foo="bar"')
      output = pagy_with_anchor.a_lambda.call(3)
      _(output).must_equal '<a href="https://example.com/foo?page=3" data-turbo="true" data-foo="bar">3</a>'
    end

    it 'adds rel="prev" if page is @previous' do
      pagy.previous = 2
      output = pagy.a_lambda.call(2)
      _(output).must_match(/rel="prev"/)
    end

    it 'adds rel="next" if page is @next' do
      pagy.next = 4
      output = pagy.a_lambda.call(4)
      _(output).must_match(/rel="next"/)
    end

    describe 'with counts (calendar)' do
      let(:pagy_counts) { pagy_class.new(counts: [10, 0, 5], calendar: true) }

      it 'adds title attribute for item counts' do
        # Page 1 has 10 items (index 0)
        output = pagy_counts.a_lambda.call(1)
        # Check for title interpolation (assuming default en locale)
        # pagy.info_tag.single_page: "Displaying %{count} %{item_name}"
        # item_name: items
        _(output).must_match(/title="Displaying 10 items"/)
      end

      it 'adds empty-page class (appended) and specific title for zero counts' do
        # Page 2 has 0 items (index 1)
        output = pagy_counts.a_lambda.call(2, classes: 'nav-link')

        _(output).must_match(/class="nav-link empty-page"/)
        # pagy.info_tag.no_items: "No %{item_name} found"
        _(output).must_match(/title="No items found"/)
      end

      it 'adds empty-page class (standalone) when no classes provided' do
        # Page 2 has 0 items. No classes passed.
        output = pagy_counts.a_lambda.call(2)

        _(output).must_match(/class="empty-page"/)
      end
    end
  end
end
