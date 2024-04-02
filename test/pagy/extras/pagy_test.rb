# frozen_string_literal: true

require_relative '../../test_helper'
require_relative '../../mock_helpers/app'

EXTRA  = 'pagy'
PREFIX = ''
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

  def self.tests_for(method, page_finalize, **others)
    page_finalize.each do |page, finalize|
      it "renders the #{method} for page #{page}" do
        app = MockApp.new
        pagy = Pagy.new count: 1000, page: page
        pagy_countless = Pagy::Countless.new(page: page).finalize(finalize)
        _(app.send(method, pagy)).must_rematch :r1
        _(app.send(method, pagy_countless)).must_rematch :r2
        _(app.send(method, pagy, **others)).must_rematch :r3
        _(app.send(method, pagy_countless, **others)).must_rematch :r4
      end
    end
  end

  describe '#pagy_prev_url' do
    tests_for(:pagy_prev_url, [[1, 21], [3, 21], [6, 21], [50, 20]], absolute: true)
  end
  describe '#pagy_next_url' do
    tests_for(:pagy_next_url, [[1, 21], [3, 21], [6, 21], [50, 20]], absolute: true)
  end
  describe '#pagy_prev_link' do
    tests_for(:pagy_prev_link, [[1, 21], [3, 21], [6, 21], [50, 20]], absolute: true)
  end
  describe '#pagy_next_link' do
    tests_for(:pagy_next_link, [[1, 21], [3, 21], [6, 21], [50, 20]], absolute: true)
  end
  describe '#pagy_prev_a' do
    tests_for(:pagy_prev_a, [[1, 0], [3, 21], [6, 21], [50, 20]],
              text: 'PREV', aria_label: 'My prev page')
  end
  describe '#pagy_next_a' do
    tests_for(:pagy_next_a, [[1, 0], [3, 21], [6, 21], [50, 20]],
              text: 'NEXT', aria_label: 'My next page')
  end
end
