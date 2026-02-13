# frozen_string_literal: true

require 'e2e/test_helper'

describe 'Calendar App' do
  selectors = %w[#year-nav #month-nav #day-nav #pagy-info]

  it "checks the HTML elements (skip true/false)" do
    %w[true false].each do |val|
      browser.goto("?skip_counts=#{val}")

      # Test #go-to-day
      browser.at_css('#go-to-day').click
      browser.wait_for_reload(timeout)
      hold_html(*selectors)

      # Test calendar navs
      browser.at_css('#year-nav').at_xpath(".//a[contains(text(), '2022')]").click
      browser.wait_for_reload(timeout)
      hold_html(*selectors)

      browser.at_css('#month-nav').at_xpath(".//a[contains(text(), 'Apr')]").click
      browser.wait_for_reload(timeout)
      hold_html(*selectors)

      browser.at_css('#day-nav').at_xpath(".//a[contains(text(), '05')]").click
      browser.wait_for_reload(timeout)
      hold_html(*selectors)

      browser.at_css('#day-nav').at_xpath(".//a[contains(text(), '06')]").click
      browser.wait_for_reload(timeout)
      hold_html(*selectors)
    end
  end

  it 'tests app toggle' do
    browser.goto('/')
    hold_html(*selectors)

    browser.at_css('#toggle').click
    browser.wait_for_reload(timeout)
    hold_html('#pages-nav')

    browser.at_css('#toggle').click
    browser.wait_for_reload(timeout)
    hold_html(*selectors)
  end
end
