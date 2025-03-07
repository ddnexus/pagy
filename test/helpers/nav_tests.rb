# frozen_string_literal: true

require_relative '../mock_helpers/pagy_buggy'
require_relative '../mock_helpers/app'
require_relative '../files/models'

module NavTests
  def request
    Pagy::Request.new(MockApp.new.request)
  end

  def nav_tests(style)
    [1, 20, 50].each do |page|
      pagy  = Pagy::Offset.new(count: 1000, page: page, request:)
      pagyx = Pagy::Offset.new(count: 1000, page: page, request:)
      _(pagy.nav_tag(style)).must_rematch :"plain_#{page}"
      _(pagyx.nav_tag(style, id: 'test-nav-id')).must_rematch :"extras_#{page}"
    end
    _ { PagyBuggy.new(count: 100, request:).nav_tag(style) }.must_raise Pagy::InternalError
    pagyk = Pagy::Keyset::Keynav.new(Pet.order(:animal, :name, :id),
                                     page: ['key', 2, 2, ["cat", "Ella", 18], nil], request:)
    _(pagyk.nav_tag(style)).must_rematch :keyset
  end

  def nav_js_tests(style)
    # e.g. pagy_bootstrap_nav_js
    [1, 20, 50].each do |page|
      pagy  = Pagy::Offset.new(count: 1000, page: page, request:)
      pagyx = Pagy::Offset.new(count: 1000, page: page, request:)
      _(pagy.nav_js_tag(style)).must_rematch :"plain_#{page}"
      _(pagyx.nav_js_tag(style, id: 'test-nav-id', steps: { 0 => 5, 600 => 7 })).must_rematch :"extras_#{page}"
    end
    # raise Pagy::OptionError for missing 0 step
    pagy = Pagy::Offset.new(count: 1000, page: 20, steps: { 0 => 5, 600 => 7 }, request:)
    _ { pagy.nav_js_tag(style, steps: { 600 => 7 }) }.must_raise Pagy::OptionError
    pagyk = Pagy::Keyset::Keynav.new(Pet.order(:animal, :name, :id),
                                     page: ['key', 2, 2, ["cat", "Ella", 18], nil], request:)
    _(pagyk.nav_js_tag(style)).must_rematch :keyset
  end

  def nav_js_countless_tests(style)
    # e.g. pagy_bootstrap_nav_js
    [[1, 0], [2, 23]].each do |page, rest|
      pagy  = Pagy::Offset::Countless.new(page: page, last: page, request:).send(:finalize, rest)
      pagyx = Pagy::Offset::Countless.new(page: page, last: page, request:).send(:finalize, rest)
      _(pagy.nav_js_tag(style)).must_rematch :"plain_#{page}_#{rest}"
      _(pagyx.nav_js_tag(style, id: 'test-nav-id', steps: { 0 => 5, 600 => 7 })).must_rematch :"extras_#{page}_#{rest}"
    end
  end

  def combo_nav_js_tests(style)
    [1, 3, 6].each do |page|
      pagy  = Pagy::Offset.new(count: 103, page: page, request:)
      pagyx = Pagy::Offset.new(count: 103, page: page, request:)
      pagyk = Pagy::Keyset::Keynav.new(Pet.order(:animal, :name, :id),
                                       page: ['key', 2, 2, ["cat", "Ella", 18], nil], request:)
      _(pagy.combo_nav_js_tag(style)).must_rematch :"plain_#{page}"
      _(pagyx.combo_nav_js_tag(style, id: 'test-nav-id')).must_rematch :"extras_#{page}"
      _(pagyk.combo_nav_js_tag(style)).must_rematch :keyset
    end
  end
end
