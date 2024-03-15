# frozen_string_literal: true

require_relative '../../test_helper'

EXTRA  = 'bootstrap'
PREFIX = '_bootstrap'
require "pagy/extras/#{EXTRA}"

describe "pagy/extras/#{EXTRA}" do
  include NavTests

  describe "#pagy#{PREFIX}_nav" do
    it 'renders first, intermediate and last pages' do
      nav_tests(PREFIX)
    end
  end

  describe "#pagy#{PREFIX}_nav_js" do
    it 'renders single and multiple pages when used with Pagy::Countless' do
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
