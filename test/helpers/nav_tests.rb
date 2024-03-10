# frozen_string_literal: true

require 'pagy/extras/countless'
require_relative '../mock_helpers/pagy_buggy'
require_relative '../mock_helpers/app'

module NavTests
  def app
    MockApp.new
  end

  def nav_tests(style)
    method = :"pagy_#{style + '_' unless style == 'navs'}nav"
    [1, 20, 50].each do |page|
      pagy = Pagy.new(size: [1, 4, 4, 1], count: 1000, page: page)
      pagyx = Pagy.new(size: [1, 4, 4, 1], count: 1000, page: page, anchor_string: 'anchor_string')
      _(app.send(method, pagy)).must_rematch :"plain_#{page}"
      _(app.send(method, pagyx, id: 'test-nav-id')).must_rematch :"extras_#{page}"
    end
    _ { app.send(method, PagyBuggy.new(count: 100)) }.must_raise Pagy::InternalError
  end

  def nav_js_tests(style)  # e.g. pagy_bootstrap_nav_js
    method = :"pagy_#{style + '_' unless style == 'navs'}nav_js"
    [1, 20, 50].each do |page|
      pagy = Pagy.new(size: [1, 4, 4, 1], count: 1000, page: page)
      pagyx = Pagy.new(size: [1, 4, 4, 1], count: 1000, page: page, anchor_string: 'anchor_string')
      _(app.send(method, pagy)).must_rematch :"plain_#{page}"
      _(app.send(method, pagyx, id: 'test-nav-id',
                        steps: { 0 => [1, 2, 2, 1], 600 => [1, 3, 3, 1] })).must_rematch :"extras_#{page}"
    end
    # raise Pagy::VariableError for missing 0 step
    pagy = Pagy.new(count: 1000, page: 20, steps: { 0 => [1, 2, 2, 1], 600 => [1, 3, 3, 1] })
    _ { app.send(method, pagy, steps: { 600 => [1, 3, 3, 1] }) }.must_raise Pagy::VariableError
  end

  def nav_js_countless_tests(style)  # e.g. pagy_bootstrap_nav_js
    method = :"pagy_#{style + '_' unless style == 'navs'}nav_js"
    [[1, 0], [2, 23]].each do |page, rest|
      pagy = Pagy::Countless.new(page: page).finalize(rest)
      pagyx = Pagy::Countless.new(page: page, anchor_string: 'anchor_string').finalize(rest)
      _(app.send(method, pagy)).must_rematch :"plain_#{page}_#{rest}"
      _(app.send(method, pagyx, id: 'test-nav-id',
                 steps: { 0 => [1, 2, 2, 1], 600 => [1, 3, 3, 1] })).must_rematch :"extras_#{page}_#{rest}"
    end
  end

  def combo_nav_js_tests(style)
    method = :"pagy_#{style + '_' unless style == 'navs'}combo_nav_js"
    [1, 3, 6].each do |page|
      pagy = Pagy.new(count: 103, page: page)
      pagyx = Pagy.new(count: 103, page: page, anchor_string: 'anchor_string')
      _(app.send(method, pagy)).must_rematch :"plain_#{page}"
      _(app.send(method, pagyx, id: 'test-nav-id')).must_rematch :"extras_#{page}"
    end
  end
end
