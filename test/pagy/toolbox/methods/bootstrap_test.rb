# frozen_string_literal: true

require_relative '../../../test_helper'
require_relative '../../../helpers/nav_tests'

STYLE = :bootstrap

describe STYLE do
  include NavTests

  describe "#{STYLE} nav" do
    it 'renders first, intermediate and last pages' do
      series_nav_tests(STYLE)
    end
  end

  describe "#{STYLE} nav_js" do
    it 'renders single and multiple pages when used with Pagy::Offset::Countless' do
      series_nav_js_countless_tests(STYLE)
    end
    it 'renders first, intermediate and last pages with required steps' do
      series_nav_js_tests(STYLE)
    end
  end

  describe "#{STYLE} input_nav_js" do
    it 'renders first, intermediate and last pages' do
      input_nav_js_tests(STYLE)
    end
  end
end
