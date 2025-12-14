# frozen_string_literal: true

require 'test_helper'
require 'pagy/toolbox/helpers/bulma/series_nav_js'

describe 'Pagy#bulma_series_nav_js' do
  let(:pagy_class) do
    Class.new(Pagy) do
      attr_reader :wrap_args

      # Mock dependencies
      def a_lambda(**)
        ->(page, text = nil, classes: nil, **_opts) { "LINK(#{page},#{text},#{classes})" }
      end

      def bulma_html_for(which, _lambda)
        "#{which.upcase}_HTML"
      end

      def wrap_series_nav_js(tokens, classes, **)
        @wrap_args = [tokens, classes]
        "WRAPPED_NAV"
      end

      public :bulma_series_nav_js
    end
  end

  let(:pagy) { pagy_class.new }

  it 'renders bulma series nav js' do
    result = pagy.bulma_series_nav_js

    _(result).must_equal "WRAPPED_NAV"

    tokens, classes = pagy.wrap_args

    # Verify classes
    _(classes).must_equal 'pagy-bulma series-nav-js pagination'

    # Verify tokens content for Bulma structure

    # before: <ul ...> + PREVIOUS
    _(tokens[:before]).must_equal '<ul class="pagination-list">PREVIOUS_HTML'

    # anchor: <li> + LINK + </li>
    # a_lambda called with PAGE_TOKEN, LABEL_TOKEN, classes: 'pagination-link'
    _(tokens[:anchor]).must_equal "<li>LINK(#{Pagy::PAGE_TOKEN},#{Pagy::LABEL_TOKEN},pagination-link)</li>"

    # current: <li><a ... class="pagination-link is-current" ...>LABEL</a></li>
    _(tokens[:current]).must_include 'class="pagination-link is-current"'
    _(tokens[:current]).must_include Pagy::LABEL_TOKEN
    _(tokens[:current]).must_match(%r{^<li><a.*</a></li>$})

    # gap: <li><span class="pagination-ellipsis">...</span></li>
    _(tokens[:gap]).must_include 'class="pagination-ellipsis"'
    _(tokens[:gap]).must_include Pagy::I18n.translate('pagy.gap')
    _(tokens[:gap]).must_match(%r{^<li><span.*</span></li>$})

    # after: NEXT + </ul>
    _(tokens[:after]).must_equal 'NEXT_HTML</ul>'
  end

  it 'accepts extra classes' do
    pagy.bulma_series_nav_js(classes: 'is-centered')
    _, classes = pagy.wrap_args
    _(classes).must_equal 'pagy-bulma series-nav-js is-centered'
  end
end
