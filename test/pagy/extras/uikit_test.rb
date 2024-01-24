# frozen_string_literal: true

require_relative '../../test_helper'

STYLE = 'uikit'
require "pagy/extras/#{STYLE}"

describe "pagy/extras/#{STYLE}" do
  include NavTests

  describe "#pagy_#{STYLE}_nav" do
    it 'renders first, intermediate and last pages' do
      nav_tests(STYLE)
    end
  end

  describe "#pagy_#{STYLE}_nav_js" do
    it 'renders single and multiple pages when used with Pagy::Countless' do
      nav_js_countless_tests(STYLE)
    end
    it 'renders first, intermediate and last pages with required steps' do
      nav_js_tests(STYLE)
    end
  end

  describe "#pagy_combo_#{STYLE}_nav_js" do
    it 'renders first, intermediate and last pages' do
      combo_nav_js_tests(STYLE)
    end
  end
end
