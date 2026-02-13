# frozen_string_literal: true

require 'unit/test_helper'
require 'pagy/toolbox/helpers/bootstrap/series_nav_js'

describe 'Pagy#bootstrap_series_nav_js' do
  let(:pagy_class) do
    Class.new(Pagy) do
      attr_reader :wrap_args

      # Mock dependencies
      def a_lambda(**)
        ->(page, text = nil, classes: nil, **_opts) { "LINK(#{page},#{text},#{classes})" }
      end

      def bootstrap_html_for(which, _lambda)
        "#{which.upcase}_HTML"
      end

      def wrap_series_nav_js(tokens, classes, **)
        @wrap_args = [tokens, classes]
        "WRAPPED_NAV"
      end

      public :bootstrap_series_nav_js
    end
  end

  let(:pagy) { pagy_class.new }

  it 'renders bootstrap series nav js' do
    result = pagy.bootstrap_series_nav_js

    _(result).must_equal "WRAPPED_NAV"

    tokens, classes = pagy.wrap_args

    # Verify wrapper classes (note: pagination class is inside tokens[:before] for this helper)
    _(classes).must_equal 'pagy-bootstrap series-nav-js'

    # Verify tokens content for Bootstrap structure

    # before: <ul ...> + PREVIOUS
    _(tokens[:before]).must_equal '<ul class="pagination">PREVIOUS_HTML'

    # anchor: <li class="page-item">LINK...</li>
    # a_lambda called with PAGE_TOKEN, LABEL_TOKEN, classes: 'page-link'
    _(tokens[:anchor]).must_equal "<li class=\"page-item\">LINK(#{Pagy::PAGE_TOKEN},#{Pagy::LABEL_TOKEN},page-link)</li>"

    # current: <li class="page-item active"><a ... class="page-link" ...>LABEL</a></li>
    _(tokens[:current]).must_include 'class="page-item active"'
    _(tokens[:current]).must_include 'class="page-link"'
    _(tokens[:current]).must_include Pagy::LABEL_TOKEN
    _(tokens[:current]).must_match(%r{^<li.*><a.*</a></li>$})

    # gap: <li class="page-item gap disabled"><a ... class="page-link" ...>...</a></li>
    _(tokens[:gap]).must_include 'class="page-item gap disabled"'
    _(tokens[:gap]).must_include 'class="page-link"'
    _(tokens[:gap]).must_include Pagy::I18n.translate('pagy.gap')

    # after: NEXT + </ul>
    _(tokens[:after]).must_equal 'NEXT_HTML</ul>'
  end

  it 'accepts extra classes' do
    pagy.bootstrap_series_nav_js(classes: 'justify-content-center')
    tokens, = pagy.wrap_args

    # Extra classes go into the UL in the 'before' token
    _(tokens[:before]).must_match(/^<ul class="justify-content-center">/)
  end
end
