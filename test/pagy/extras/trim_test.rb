# frozen_string_literal: true

require_relative '../../test_helper'
require 'pagy/extras/trim'

require_relative '../../mock_helpers/view'
describe 'pagy/extras/trim' do

  describe '#pagy_link_proc' do
    it 'returns trimmed or not trimmed links' do
      [ [1,  '?page=1',               ''],                    # only param
        [1,  '?page=1&b=2',           '?b=2'],                # first param
        [1,  '?a=1&page=1&b=2',       '?a=1&b=2'],            # middle param
        [1,  '?a=1&page=1',           '?a=1'],                # last param

        [1,  '?my_page=1&page=1',     '?my_page=1'],          # skip similar first param
        [1,  '?a=1&my_page=1&page=1', '?a=1&my_page=1'],      # skip similar middle param
        [1,  '?a=1&page=1&my_page=1', '?a=1&my_page=1'],      # skip similar last param

        [11, '?page=11',              '?page=11'],            # don't trim only param
        [11, '?page=11&b=2',          '?page=11&b=2'],        # don't trim first param
        [11, '?a=1&page=11&b=2',      '?a=1&page=11&b=2'],    # don't trim middle param
        [11, '?a=1&page=11',          '?a=1&page=11']         # don't trim last param
      ].each do |args|
        page, generated, trimmed = args
        view = MockView.new("http://example.com:3000/foo#{generated}")
        pagy = Pagy.new(count: 1000, page: page)
        link = view.pagy_link_proc(pagy)
        _(link.call(page)).must_equal("<a href=\"/foo#{trimmed}\"   >#{page}</a>")
        pagy = Pagy.new(count: 1000, page: page, enable_trim_extra: false)
        link = view.pagy_link_proc(pagy)
        _(link.call(page)).must_equal("<a href=\"/foo#{generated}\"   >#{page}</a>")
      end
    end
  end
end
