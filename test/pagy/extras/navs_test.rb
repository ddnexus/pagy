# frozen_string_literal: true

require_relative '../../test_helper'
require 'pagy/extras/navs'

require_relative '../../mock_helpers/app'

describe 'pagy/extras/navs' do
  let(:app) { MockApp.new }

  describe '#pagy_nav_js' do
    it 'renders first page' do
      pagy = Pagy.new(size: [1, 4, 4, 1], count: 1000, page: 1)
      _(app.pagy_nav_js(pagy)).must_rematch :plain
      _(app.pagy_nav_js(pagy, pagy_id: 'test-nav-id', link_extra: 'link-extra',
                               steps: { 0 => [1, 2, 2, 1], 600 => [1, 3, 3, 1] })).must_rematch :extras
    end
    it 'renders single page when used with Pagy::Countless' do
      require 'pagy/extras/countless'

      pagy, = Pagy::Countless.new(page: 1).finalize(0)
      _(app.pagy_nav_js(pagy)).must_rematch :plain
      _(app.pagy_nav_js(pagy, pagy_id: 'test-nav-id', link_extra: 'link-extra',
                                    steps: { 0 => [1, 2, 2, 1], 600 => [1, 3, 3, 1] })).must_rematch :extras
    end
    it 'renders first page of multiple when used with Pagy::Countless' do
      require 'pagy/extras/countless'

      pagy, = Pagy::Countless.new(page: 1).finalize(23)
      _(app.pagy_nav_js(pagy)).must_rematch :plain
      _(app.pagy_nav_js(pagy, pagy_id: 'test-nav-id', link_extra: 'link-extra',
                                    steps: { 0 => [1, 2, 2, 1], 600 => [1, 3, 3, 1] })).must_rematch :extras
    end
    it 'renders intermediate page' do
      pagy = Pagy.new(size: [1, 4, 4, 1], count: 1000, page: 20)
      _(app.pagy_nav_js(pagy)).must_rematch :plain
      _(app.pagy_nav_js(pagy, pagy_id: 'test-nav-id', link_extra: 'link-extra',
                               steps: { 0 => [1, 2, 2, 1], 600 => [1, 3, 3, 1] })).must_rematch :extras
    end
    it 'renders last page' do
      pagy = Pagy.new(size: [1, 4, 4, 1], count: 1000, page: 50)
      _(app.pagy_nav_js(pagy)).must_rematch :plain
      _(app.pagy_nav_js(pagy, pagy_id: 'test-nav-id', link_extra: 'link-extra',
                               steps: { 0 => [1, 2, 2, 1], 600 => [1, 3, 3, 1] })).must_rematch :extras
    end
    it 'renders with :steps' do
      pagy = Pagy.new(count: 1000, page: 20, steps: { 0 => [1, 2, 2, 1], 500 => [2, 3, 3, 2] })
      _(app.pagy_nav_js(pagy)).must_rematch :plain
      _(app.pagy_nav_js(pagy, pagy_id: 'test-nav-id', link_extra: 'link-extra',
                               steps: { 0 => [1, 2, 2, 1], 600 => [1, 3, 3, 1] })).must_rematch :extras
    end
    it 'raises with missing step 0' do
      pagy = Pagy.new(count: 1000, page: 20, steps: { 0 => [1, 2, 2, 1], 600 => [1, 3, 3, 1] })
      _ { app.pagy_nav_js(pagy, steps: { 600 => [1, 3, 3, 1] }) }.must_raise Pagy::VariableError
    end
  end

  describe '#pagy_combo_nav_js' do
    it 'renders first page' do
      pagy = Pagy.new(count: 103, page: 1)
      _(app.pagy_combo_nav_js(pagy)).must_rematch :plain
      _(app.pagy_combo_nav_js(pagy, pagy_id: 'test-nav-id', link_extra: 'link-extra')).must_rematch :extras
    end
    it 'renders intermediate page' do
      pagy = Pagy.new(count: 103, page: 3)
      _(app.pagy_combo_nav_js(pagy)).must_rematch :plain
      _(app.pagy_combo_nav_js(pagy, pagy_id: 'test-nav-id', link_extra: 'link-extra')).must_rematch :extras
    end
    it 'renders last page' do
      pagy = Pagy.new(count: 103, page: 6)
      _(app.pagy_combo_nav_js(pagy)).must_rematch :plain
      _(app.pagy_combo_nav_js(pagy, pagy_id: 'test-nav-id', link_extra: 'link-extra')).must_rematch :extras
    end
  end
end
