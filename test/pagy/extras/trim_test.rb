# frozen_string_literal: true

require_relative '../../test_helper'
require 'pagy/extras/trim'
require 'pagy/extras/jsonapi'
require_relative '../../mock_helpers/app'

describe 'pagy/extras/trim' do
  describe '#pagy_anchor' do
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

        pagy = Pagy.new(count: 1000, page: page, jsonapi: false)
        a    = app.pagy_anchor(pagy)
        _(a.(page)).must_include(%(<a href="/foo#{trimmed}"))

        pagy = Pagy.new(count: 1000, page: page, jsonapi: false, trim_extra: false)
        a    = app.pagy_anchor(pagy)
        _(a.(page)).must_include(%(<a href="/foo#{not_trimmed}"))
      end
    end

    describe 'when jsonapi is enabled' do
      it 'returns trimmed or not trimmed links' do
        [ # first page
          [{ page: { page: 1 } }, '?page%5Bpage%5D=1', ''], # only param
          [{ page: { page: '1' } }, '?page%5Bpage%5D=1', ''], # only param
          [{ page: { page: 1 }, b: 2 }, '?page%5Bpage%5D=1&b=2', '?b=2'], # first param
          [{ a: 1, page: { page: 1 }, b: 2 }, '?a=1&page%5Bpage%5D=1&b=2', '?a=1&b=2'], # middle param
          [{ a: 1, page: { page: 1 } }, '?a=1&page%5Bpage%5D=1', '?a=1'], # last param
          # first page with similar key (my_page)
          [{ my_page: 1, page: { page: 1 } }, '?my_page=1&page%5Bpage%5D=1', '?my_page=1'], # similar first param
          [{ a: 1, my_page: 1, page: { page: 1 } }, '?a=1&my_page=1&page%5Bpage%5D=1', '?a=1&my_page=1'], # similar middle param
          [{ a: 1, page: { page: 1 }, my_page: 1 }, '?a=1&page%5Bpage%5D=1&my_page=1', '?a=1&my_page=1'], # similar last param
          # no first page but similar value (11)
          [{ page: { page: 11 } }, '?page%5Bpage%5D=11', '?page%5Bpage%5D=11'], # only param
          [{ page: { page: 11 }, b: 2 }, '?page%5Bpage%5D=11&b=2', '?page%5Bpage%5D=11&b=2'], # first param
          [{ a: 1, page: { page: 11 }, b: 2 }, '?a=1&page%5Bpage%5D=11&b=2', '?a=1&page%5Bpage%5D=11&b=2'], # middle param
          [{ a: 1, page: { page: 11 } }, '?a=1&page%5Bpage%5D=11', '?a=1&page%5Bpage%5D=11'] # last param
        ].each do |args|
          params, not_trimmed, trimmed = args

          page = params[:page][:page]
          app = MockApp.new(params: params)

          pagy = Pagy.new(count: 1000, page: page, jsonapi: true)
          a = app.pagy_anchor(pagy)
          _(a.(page)).must_include(%(<a href="/foo#{trimmed}"))

          pagy = Pagy.new(count: 1000, page: page, jsonapi: true, trim_extra: false)
          a = app.pagy_anchor(pagy)
          _(a.(page)).must_include(%(<a href="/foo#{not_trimmed}"))
        end
      end
    end
  end
end
