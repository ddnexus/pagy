# frozen_string_literal: true

require 'e2e/test_helper'

describe 'Rails App' do
  parallelize_me! unless ENV['CI']

  it "checks series_nav" do
    check_nav('#series-nav', pages: %w[3])
  end

  it "checks series_nav_js" do
    check_nav('#series-nav-js', pages: %w[3])
  end

  it "checks input_nav_js" do
    check_input_nav('#input-nav-js')
  end

  it "checks info_tag" do
    check_info('#pagy-info')
  end

  it "checks limit_tag_js" do
    check_limit_tag('#limit-tag-js')
  end
end
