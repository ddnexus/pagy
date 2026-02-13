# frozen_string_literal: true

require 'unit/test_helper'
require 'pagy/toolbox/helpers/series_nav'

describe 'Pagy#series_nav' do
  let(:pagy_class) do
    Class.new(Pagy) do
      # Mock dependencies
      def series(**)
        [1, '2', :gap]
      end

      def previous_tag(_lambda)
        # MUST return a mutable string because series_nav appends to it
        +'PREV'
      end

      def next_tag(_lambda)
        'NEXT'
      end

      def a_lambda(**)
        ->(page) { "LINK(#{page})" }
      end

      def page_label(page)
        "LABEL(#{page})"
      end

      def wrap_series_nav(html, classes, **)
        %(NAV(#{classes}|#{html}))
      end

      # Mock style delegation target
      def bootstrap_series_nav(**)
        'BOOTSTRAP_NAV'
      end

      public :series_nav
    end
  end

  let(:pagy) { pagy_class.new }

  it 'delegates to specific style if provided' do
    _(pagy.series_nav(:bootstrap)).must_equal 'BOOTSTRAP_NAV'
  end

  it 'renders standard series nav' do
    # Series: [1, '2', :gap]
    # 1 (Integer) -> a_lambda -> LINK(1)
    # '2' (String) -> current page span
    # :gap -> gap span

    html = pagy.series_nav

    # Verify wrapper
    _(html).must_match(/^NAV\(pagy series-nav\|/)

    # Verify content sequence: PREV + Items + NEXT
    content = html[/NAV\(.*\|(.*)\)/, 1]

    _(content).must_match(/^PREV/)
    _(content).must_match(/NEXT$/)

    # Verify items
    _(content).must_include 'LINK(1)'
    _(content).must_include %(<a role="link" aria-disabled="true" aria-current="page">LABEL(2)</a>)
    _(content).must_include %(<a role="separator" aria-disabled="true">#{Pagy::I18n.translate('pagy.gap')}</a>)
  end

  it 'raises InternalError for invalid series items' do
    # Override series to return invalid type
    pagy.define_singleton_method(:series) { [1.5] }

    err = _ { pagy.series_nav }.must_raise Pagy::InternalError
    _(err.message).must_match(/expected item types in series to be Integer, String or :gap; got 1.5/)
  end
end
