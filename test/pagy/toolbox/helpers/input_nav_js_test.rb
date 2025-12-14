# frozen_string_literal: true

require 'test_helper'
require 'pagy/toolbox/helpers/input_nav_js'

describe 'Pagy#input_nav_js' do
  let(:pagy_class) do
    Class.new(Pagy) do
      attr_accessor :page, :last

      def initialize(page: 1, last: 10)
        @page = page
        @last = last
      end

      # Mock dependencies
      def a_lambda(**)
        ->(page) { "LINK(#{page})" }
      end

      def previous_tag(_lambda)
        'PREV'
      end

      def next_tag(_lambda)
        'NEXT'
      end

      def wrap_input_nav_js(html, classes, **)
        %(WRAP(#{classes}|#{html}))
      end

      # Mock style delegation target
      def bootstrap_input_nav_js(**)
        'BOOTSTRAP_INPUT_NAV'
      end

      public :input_nav_js
    end
  end

  let(:pagy) { pagy_class.new(page: 5, last: 50) }

  it 'delegates to specific style if provided' do
    _(pagy.input_nav_js(:bootstrap)).must_equal 'BOOTSTRAP_INPUT_NAV'
  end

  it 'renders input nav' do
    # Expected logic flow:
    # 1. input constructed with min=1, max=50, value=5
    # 2. Width calc: 5.to_s.length (1) + 1 = 2rem
    # 3. I18n interpolation: "Page #{input} of 50" (default en)
    # 4. html structure: PREV + <label> + translated string + </label> + NEXT + wrap

    html = pagy.input_nav_js

    # Verify wrapper structure from mock
    _(html).must_match(/^WRAP\(pagy input-nav-js\|/)

    content = html[/WRAP\(.*\|(.*)\)/, 1]

    # Verify sequence: PREV ... label ... NEXT
    _(content).must_match(/^PREV<label>/)
    _(content).must_match(%r{</label>NEXT$})

    # Verify Input tag details
    # Note: Pagy::A_TAG is appended to the input string.
    # Input is void, so A_TAG technically follows it.
    input_regex = /<input name="page" type="number" min="1" max="50" value="5" aria-current="page" style="text-align: center; width: 2rem; padding: 0;">#{Regexp.escape(Pagy::A_TAG)}/o
    _(content).must_match(input_regex)

    # Verify translation structure (assuming default English "Page ... of ...")
    _(content).must_match(/Page <input.*> of 50/)
  end
end
