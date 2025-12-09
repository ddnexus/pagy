# frozen_string_literal: true

require 'test_helper'
require 'pagy/toolbox/helpers/bootstrap/series_nav'

describe 'Pagy#bootstrap_series_nav' do
  let(:pagy_class) do
    Class.new(Pagy) do
      # Mock dependencies
      def series(**)
        [1, '2', :gap]
      end

      def a_lambda(**)
        ->(page, classes: nil, **_opts) { "LINK(#{page},#{classes})" }
      end

      def bootstrap_html_for(which, _lambda)
        which == :previous ? 'PREV' : 'NEXT'
      end

      def page_label(page)
        "LABEL(#{page})"
      end

      def wrap_series_nav(html, classes, **)
        %(WRAP(#{classes}|#{html}))
      end

      public :bootstrap_series_nav
    end
  end

  let(:pagy) { pagy_class.new }

  it 'renders bootstrap series nav' do
    html = pagy.bootstrap_series_nav

    # Verify wrapper class
    _(html).must_match(/^WRAP\(pagy-bootstrap series-nav\|/)

    content = html[/WRAP\(.*\|(.*)\)/, 1]

    # Verify structure: <ul class="pagination"> PREV ... items ... NEXT </ul>
    _(content).must_match(/^<ul class="pagination">PREV/)
    _(content).must_match(%r{NEXT</ul>$})

    # Verify items
    # 1 (Integer) -> <li class="page-item">LINK(1,page-link)</li>
    _(content).must_include '<li class="page-item">LINK(1,page-link)</li>'

    # '2' (String) -> active page
    # <li class="page-item active"><a role="link" class="page-link" aria-current="page" aria-disabled="true">LABEL(2)</a></li>
    _(content).must_include '<li class="page-item active"><a role="link" class="page-link" aria-current="page" aria-disabled="true">LABEL(2)</a></li>'

    # :gap -> disabled gap
    # <li class="page-item gap disabled"><a role="link" class="page-link" aria-disabled="true">...</a></li>
    _(content).must_include %(<li class="page-item gap disabled"><a role="link" class="page-link" aria-disabled="true">#{Pagy::I18n.translate('pagy.gap')}</a></li>)
  end

  it 'accepts extra classes' do
    html = pagy.bootstrap_series_nav(classes: 'justify-content-center')
    content = html[/WRAP\(.*\|(.*)\)/, 1]
    _(content).must_match(/^<ul class="justify-content-center">/)
  end

  it 'raises InternalError for invalid series items' do
    pagy.define_singleton_method(:series) { [1.5] }

    err = _ { pagy.bootstrap_series_nav }.must_raise Pagy::InternalError
    _(err.message).must_match(/expected item types in series to be Integer, String or :gap; got 1.5/)
  end
end
