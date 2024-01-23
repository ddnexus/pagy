# frozen_string_literal: true

require_relative '../../test_helper'
require 'pagy/extras/trim'

require_relative '../../mock_helpers/app'

describe 'pagy/extras/trim' do
  describe '#pagy_link_proc' do
    it 'returns trimmed or not trimmed links' do
      [ # first page
        [{ page: 1 },                    '?page=1',                      ''],                         # only param
        [{ page: '1' },                  '?page=1',                      ''],                         # only param
        [{ page: 1, b: 2 },              '?page=1&b=2',              '?b=2'],                         # first param
        [{ a: 1, page: 1, b: 2 },        '?a=1&page=1&b=2',      '?a=1&b=2'],                         # middle param
        [{ a: 1, page: 1 },              '?a=1&page=1',              '?a=1'],                         # last param
        # first page with similar key (my_page)
        [{ my_page: 1, page: 1 },       '?my_page=1&page=1',         '?my_page=1'],                   # similar first param
        [{ a: 1, my_page: 1, page: 1 }, '?a=1&my_page=1&page=1', '?a=1&my_page=1'],                   # similar middle param
        [{ a: 1, page: 1, my_page: 1 }, '?a=1&page=1&my_page=1', '?a=1&my_page=1'],                   # similar last param
        # no first page but similar value (11)
        [{ page: 11 },                  '?page=11',                      '?page=11'],                 # only param
        [{ page: 11, b: 2 },            '?page=11&b=2',              '?page=11&b=2'],                 # first param
        [{ a: 1, page: 11, b: 2 },      '?a=1&page=11&b=2',      '?a=1&page=11&b=2'],                 # middle param
        [{ a: 1, page: 11 },            '?a=1&page=11',              '?a=1&page=11']                  # last param
      ].each do |args|
        params, not_trimmed, trimmed = args
        page = params[:page]
        app  = MockApp.new(params: params)

        pagy = Pagy.new(count: 1000, page: page)
        link = app.pagy_link_proc(pagy)
        aria = 'aria-current="page" ' if pagy.page == page
        _(link.call(page)).must_equal("<a href=\"/foo#{trimmed}\"   #{aria}>#{page}</a>")

        pagy = Pagy.new(count: 1000, page: page, trim_extra: false)
        link = app.pagy_link_proc(pagy)
        _(link.call(page)).must_equal("<a href=\"/foo#{not_trimmed}\"   #{aria}>#{page}</a>")
      end
    end
  end
end
