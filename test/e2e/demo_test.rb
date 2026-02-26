# frozen_string_literal: true

require 'e2e/test_helper'

describe 'Demo App' do
  parallelize_me! unless ENV['CI']

  it "checks series_nav" do
    %w[/pagy /bootstrap /bulma].each do |path|
      check_nav('#series-nav', path:)
    end
  end

  it "checks series_nav_js responsive" do
    %w[/pagy /bootstrap /bulma].each do |path|
      check_nav('#series-nav-js-responsive', rjs: true, path:)
    end
  end

  it "checks input_nav_js" do
    %w[/pagy /bootstrap /bulma].each do |path|
      check_input_nav('#input-nav-js', path:)
    end
  end

  it "checks info_tag" do
    %w[/pagy /bootstrap /bulma].each do |path|
      check_info('#pagy-info', path:)
    end
  end

  it "checks limit_tag_js" do
    check_limit_tag('#limit-tag-js', path: '/pagy')
  end
end
