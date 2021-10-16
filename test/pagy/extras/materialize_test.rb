# frozen_string_literal: true

require_relative '../../test_helper'
require 'pagy/extras/materialize'
require_relative '../../mock_helpers/pagy_buggy'

describe 'pagy/extras/materialize' do
  require_relative '../../mock_helpers/view'
  let(:view) { MockView.new }

  describe '#pagy_materialize_nav' do
    it 'renders first page' do
      pagy = Pagy.new(count: 1000, page: 1)
      _(view.pagy_materialize_nav(pagy)).must_rematch
      _(view.pagy_materialize_nav(pagy, pagy_id: 'test-nav-id', link_extra: 'link-extra')).must_rematch
    end
    it 'renders intermediate page' do
      pagy = Pagy.new(count: 1000, page: 20)
      _(view.pagy_materialize_nav(pagy)).must_rematch
      _(view.pagy_materialize_nav(pagy, pagy_id: 'test-nav-id', link_extra: 'link-extra')).must_rematch
    end
    it 'renders last page' do
      pagy = Pagy.new(count: 1000, page: 50)
      _(view.pagy_materialize_nav(pagy)).must_rematch
      _(view.pagy_materialize_nav(pagy, pagy_id: 'test-nav-id', link_extra: 'link-extra')).must_rematch
    end
    it 'should raise for wrong series' do
      _ { view.pagy_materialize_nav(PagyBuggy.new(count:100)) }.must_raise Pagy::InternalError
    end
  end

  describe '#pagy_materialize_nav_js' do
    it 'renders first page' do
      pagy = Pagy.new(count: 1000, page: 1)
      _(view.pagy_materialize_nav_js(pagy)).must_rematch
      _(view.pagy_materialize_nav_js(pagy, pagy_id: 'test-nav-id', link_extra: 'link-extra',
                                           steps: { 0 => [1, 2, 2, 1], 600 => [1, 3, 3, 1] })).must_rematch
    end
    it 'renders intermediate page' do
      pagy = Pagy.new(count: 1000, page: 20)
      _(view.pagy_materialize_nav_js(pagy)).must_rematch
      _(view.pagy_materialize_nav_js(pagy, pagy_id: 'test-nav-id', link_extra: 'link-extra',
                                           steps: { 0 => [1, 2, 2, 1], 600 => [1, 3, 3, 1] })).must_rematch
    end
    it 'renders last page' do
      pagy = Pagy.new(count: 1000, page: 50)
      _(view.pagy_materialize_nav_js(pagy)).must_rematch
      _(view.pagy_materialize_nav_js(pagy, pagy_id: 'test-nav-id', link_extra: 'link-extra',
                                           steps: { 0 => [1, 2, 2, 1], 600 => [1, 3, 3, 1] })).must_rematch
    end
    it 'renders with :steps' do
      pagy = Pagy.new(count: 1000, page: 20, steps: { 0 => [1, 2, 2, 1], 500 => [2, 3, 3, 2] })
      _(view.pagy_materialize_nav_js(pagy)).must_rematch
      _(view.pagy_materialize_nav_js(pagy, pagy_id: 'test-nav-id', link_extra: 'link-extra',
                                           steps: { 0 => [1, 2, 2, 1], 600 => [1, 3, 3, 1] })).must_rematch
    end
  end

  describe '#pagy_materialize_combo_nav_js' do
    it 'renders first page' do
      pagy = Pagy.new(count: 103, page: 1)
      _(view.pagy_materialize_combo_nav_js(pagy)).must_rematch
      _(view.pagy_materialize_combo_nav_js(pagy, pagy_id: 'test-nav-id', link_extra: 'link-extra')).must_rematch
    end
    it 'renders intermediate page' do
      pagy = Pagy.new(count: 103, page: 3)
      _(view.pagy_materialize_combo_nav_js(pagy)).must_rematch
      _(view.pagy_materialize_combo_nav_js(pagy, pagy_id: 'test-nav-id', link_extra: 'link-extra')).must_rematch
    end
    it 'renders last page' do
      pagy = Pagy.new(count: 103, page: 6)
      _(view.pagy_materialize_combo_nav_js(pagy)).must_rematch
      _(view.pagy_materialize_combo_nav_js(pagy, pagy_id: 'test-nav-id', link_extra: 'link-extra')).must_rematch
    end
  end
end
