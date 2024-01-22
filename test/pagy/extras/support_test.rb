# frozen_string_literal: true

require_relative '../../test_helper'
require 'pagy/extras/support'
require 'pagy/countless'

require_relative '../../mock_helpers/app'

describe 'pagy/extras/support' do
  let(:app) { MockApp.new }

  describe '#pagy_prev_url' do
    it 'returns the prev url for page 1' do
      pagy = Pagy.new count: 1000, page: 1
      pagy_countless = Pagy::Countless.new(page: 1).finalize(21)
      _(app.pagy_prev_url(pagy)).must_be_nil
      _(app.pagy_prev_url(pagy_countless)).must_be_nil
    end
    it 'returns the prev url for page 3' do
      pagy = Pagy.new count: 1000, page: 3
      pagy_countless = Pagy::Countless.new(page: 3).finalize(21)
      _(app.pagy_prev_url(pagy)).must_equal '/foo?page=2'
      _(app.pagy_prev_url(pagy_countless)).must_equal '/foo?page=2'
    end
    it 'returns the prev url for page 6' do
      pagy = Pagy.new count: 1000, page: 6
      pagy_countless = Pagy::Countless.new(page: 6).finalize(21)
      _(app.pagy_prev_url(pagy)).must_equal '/foo?page=5'
      _(app.pagy_prev_url(pagy_countless)).must_equal '/foo?page=5'
    end
    it 'returns the prev url for last page' do
      pagy = Pagy.new count: 1000, page: 50
      pagy_countless = Pagy::Countless.new(page: 50).finalize(20)
      _(app.pagy_prev_url(pagy)).must_equal '/foo?page=49'
      _(app.pagy_prev_url(pagy_countless)).must_equal '/foo?page=49'
    end
  end

  describe '#pagy_next_url' do
    it 'returns the next url for page 1' do
      pagy = Pagy.new count: 1000, page: 1
      pagy_countless = Pagy::Countless.new(page: 1).finalize(21)
      _(app.pagy_next_url(pagy)).must_equal '/foo?page=2'
      _(app.pagy_next_url(pagy_countless)).must_equal '/foo?page=2'
    end
    it 'returns the next url for page 3' do
      pagy = Pagy.new count: 1000, page: 3
      pagy_countless = Pagy::Countless.new(page: 3).finalize(21)
      _(app.pagy_next_url(pagy)).must_equal '/foo?page=4'
      _(app.pagy_next_url(pagy_countless)).must_equal '/foo?page=4'
    end
    it 'returns the url next for page 6' do
      pagy = Pagy.new count: 1000, page: 6
      pagy_countless = Pagy::Countless.new(page: 6).finalize(21)
      _(app.pagy_next_url(pagy)).must_equal '/foo?page=7'
      _(app.pagy_next_url(pagy_countless)).must_equal '/foo?page=7'
    end
    it 'returns the url next for last page' do
      pagy = Pagy.new count: 1000, page: 50
      pagy_countless = Pagy::Countless.new(page: 50).finalize(20)
      _(app.pagy_next_url(pagy)).must_be_nil
      _(app.pagy_next_url(pagy_countless)).must_be_nil
    end
  end

  describe '#pagy_prev_html' do
    it 'renders the prev link for page 1' do
      pagy = Pagy.new count: 1000, page: 1
      pagy_countless = Pagy::Countless.new(page: 1).finalize(21)
      _(app.pagy_prev_html(pagy)).must_rematch :prev_1
      _(app.pagy_prev_html(pagy_countless)).must_rematch :prev_2
      _(app.pagy_prev_html(pagy, link_extra: 'link-extra')).must_rematch :prev_3
      _(app.pagy_prev_html(pagy_countless, link_extra: 'link-extra')).must_rematch :prev_4
    end

    it 'renders the prev link for page 3' do
      pagy = Pagy.new count: 1000, page: 3
      pagy_countless = Pagy::Countless.new(page: 3).finalize(21)
      _(app.pagy_prev_html(pagy)).must_rematch :prev_1
      _(app.pagy_prev_html(pagy_countless)).must_rematch :prev_2
      _(app.pagy_prev_html(pagy, link_extra: 'link-extra')).must_rematch :prev_3
      _(app.pagy_prev_html(pagy_countless, link_extra: 'link-extra')).must_rematch :prev_4
    end
    it 'renders the prev link for page 6' do
      pagy = Pagy.new count: 1000, page: 6
      pagy_countless = Pagy::Countless.new(page: 6).finalize(21)
      _(app.pagy_prev_html(pagy)).must_rematch :prev_1
      _(app.pagy_prev_html(pagy_countless)).must_rematch :prev_2
      _(app.pagy_prev_html(pagy, link_extra: 'link-extra')).must_rematch :prev_3
      _(app.pagy_prev_html(pagy_countless, link_extra: 'link-extra')).must_rematch :prev_4
    end
    it 'renders the prev link for last page' do
      pagy = Pagy.new count: 1000, page: 50
      pagy_countless = Pagy::Countless.new(page: 50).finalize(20)
      _(app.pagy_prev_html(pagy)).must_rematch :prev_1
      _(app.pagy_prev_html(pagy_countless)).must_rematch :prev_2
      _(app.pagy_prev_html(pagy, link_extra: 'link-extra')).must_rematch :prev_3
      _(app.pagy_prev_html(pagy_countless, link_extra: 'link-extra')).must_rematch :prev_4
    end
  end

  describe '#pagy_next_link' do
    it 'renders the next link for page 1' do
      pagy = Pagy.new count: 1000, page: 1
      pagy_countless = Pagy::Countless.new(page: 1).finalize(21)
      _(app.pagy_next_html(pagy)).must_rematch :next_1
      _(app.pagy_next_html(pagy_countless)).must_rematch :next_2
      _(app.pagy_next_html(pagy, link_extra: 'link-extra')).must_rematch :next_3
      _(app.pagy_next_html(pagy_countless, link_extra: 'link-extra')).must_rematch :next_4
    end
    it 'renders the next link for page 3' do
      pagy = Pagy.new count: 1000, page: 3
      pagy_countless = Pagy::Countless.new(page: 3).finalize(21)
      _(app.pagy_next_html(pagy)).must_rematch :next_1
      _(app.pagy_next_html(pagy_countless)).must_rematch :next_2
      _(app.pagy_next_html(pagy, link_extra: 'link-extra')).must_rematch :next_3
      _(app.pagy_next_html(pagy_countless, link_extra: 'link-extra')).must_rematch :next_4
    end
    it 'renders the next link for page 6' do
      pagy = Pagy.new count: 1000, page: 6
      pagy_countless = Pagy::Countless.new(page: 6).finalize(21)
      _(app.pagy_next_html(pagy)).must_rematch :next_1
      _(app.pagy_next_html(pagy_countless)).must_rematch :next_2
      _(app.pagy_next_html(pagy, link_extra: 'link-extra')).must_rematch :next_3
      _(app.pagy_next_html(pagy_countless, link_extra: 'link-extra')).must_rematch :next_4
    end
    it 'renders the next link for last page' do
      pagy = Pagy.new count: 1000, page: 50
      pagy_countless = Pagy::Countless.new(page: 50).finalize(20)
      _(app.pagy_next_html(pagy)).must_rematch :next_1
      _(app.pagy_next_html(pagy_countless)).must_rematch :next_2
      _(app.pagy_next_html(pagy, link_extra: 'link-extra')).must_rematch :next_3
      _(app.pagy_next_html(pagy_countless, link_extra: 'link-extra')).must_rematch :next_4
    end
  end

  describe '#pagy_prev_link_tag' do
    it 'renders the prev link tag for page 1' do
      pagy = Pagy.new count: 1000, page: 1
      pagy_countless = Pagy::Countless.new(page: 1).finalize(21)
      _(app.pagy_prev_link_tag(pagy)).must_be_nil
      _(app.pagy_prev_link_tag(pagy_countless)).must_be_nil
    end
    it 'renders the prev link tag for page 3' do
      pagy = Pagy.new count: 1000, page: 3
      pagy_countless = Pagy::Countless.new(page: 3).finalize(21)
      _(app.pagy_prev_link_tag(pagy)).must_rematch :link_1
      _(app.pagy_prev_link_tag(pagy_countless)).must_rematch :link_2
    end
    it 'renders the prev link tag for page 6' do
      pagy = Pagy.new count: 1000, page: 6
      pagy_countless = Pagy::Countless.new(page: 6).finalize(21)
      _(app.pagy_prev_link_tag(pagy)).must_rematch :prev_1
      _(app.pagy_prev_link_tag(pagy_countless)).must_rematch :prev_2
    end
    it 'renders the prev link tag for last page' do
      pagy = Pagy.new count: 1000, page: 50
      pagy_countless = Pagy::Countless.new(page: 50).finalize(20)
      _(app.pagy_prev_link_tag(pagy)).must_rematch :prev_1
      _(app.pagy_prev_link_tag(pagy_countless)).must_rematch :prev_2
    end
  end

  describe '#pagy_next_link_tag' do
    it 'renders the next link tag for page 1' do
      pagy = Pagy.new count: 1000, page: 1
      pagy_countless = Pagy::Countless.new(page: 1).finalize(21)
      _(app.pagy_next_link_tag(pagy)).must_rematch :next_1
      _(app.pagy_next_link_tag(pagy_countless)).must_rematch :next_2
    end
    it 'renders the next link tag for page 3' do
      pagy = Pagy.new count: 1000, page: 3
      pagy_countless = Pagy::Countless.new(page: 3).finalize(21)
      _(app.pagy_next_link_tag(pagy)).must_rematch :next_1
      _(app.pagy_next_link_tag(pagy_countless)).must_rematch :next_2
    end
    it 'renders the next link tag for page 6' do
      pagy = Pagy.new count: 1000, page: 6
      pagy_countless = Pagy::Countless.new(page: 6).finalize(21)
      _(app.pagy_next_link_tag(pagy)).must_rematch :next_1
      _(app.pagy_next_link_tag(pagy_countless)).must_rematch :next_2
    end
    it 'renders the next link tag for last page' do
      pagy = Pagy.new count: 1000, page: 50
      pagy_countless = Pagy::Countless.new(page: 50).finalize(20)
      _(app.pagy_next_link_tag(pagy)).must_be_nil
      _(app.pagy_next_link_tag(pagy_countless)).must_be_nil
    end
  end
end
