# frozen_string_literal: true

require 'e2e/test_helper'

describe 'Keynav App' do
  it "checks the HTML elements" do
    pages = (1..13).map(&:to_s) + %w[10 13]
    check_nav('#series-nav', pages:)
    check_nav('#series-nav-js-responsive', pages:, rjs: true)
  end
end
