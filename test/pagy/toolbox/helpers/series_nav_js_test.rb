# frozen_string_literal: true

require 'test_helper'
require 'pagy/toolbox/helpers/series_nav_js'

describe 'Pagy#series_nav_js' do
  let(:pagy_class) do
    Class.new(Pagy) do
      attr_reader :wrap_args

      # Mock dependencies
      def a_lambda(**)
        ->(page, text = nil, **_opts) { "LINK(#{page},#{text})" }
      end

      def previous_tag(_lambda)
        'PREV'
      end

      def next_tag(_lambda)
        'NEXT'
      end

      def wrap_series_nav_js(tokens, classes, **)
        @wrap_args = [tokens, classes]
        "WRAPPED_NAV"
      end

      # Mock style delegation target
      def bootstrap_series_nav_js(**)
        'BOOTSTRAP_NAV_JS'
      end

      public :series_nav_js
    end
  end

  let(:pagy) { pagy_class.new }

  it 'delegates to specific style if provided' do
    _(pagy.series_nav_js(:bootstrap)).must_equal 'BOOTSTRAP_NAV_JS'
  end

  it 'constructs tokens and calls wrap_series_nav_js' do
    result = pagy.series_nav_js

    _(result).must_equal "WRAPPED_NAV"

    tokens, classes = pagy.wrap_args

    _(classes).must_equal 'pagy series-nav-js'

    # Verify tokens content
    _(tokens[:before]).must_equal 'PREV'
    _(tokens[:after]).must_equal 'NEXT'

    # anchor: a_lambda.(PAGE_TOKEN, LABEL_TOKEN)
    # Mock returns "LINK(page,text)"
    _(tokens[:anchor]).must_equal "LINK(#{Pagy::PAGE_TOKEN},#{Pagy::LABEL_TOKEN})"

    # current: <a>LABEL_TOKEN</a>
    _(tokens[:current]).must_include Pagy::LABEL_TOKEN
    _(tokens[:current]).must_include 'aria-current="page"'

    # gap: <a>I18n gap</a>
    _(tokens[:gap]).must_include Pagy::I18n.translate('pagy.gap')
    _(tokens[:gap]).must_include 'role="separator"'
  end
end
