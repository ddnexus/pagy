# frozen_string_literal: true

require 'e2e/test_helper'

describe 'Repro App' do
  it "checks the HTML elements" do # --> navigate to page 1
    check_nav('#series-nav')
    check_nav('#series-nav-js-responsive', rjs: true)
    check_combo_nav('#input-nav-js')
    check_info('#pagy-info')
    check_limit_selector('#limit-tag-js')
  end
end
