# frozen_string_literal: true

require 'e2e/test_helper'

describe 'Keynav App' do
  pages = (1..13).map(&:to_s) + %w[10 13]

  it "checks series_nav" do
    check_nav('#series-nav', pages:)
  end

  it "checks series_nav_js responsive" do
    check_nav('#series-nav-js-responsive', pages:, rjs: true)
  end
end
