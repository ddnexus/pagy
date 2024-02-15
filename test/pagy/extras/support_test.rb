# frozen_string_literal: true

require_relative '../../test_helper'
require 'pagy/extras/support'
require 'pagy/countless'

require_relative '../../mock_helpers/app'

describe 'pagy/extras/support' do
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
  describe '#pagy_prev_link_tag' do
    tests_for(:pagy_prev_link_tag, [[1, 21], [3, 21], [6, 21], [50, 20]], absolute: true)
  end
  describe '#pagy_next_link_tag' do
    tests_for(:pagy_next_link_tag,  [[1, 21], [3, 21], [6, 21], [50, 20]], absolute: true)
  end
  describe '#pagy_prev_html' do
    tests_for(:pagy_prev_html, [[1, 0], [3, 21], [6, 21], [50, 20]],
              text: 'PREV', link_extra: 'link-extra')
  end
  describe '#pagy_next_html' do
    tests_for(:pagy_next_html, [[1, 0], [3, 21], [6, 21], [50, 20]],
              text: 'PREV', link_extra: 'link-extra')
  end
end
