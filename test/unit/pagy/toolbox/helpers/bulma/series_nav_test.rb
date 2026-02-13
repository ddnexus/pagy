# frozen_string_literal: true

require 'unit/test_helper'
require 'pagy/toolbox/helpers/bulma/series_nav'

describe 'Pagy#bulma_series_nav' do
  let(:pagy_class) do
    Class.new(Pagy) do
      # Mock dependencies
      def series(**)
        [1, '2', :gap]
      end

      def a_lambda(**)
        ->(page, text = nil, classes: nil, **_opts) { "LINK(#{page},#{text},#{classes})" }
      end

      def bulma_html_for(which, _lambda)
        which == :previous ? 'PREV' : 'NEXT'
      end

      def page_label(page)
        "LABEL(#{page})"
      end

      def wrap_series_nav(html, classes, **)
        %(WRAP(#{classes}|#{html}))
      end

      public :bulma_series_nav
    end
  end

  let(:pagy) { pagy_class.new }

  it 'renders bulma series nav' do
    html = pagy.bulma_series_nav

    # Verify wrapper class
    _(html).must_match(/^WRAP\(pagy-bulma series-nav pagination\|/)

    content = html[/WRAP\(.*\|(.*)\)/, 1]

    # Verify structure: <ul class="pagination-list"> PREV ... items ... NEXT </ul>
    _(content).must_match(/^<ul class="pagination-list">PREV/)
    _(content).must_match(%r{NEXT</ul>$})

    # Verify items
    # 1 (Integer) -> LINK(1, LABEL(1), pagination-link)
    _(content).must_include '<li>LINK(1,LABEL(1),pagination-link)</li>'

    # '2' (String) -> current page
    _(content).must_include '<li><a role="link" class="pagination-link is-current" aria-current="page" aria-disabled="true">LABEL(2)</a></li>'

    # :gap -> ellipsis
    # Note: Pagy::I18n.translate('pagy.gap') is "&hellip;" by default
    _(content).must_include %(<li><span class="pagination-ellipsis">#{Pagy::I18n.translate('pagy.gap')}</span></li>)
  end

  it 'accepts extra classes' do
    html = pagy.bulma_series_nav(classes: 'is-centered')
    _(html).must_match(/^WRAP\(pagy-bulma series-nav is-centered\|/)
  end

  it 'raises InternalError for invalid series items' do
    pagy.define_singleton_method(:series) { [1.5] }

    err = _ { pagy.bulma_series_nav }.must_raise Pagy::InternalError
    _(err.message).must_match(/expected item types in series to be Integer, String or :gap; got 1.5/)
  end
end
