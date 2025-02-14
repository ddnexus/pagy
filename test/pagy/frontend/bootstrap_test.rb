# frozen_string_literal: true

require_relative '../../test_helper'
require_relative '../../helpers/nav_tests'

MIXIN = 'bootstrap'
PREFIX = 'bootstrap_'

describe MIXIN do
  include NavTests

  describe "#{PREFIX}nav" do
    it 'renders first, intermediate and last pages' do
      nav_tests(PREFIX)
    end
  end

  describe "#pagy#{PREFIX}_nav_js" do
    it 'renders single and multiple pages when used with Pagy::Offset::Countless' do
      nav_js_countless_tests(PREFIX)
    end
    it 'renders first, intermediate and last pages with required steps' do
      nav_js_tests(PREFIX)
    end
  end

  describe "#pagy#{PREFIX}_combo_nav_js" do
    it 'renders first, intermediate and last pages' do
      combo_nav_js_tests(PREFIX)
    end
  end
end
