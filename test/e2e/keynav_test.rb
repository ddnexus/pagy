# frozen_string_literal: true

require 'e2e/test_helper'

describe 'Keynav App' do
  parallelize_me! unless ENV['CI']

  pages = (1..13).map(&:to_s) + %w[10 13]

  it "checks series_nav" do
    check_nav('#series-nav', pages:)
  end

  it "checks series_nav_js responsive" do
    check_nav('#series-nav-js-responsive', pages:, rjs: true)
  end

  it "shares the storage key among the navs of the pagination" do
    visit('/')
    storage_keys = -> { browser.evaluate('Object.keys(sessionStorage).length') }

    _(storage_keys.call).must_equal 1

    browser.resize(width: 600, height: 1000)
    settle { browser.evaluate("document.querySelector('#series-nav-js-responsive').render()") }

    _(storage_keys.call).must_equal 1 # the re-rendered nav uses the same key
  end

  it "splits a page that holds more records than the limit" do
    visit('/')
    2.times { settle { browser.at_css('#series-nav').at_xpath(".//a[contains(text(), '>')]").click } } # reach page 3
    settle { browser.at_css('#series-nav').at_xpath(".//a[contains(text(), '<')]").click }             # back to page 2
    storage_key = JSON.parse(Pagy::B64.urlsafe_decode(browser.url[/[?&]page=([^&]+)/, 1]))[1]
    cutoffs     = -> { JSON.parse(browser.evaluate('sessionStorage.getItem(arguments[0])', storage_key)) }
    stored      = cutoffs.call
    # The same page 2 with half the limit: its 4 records are now more than the limit
    grown_page = browser.url.sub('limit=4', 'limit=2')
    visit(grown_page)

    _(browser.at_css('#records').inner_text.split(',').size).must_equal 2
    _(cutoffs.call.size).must_equal stored.size + 1          # a cutoff has been inserted...
    _(cutoffs.call.values_at(0, 1, 3, 4)).must_equal stored  # ... and the stored ones are still there
    split = cutoffs.call

    visit(grown_page) # the reloaded page generates the same update

    _(cutoffs.call).must_equal split # skipped by the client
  end

  it "merges a page that fits with the next page" do
    visit('/')
    2.times { settle { browser.at_css('#series-nav').at_xpath(".//a[contains(text(), '>')]").click } } # reach page 3
    settle { browser.at_css('#series-nav').at_xpath(".//a[contains(text(), '<')]").click }             # back to page 2
    storage_key = JSON.parse(Pagy::B64.urlsafe_decode(browser.url[/[?&]page=([^&]+)/, 1]))[1]
    cutoffs     = -> { JSON.parse(browser.evaluate('sessionStorage.getItem(arguments[0])', storage_key)) }
    stored      = cutoffs.call
    # The same page 2 with twice the limit: its 4 records and the 4 records of page 3 fit in the limit
    short_page = browser.url.sub('limit=4', 'limit=8')
    visit(short_page)

    _(browser.at_css('#records').inner_text.split(',').size).must_equal 8
    _(cutoffs.call).must_equal stored.values_at(0, 1, 3) # the cutoff of page 2 has been deleted
    merged = cutoffs.call

    visit(short_page) # the reloaded page generates the same update

    _(cutoffs.call).must_equal merged # skipped by the client
  end

  it "restarts from the first of two empty pages" do
    visit('/')
    3.times { settle { browser.at_css('#series-nav').at_xpath(".//a[contains(text(), '>')]").click } } # reach page 4
    browser_key, storage_key = JSON.parse(Pagy::B64.urlsafe_decode(browser.url[/[?&]page=([^&]+)/, 1]))
    cutoffs = -> { JSON.parse(browser.evaluate('sessionStorage.getItem(arguments[0])', storage_key)) }
    stored  = cutoffs.call
    # Page 2 and 3 as if their records were deleted: they end at the same cutoff of page 1
    emptied = stored.dup.fill(stored[1], 2..3)
    browser.evaluate('sessionStorage.setItem(arguments[0], arguments[1])', storage_key, emptied.to_json)
    empty_page = Pagy::B64.urlsafe_encode([browser_key, storage_key, 2, emptied.size, *emptied[1..3]].to_json)
    empty_page = browser.url.sub(/(?<=[?&]page=)[^&]+/, empty_page)
    visit(empty_page)

    _(browser.at_css('#records').inner_text.split(',').size).must_equal 4 # the next records, not an empty page
    _(cutoffs.call).must_equal stored.first(3)                            # the cutoffs after page 2 are forgotten

    visit(empty_page) # the reloaded page generates the same update

    _(cutoffs.call).must_equal stored.first(3) # skipped by the client
  end

  it "skips the cutoffs update of a stale page" do
    visit('/')
    2.times { settle { browser.at_css('#series-nav').at_xpath(".//a[contains(text(), '>')]").click } } # reach page 3
    browser_key, storage_key = JSON.parse(Pagy::B64.urlsafe_decode(browser.url[/[?&]page=([^&]+)/, 1]))
    cutoffs = -> { browser.evaluate('sessionStorage.getItem(arguments[0])', storage_key) }
    stored  = cutoffs.call
    # Page 1 requested as when its cutoff was still unknown, with a limit that generates a different cutoff
    stale_page = Pagy::B64.urlsafe_encode([browser_key, storage_key, 1, 1, nil, nil, nil].to_json)
    visit("/?page=#{stale_page}&limit=7")

    _(browser.at_css('#records').inner_text.split(',').size).must_equal 7 # the server used the stale page
    _(cutoffs.call).must_equal stored                                     # the client skipped its update
  end
end
