# frozen_string_literal: true

require 'unit/test_helper'
require 'pagy/toolbox/helpers/bootstrap/input_nav_js'

describe 'Pagy#bootstrap_input_nav_js' do
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

      def bootstrap_html_for(which, _lambda)
        "#{which.upcase}_HTML"
      end

      def wrap_input_nav_js(html, classes, **)
        %(WRAP(#{classes}|#{html}))
      end

      public :bootstrap_input_nav_js
    end
  end

  let(:pagy) { pagy_class.new(page: 5, last: 50) }

  it 'renders bootstrap input nav' do
    html = pagy.bootstrap_input_nav_js

    # Verify wrapper class
    _(html).must_match(/^WRAP\(pagy-bootstrap input-nav-js\|/)

    content = html[/WRAP\(.*\|(.*)\)/, 1]

    # Verify structure: <ul class="pagination"> PREV <li class="page-item"><label class="page-link"> ... </label></li> NEXT </ul>
    _(content).must_match(/^<ul class="pagination">PREVIOUS_HTML<li class="page-item"><label class="page-link">/)
    _(content).must_match(%r{</label></li>NEXT_HTML</ul>$})

    # Verify Input tag specific styles for Bootstrap
    # Width calculation: 5 is 1 char -> 1 + 1 = 2rem
    # Class: page-link active
    expected_style = 'style="text-align: center; width: 2rem; padding: 0; border-radius: .25rem; border: none; display: inline-block;"'
    _(content).must_include expected_style
    _(content).must_match(/<input name="page" type="number" min="1" max="50" value="5" aria-current="page"/)
    _(content).must_include 'class="page-link active"'

    # Verify translation (assuming default English)
    _(content).must_match(/Page <input.*> of 50/)
  end

  it 'accepts extra classes' do
    html = pagy.bootstrap_input_nav_js(classes: 'justify-content-center')

    content = html[/WRAP\(.*\|(.*)\)/, 1]
    _(content).must_match(/^<ul class="justify-content-center">/)
  end
end
