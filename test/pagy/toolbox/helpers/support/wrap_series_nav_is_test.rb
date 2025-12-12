# frozen_string_literal: true

require 'test_helper'
require 'pagy/toolbox/helpers/support/wrap_series_nav_js'

describe 'Pagy#wrap_series_nav_js' do
  let(:pagy_class) do
    Class.new(Pagy) do
      attr_accessor :options, :update

      def initialize(options = {})
        @options = options
        @update = ['update_info']
      end

      # Mock dependencies
      def series(slots:)
        # Return a simple array based on slots, including :gap if slots > 3
        res = (1..slots).to_a
        res[-2] = :gap if slots > 3
        res
      end

      def calendar?
        @options[:calendar]
      end

      def page_label(page)
        "Label-#{page}"
      end

      def nav_aria_label_attribute(aria_label: nil)
        %(aria-label="#{aria_label || 'default'}")
      end

      def data_pagy_attribute(*args)
        # Return string representation for easy verification
        %(data-pagy="#{args}")
      end

      def keynav?
        @options[:keynav]
      end

      public :sequels, :wrap_series_nav_js
    end
  end

  describe '#sequels' do
    it 'raises OptionError if steps does not contain 0' do
      pagy = pagy_class.new(steps: { 100 => 5 })
      _ { pagy.sequels }.must_raise Pagy::OptionError
    end

    it 'calculates widths and series for default steps' do
      # Default: {0 => 5} (assuming slots: 5 passed or default)
      pagy = pagy_class.new(slots: 5)
      widths, series, labels = pagy.sequels

      _(widths).must_equal [0]
      _(series).must_equal [[1, 2, 3, :gap, 5]]
      _(labels).must_be_nil
    end

    it 'calculates widths and series for multiple steps' do
      # steps: {0 => 3, 100 => 5}
      # sort reverse: [100, 5], [0, 3]
      pagy = pagy_class.new(steps: { 0 => 3, 100 => 5 })
      widths, series, labels = pagy.sequels

      _(widths).must_equal [100, 0]
      _(series).must_equal [[1, 2, 3, :gap, 5], [1, 2, 3]]
      _(labels).must_be_nil
    end

    it 'generates labels if calendar' do
      # Slots 4 -> [1, 2, :gap, 4]
      pagy = pagy_class.new(slots: 4, calendar: true)
      _, _, labels = pagy.sequels

      # Check label generation and :gap preservation
      _(labels).must_equal [['Label-1', 'Label-2', :gap, 'Label-4']]
    end
  end

  describe '#wrap_series_nav_js' do
    it 'renders nav tag with data attribute' do
      pagy = pagy_class.new(slots: 3)
      tokens = { a: 'A', b: 'B' }

      html = pagy.wrap_series_nav_js(tokens, 'nav-class', id: 'my-id', aria_label: 'Label')

      _(html).must_match(/<nav id="my-id" class="nav-class" aria-label="Label"/)

      # Data structure: [:snj, tokens.values, sequels]
      # sequels: [[0], [[1,2,3]], nil]
      # string match depends on inspecting the array structure from data_pagy_attribute mock
      _(html).must_match("\"[:snj, [\"A\", \"B\"], \"P \", [[0], [[1, 2, 3]], nil]]\"")
    end

    it 'adds pagy-rjs class for multiple steps' do
      pagy = pagy_class.new(steps: { 0 => 3, 100 => 5 })
      html = pagy.wrap_series_nav_js({}, 'nav-class')

      _(html).must_match(/class="pagy-rjs nav-class"/)
    end

    it 'includes update info if keynav' do
      pagy = pagy_class.new(slots: 3, keynav: true)
      html = pagy.wrap_series_nav_js({}, 'cls')

      # Data should include @update at the end
      _(html).must_match(/, \["update_info"\]\]/)
    end
  end
end
