# frozen_string_literal: true

require 'e2e/test_helper'

describe 'Calendar App' do
  ids = %w[#year-nav #month-nav #day-nav #pagy-info]

  it "checks the HTML elements (skip true/false)" do
    %w[true false].each do |val|
      browser.goto("?skip_counts=#{val}")

      # Test #go-to-day
      interact_and_hold(*ids) { browser.at_css('#go-to-day').click }

      # Test calendar navs
      interact_and_hold(*ids) { browser.at_css('#year-nav').at_xpath(".//a[contains(text(), '2022')]").click }
      interact_and_hold(*ids) { browser.at_css('#month-nav').at_xpath(".//a[contains(text(), 'Apr')]").click }
      interact_and_hold(*ids) { browser.at_css('#day-nav').at_xpath(".//a[contains(text(), '05')]").click }
      interact_and_hold(*ids) { browser.at_css('#day-nav').at_xpath(".//a[contains(text(), '06')]").click }
    end
  end

  it 'tests app toggle' do
    browser.goto('/')
    hold_html(*ids)

    interact_and_hold('#pages-nav') { browser.at_css('#toggle').click }
    interact_and_hold(*ids) { browser.at_css('#toggle').click }
  end
end
