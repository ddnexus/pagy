# frozen_string_literal: true

require_relative '../../../test_helper'
require_relative '../../../helpers/nav_tests'
require_relative '../../../mock_helpers/app'

STYLE = nil

describe 'Pagy nav test' do
  include NavTests

  describe "nav" do
    it 'renders first, intermediate and last pages' do
      nav_tests(STYLE)
    end
  end

  describe "nav_js" do
    it 'renders single and multiple pages when used with Pagy::Offset::Countless' do
      nav_js_countless_tests(STYLE)
    end
    it 'renders first, intermediate and last pages with required steps' do
      nav_js_tests(STYLE)
    end
  end

  describe "combo_nav_js" do
    it 'renders first, intermediate and last pages' do
      combo_nav_js_tests(STYLE)
    end
  end

  def self.tests_for(method, page_finalize, **others)
    page_finalize.each do |page, finalize|
      it "renders the #{method} for page #{page}" do
        request        = Pagy::Request.new(MockApp.new.request)
        pagy           = Pagy::Offset.new(count: 1000, page: page, request:)
        pagy_countless = Pagy::Offset::Countless.new(page: page, last: page, request:).send(:finalize, finalize)
        _(pagy.send(method)).must_rematch :r1
        _(pagy_countless.send(method)).must_rematch :r2
        _(pagy.send(method, **others)).must_rematch :r3
        _(pagy_countless.send(method, **others)).must_rematch :r4
      end
    end
  end
  describe 'previous_a_tag' do
    tests_for(:previous_a_tag, [[1, 0], [3, 21], [6, 21], [50, 20]],
              text: 'PREV', aria_label: 'My previous page')
  end
  describe 'next_a_tag' do
    tests_for(:next_a_tag, [[1, 0], [3, 21], [6, 21], [50, 20]],
              text: 'NEXT', aria_label: 'My next page')
  end
end
