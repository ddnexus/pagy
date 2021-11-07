# frozen_string_literal: true

require_relative '../../test_helper'
require 'pagy/extras/semantic'

require_relative '../../mock_helpers/pagy_buggy'
require_relative '../../mock_helpers/app'

describe 'pagy/extras/semantic' do
  let(:app) { MockApp.new }

  describe '#pagy_semantic_nav' do
    it 'renders first page' do
      pagy = Pagy.new(count: 1000, page: 1)
      _(app.pagy_semantic_nav(pagy)).must_rematch
      _(app.pagy_semantic_nav(pagy, pagy_id: 'test-nav-id', link_extra: 'link-extra')).must_rematch
    end
    it 'renders intermediate page' do
      pagy = Pagy.new(count: 1000, page: 20)
      _(app.pagy_semantic_nav(pagy)).must_rematch
      _(app.pagy_semantic_nav(pagy, pagy_id: 'test-nav-id', link_extra: 'link-extra')).must_rematch
    end
    it 'renders last page' do
      pagy = Pagy.new(count: 1000, page: 50)
      _(app.pagy_semantic_nav(pagy)).must_rematch
      _(app.pagy_semantic_nav(pagy, pagy_id: 'test-nav-id', link_extra: 'link-extra')).must_rematch
    end
    it 'should raise for wrong series' do
      _ { app.pagy_semantic_nav(PagyBuggy.new(count: 100)) }.must_raise Pagy::InternalError
    end
  end

  describe '#pagy_semantic_nav_js' do
    it 'renders first page' do
      pagy = Pagy.new(count: 1000, page: 1)
      _(app.pagy_semantic_nav_js(pagy)).must_rematch
      _(app.pagy_semantic_nav_js(pagy, pagy_id: 'test-nav-id', link_extra: 'link-extra',
                                        steps: { 0 => [1, 2, 2, 1], 600 => [1, 3, 3, 1] })).must_rematch
    end
    it 'renders intermediate page' do
      pagy = Pagy.new(count: 1000, page: 20)
      _(app.pagy_semantic_nav_js(pagy)).must_rematch
      _(app.pagy_semantic_nav_js(pagy, pagy_id: 'test-nav-id', link_extra: 'link-extra',
                                        steps: { 0 => [1, 2, 2, 1], 600 => [1, 3, 3, 1] })).must_rematch
    end
    it 'renders last page' do
      pagy = Pagy.new(count: 1000, page: 50)
      _(app.pagy_semantic_nav_js(pagy)).must_rematch
      _(app.pagy_semantic_nav_js(pagy, pagy_id: 'test-nav-id', link_extra: 'link-extra',
                                        steps: { 0 => [1, 2, 2, 1], 600 => [1, 3, 3, 1] })).must_rematch
    end
    it 'renders with :steps' do
      pagy = Pagy.new(count: 1000, page: 20, steps: { 0 => [1, 2, 2, 1], 500 => [2, 3, 3, 2] })
      _(app.pagy_semantic_nav_js(pagy)).must_rematch
      _(app.pagy_semantic_nav_js(pagy, pagy_id: 'test-nav-id', link_extra: 'link-extra',
                                        steps: { 0 => [1, 2, 2, 1], 600 => [1, 3, 3, 1] })).must_rematch
    end
    it 'raises with missing step 0' do
      pagy = Pagy.new(count: 1000, page: 20, steps: { 0 => [1, 2, 2, 1], 600 => [1, 3, 3, 1] })
      _ { app.pagy_semantic_nav_js(pagy, steps: { 600 => [1, 3, 3, 1] }) }.must_raise Pagy::VariableError
    end
  end

  describe '#pagy_semantic_combo_nav_js' do
    it 'renders first page' do
      pagy = Pagy.new(count: 103, page: 1)
      _(app.pagy_semantic_combo_nav_js(pagy)).must_rematch
      _(app.pagy_semantic_combo_nav_js(pagy, pagy_id: 'test-nav-id', link_extra: 'link-extra')).must_rematch
    end
    it 'renders intermediate page' do
      pagy = Pagy.new(count: 103, page: 3)
      _(app.pagy_semantic_combo_nav_js(pagy)).must_rematch
      _(app.pagy_semantic_combo_nav_js(pagy, pagy_id: 'test-nav-id', link_extra: 'link-extra')).must_rematch
    end
    it 'renders last page' do
      pagy = Pagy.new(count: 103, page: 6)
      _(app.pagy_semantic_combo_nav_js(pagy)).must_rematch
      _(app.pagy_semantic_combo_nav_js(pagy, pagy_id: 'test-nav-id', link_extra: 'link-extra')).must_rematch
    end
  end
end
