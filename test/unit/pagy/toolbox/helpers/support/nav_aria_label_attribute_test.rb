# frozen_string_literal: true

require 'unit/test_helper'
require 'pagy/toolbox/helpers/support/nav_aria_label_attribute'

describe 'Pagy#nav_aria_label_attribute' do
  let(:pagy_class) do
    Class.new(Pagy) do
      attr_accessor :last

      def initialize(last: 10)
        @last = last
      end

      public :nav_aria_label_attribute
    end
  end

  it 'generates default aria-label using I18n' do
    pagy = pagy_class.new(last: 5)
    # Default I18n for en: "Pages" (plural) or "Page" (singular)
    # Assuming default locale is loaded
    _(pagy.nav_aria_label_attribute).must_equal 'aria-label="Pages"'
  end

  it 'falls back to I18n default when aria_label is explicitly nil' do
    pagy = pagy_class.new(last: 5)
    _(pagy.nav_aria_label_attribute(aria_label: nil)).must_equal 'aria-label="Pages"'
  end

  it 'uses provided aria_label' do
    pagy = pagy_class.new
    _(pagy.nav_aria_label_attribute(aria_label: 'Custom Nav')).must_equal 'aria-label="Custom Nav"'
  end
end
