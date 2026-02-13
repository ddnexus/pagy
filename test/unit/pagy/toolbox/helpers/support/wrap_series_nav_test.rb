# frozen_string_literal: true

require 'unit/test_helper'
require 'pagy/toolbox/helpers/support/wrap_series_nav'

describe 'Pagy#wrap_series_nav' do
  let(:pagy_class) do
    Class.new(Pagy) do
      attr_accessor :update

      def initialize(keynav: false)
        @keynav = keynav
        @update = ['update_info']
      end

      # Mock dependencies
      def nav_aria_label_attribute(aria_label: nil)
        %(aria-label="#{aria_label || 'default'}")
      end

      def data_pagy_attribute(*args)
        %(data-pagy="#{args.join('-')}")
      end

      def keynav?
        @keynav
      end

      public :wrap_series_nav
    end
  end

  it 'wraps html with standard attributes' do
    pagy = pagy_class.new(keynav: false)
    html = pagy.wrap_series_nav('INNER', 'nav-class', id: 'my-id', aria_label: 'My Label')

    _(html).must_equal '<nav id="my-id" class="nav-class" aria-label="My Label">INNER</nav>'
  end

  it 'handles optional id' do
    pagy = pagy_class.new
    html = pagy.wrap_series_nav('INNER', 'cls')

    _(html).must_match(/<nav class="cls"/)
    _(html).wont_match(/id=/)
  end

  it 'includes data-pagy if keynav' do
    pagy = pagy_class.new(keynav: true)
    html = pagy.wrap_series_nav('INNER', 'cls')

    # data-pagy arg is :k and @update
    # args: [:k, @update] joined by '-'
    _(html).must_match(/data-pagy="k-update_info"/)
  end
end
