# frozen_string_literal: true

require 'e2e/test_helper'

describe 'Demo App' do
  it "checks the HTML elements for pagy/bulma/bootstrap" do
    %w[/pagy /bootstrap /bulma].each do |path|
      check_nav('#series-nav', path:)
      check_nav('#series-nav-js-responsive', rjs: true, path:)
      check_combo_nav('#input-nav-js', path:)
      check_info('#pagy-info', path:)
      check_limit_selector('#limit-tag-js', path:) if path == '/pagy'
    end
  end
end
