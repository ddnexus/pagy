# frozen_string_literal: true

require 'unit/test_helper'
require 'pagy/toolbox/helpers/bulma/input_nav_js'

describe 'Pagy#bulma_input_nav_js' do
  let(:pagy_class) do
    Class.new(Pagy) do
      attr_accessor :page, :last

      def initialize(page: 1, last: 10)
        @page = page
        @last = last
      end

      # Mock dependencies
      def a_lambda(**)
        ->(_page) { "LINK" }
      end

      def bulma_html_for(which, _lambda)
        "#{which.upcase}_LINK"
      end

      def wrap_input_nav_js(html, classes, **)
        %(WRAP(#{classes}|#{html}))
      end

      public :bulma_input_nav_js
    end
  end

  let(:pagy) { pagy_class.new(page: 5, last: 50) }

  it 'renders bulma input nav' do
    html = pagy.bulma_input_nav_js

    # Verify wrapper class
    _(html).must_match(/^WRAP\(pagy-bulma input-nav-js pagination\|/)

    content = html[/WRAP\(.*\|(.*)\)/, 1]

    # Verify structure: <ul> PREVIOUS <li class="pagination-link"><label> ... </label></li> NEXT </ul>
    _(content).must_match(/^<ul class="pagination-list">PREVIOUS_LINK<li class="pagination-link"><label>/)
    _(content).must_match(%r{</label></li>NEXT_LINK</ul>$})

    # Verify Input tag specific styles for Bulma
    # Width calculation: 5 is 1 char -> 1 + 1 = 2rem
    expected_style = 'style="text-align: center; width: 2rem; line-height: 1.2rem; border: none; border-radius: .25rem; padding: .0625rem; color: white; background-color: #485fc7;"'
    _(content).must_include expected_style
    _(content).must_match(/<input name="page" type="number" min="1" max="50" value="5" aria-current="page"/)

    # Verify translation (assuming default English)
    _(content).must_match(/Page <input.*> of 50/)
  end

  it 'accepts extra classes' do
    html = pagy.bulma_input_nav_js(classes: 'my-class')
    _(html).must_match(/^WRAP\(pagy-bulma input-nav-js my-class\|/)
  end
end
