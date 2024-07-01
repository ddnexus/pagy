# frozen_string_literal: true

require 'pagy/extras/countless'
require_relative '../mock_helpers/pagy_buggy'
require_relative '../mock_helpers/app'

module NavTests
  def app
    MockApp.new
  end

  def nav_tests(prefix)
    method = :"pagy#{prefix}_nav"
    [1, 20, 50].each do |page|
      pagy = Pagy.new(count: 1000, page: page)
      pagyx = Pagy.new(count: 1000, page: page)
      _(app.send(method, pagy)).must_rematch :"plain_#{page}"
      _(app.send(method, pagyx, id: 'test-nav-id', anchor_string: 'anchor_string')).must_rematch :"extras_#{page}"
    end
    _ { app.send(method, PagyBuggy.new(count: 100)) }.must_raise Pagy::InternalError
  end

  def nav_js_tests(prefix)  # e.g. pagy_bootstrap_nav_js
    method = :"pagy#{prefix}_nav_js"
    [1, 20, 50].each do |page|
      pagy = Pagy.new(count: 1000, page: page)
      pagyx = Pagy.new(count: 1000, page: page)
      _(app.send(method, pagy)).must_rematch :"plain_#{page}"
      _(app.send(method, pagyx, id: 'test-nav-id', anchor_string: 'anchor_string',
                        steps: { 0 => 5, 600 => 7 })).must_rematch :"extras_#{page}"
    end
    # raise Pagy::VariableError for missing 0 step
    pagy = Pagy.new(count: 1000, page: 20, steps: { 0 => 5, 600 => 7 })
    _ { app.send(method, pagy, steps: { 600 => 7 }) }.must_raise Pagy::VariableError
  end

  def nav_js_countless_tests(prefix)  # e.g. pagy_bootstrap_nav_js
    method = :"pagy#{prefix}_nav_js"
    [[1, 0], [2, 23]].each do |page, rest|
      pagy = Pagy::Countless.new(page: page).finalize(rest)
      pagyx = Pagy::Countless.new(page: page).finalize(rest)
      _(app.send(method, pagy)).must_rematch :"plain_#{page}_#{rest}"
      _(app.send(method, pagyx, id: 'test-nav-id', anchor_string: 'anchor_string',
                 steps: { 0 => 5, 600 => 7 })).must_rematch :"extras_#{page}_#{rest}"
    end
  end

  def combo_nav_js_tests(prefix)
    method = :"pagy#{prefix}_combo_nav_js"
    [1, 3, 6].each do |page|
      pagy = Pagy.new(count: 103, page: page)
      pagyx = Pagy.new(count: 103, page: page)
      _(app.send(method, pagy)).must_rematch :"plain_#{page}"
      _(app.send(method, pagyx, id: 'test-nav-id', anchor_string: 'anchor_string')).must_rematch :"extras_#{page}"
    end
  end
end
