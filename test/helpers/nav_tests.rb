# frozen_string_literal: true

require_relative '../mock_helpers/pagy_buggy'
require_relative '../mock_helpers/app'
require_relative '../files/models'

module NavTests
  def request
    Pagy::Request.new(MockApp.new.request)
  end

  def series_nav_tests(style)
    [1, 20, 50].each do |page|
      pagy  = Pagy::Offset.new(count: 1000, page: page, request:)
      pagyx = Pagy::Offset.new(count: 1000, page: page, request:)
      _(pagy.series_nav(style)).must_rematch :"plain_#{page}"
      _(pagyx.series_nav(style, id: 'test-nav-id')).must_rematch :"extras_#{page}"
    end
    _ { PagyBuggy.new(count: 100, request:).series_nav(style) }.must_raise Pagy::InternalError
    pagyk = Pagy::Keyset::Keynav.new(Pet.order(:animal, :name, :id),
                                     page: ['key', 2, 2, ["cat", "Ella", 18], nil], request:)
    _(pagyk.series_nav(style)).must_rematch :keyset
  end

  def series_nav_js_tests(style)
    # e.g. pagy_bootstrap_nav_js
    [1, 20, 50].each do |page|
      pagy  = Pagy::Offset.new(count: 1000, page: page, request:)
      pagyx = Pagy::Offset.new(count: 1000, page: page, request:)
      _(pagy.series_nav_js(style)).must_rematch :"plain_#{page}"
      _(pagyx.series_nav_js(style, id: 'test-nav-id', steps: { 0 => 5, 600 => 7 })).must_rematch :"extras_#{page}"
    end
    # raise Pagy::OptionError for missing 0 step
    pagy = Pagy::Offset.new(count: 1000, page: 20, steps: { 0 => 5, 600 => 7 }, request:)
    _ { pagy.series_nav_js(style, steps: { 600 => 7 }) }.must_raise Pagy::OptionError
    pagyk = Pagy::Keyset::Keynav.new(Pet.order(:animal, :name, :id),
                                     page: ['key', 2, 2, ["cat", "Ella", 18], nil], request:)
    _(pagyk.series_nav_js(style)).must_rematch :keyset
  end

  def series_nav_js_countless_tests(style)
    # e.g. pagy_bootstrap_nav_js
    [[1, 0], [2, 23]].each do |page, rest|
      pagy  = Pagy::Offset::Countless.new(page: page, last: page, request:).send(:finalize, rest)
      pagyx = Pagy::Offset::Countless.new(page: page, last: page, request:).send(:finalize, rest)
      _(pagy.series_nav_js(style)).must_rematch :"plain_#{page}_#{rest}"
      _(pagyx.series_nav_js(style, id: 'test-nav-id', steps: { 0 => 5, 600 => 7 })).must_rematch :"extras_#{page}_#{rest}"
    end
  end

  def input_nav_js_tests(style)
    [1, 3, 6].each do |page|
      pagy  = Pagy::Offset.new(count: 103, page: page, request:)
      pagyx = Pagy::Offset.new(count: 103, page: page, request:)
      pagyk = Pagy::Keyset::Keynav.new(Pet.order(:animal, :name, :id),
                                       page: ['key', 2, 2, ["cat", "Ella", 18], nil], request:)
      _(pagy.input_nav_js(style)).must_rematch :"plain_#{page}"
      _(pagyx.input_nav_js(style, id: 'test-nav-id')).must_rematch :"extras_#{page}"
      _(pagyk.input_nav_js(style)).must_rematch :keyset
    end
  end
end
