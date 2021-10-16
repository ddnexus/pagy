# frozen_string_literal: true

require_relative '../../test_helper'
require 'pagy/extras/navs'

describe 'pagy/extras/navs' do
  require_relative '../../mock_helpers/view'
  let(:view) { MockView.new }

  describe '#pagy_nav_js' do
    it 'renders first page' do
      pagy = Pagy.new(count: 1000, page: 1)
      _(view.pagy_nav_js(pagy)).must_rematch
      _(view.pagy_nav_js(pagy, pagy_id: 'test-nav-id', link_extra: 'link-extra',
                               steps: { 0 => [1, 2, 2, 1], 600 => [1, 3, 3, 1] })).must_rematch
    end
    it 'renders intermediate page' do
      pagy = Pagy.new(count: 1000, page: 20)
      _(view.pagy_nav_js(pagy)).must_rematch
      _(view.pagy_nav_js(pagy, pagy_id: 'test-nav-id', link_extra: 'link-extra',
                               steps: { 0 => [1, 2, 2, 1], 600 => [1, 3, 3, 1] })).must_rematch
    end
    it 'renders last page' do
      pagy = Pagy.new(count: 1000, page: 50)
      _(view.pagy_nav_js(pagy)).must_rematch
      _(view.pagy_nav_js(pagy, pagy_id: 'test-nav-id', link_extra: 'link-extra',
                               steps: { 0 => [1, 2, 2, 1], 600 => [1, 3, 3, 1] })).must_rematch
    end
    it 'renders with :steps' do
      pagy = Pagy.new(count: 1000, page: 20, steps: { 0 => [1, 2, 2, 1], 500 => [2, 3, 3, 2] })
      _(view.pagy_nav_js(pagy)).must_rematch
      _(view.pagy_nav_js(pagy, pagy_id: 'test-nav-id', link_extra: 'link-extra',
                               steps: { 0 => [1, 2, 2, 1], 600 => [1, 3, 3, 1] })).must_rematch
    end
  end

  describe '#pagy_combo_nav_js' do
    it 'renders first page' do
      pagy = Pagy.new(count: 103, page: 1)
      _(view.pagy_combo_nav_js(pagy)).must_rematch
      _(view.pagy_combo_nav_js(pagy, pagy_id: 'test-nav-id', link_extra: 'link-extra')).must_rematch
    end
    it 'renders intermediate page' do
      pagy = Pagy.new(count: 103, page: 3)
      _(view.pagy_combo_nav_js(pagy)).must_rematch
      _(view.pagy_combo_nav_js(pagy, pagy_id: 'test-nav-id', link_extra: 'link-extra')).must_rematch
    end
    it 'renders last page' do
      pagy = Pagy.new(count: 103, page: 6)
      _(view.pagy_combo_nav_js(pagy)).must_rematch
      _(view.pagy_combo_nav_js(pagy, pagy_id: 'test-nav-id', link_extra: 'link-extra')).must_rematch
    end
  end
end
