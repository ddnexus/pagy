# frozen_string_literal: true

require 'mock_helpers/pagy_buggy'
require 'mock_helpers/app'
require 'files/models'

module NavTests
  # 1. The Helper Logic (Instance methods available inside 'it' blocks)
  def request
    MockApp.new.request
  end

  def series_nav_tests(style)
    [1, 20, 50].each do |page|
      pagy  = Pagy::Offset.new(count: 1000, page: page, request:)
      pagyx = Pagy::Offset.new(count: 1000, page: page, request:)
      _(pagy.series_nav(style)).must_rematch :"plain_#{page}"
      _(pagyx.series_nav(style, id: 'test-nav-id', anchor_string: 'raw="attribute"')).must_rematch :"extras_#{page}"
    end

    _ { PagyBuggy.new(count: 100, request:).series_nav(style) }.must_raise Pagy::InternalError
    pagyk = Pagy::Keyset::Keynav.new(Pet.order(:animal, :name, :id),
                                     page: ['key', 2, 2, ["cat", "Ella", 18], nil], request:)
    _(pagyk.series_nav(style)).must_rematch :keyset
  end

  def series_nav_js_tests(style)
    [1, 20, 50].each do |page|
      pagy  = Pagy::Offset.new(count: 1000, page: page, request:)
      pagyx = Pagy::Offset.new(count: 1000, page: page, request:)
      _(pagy.series_nav_js(style)).must_rematch :"plain_#{page}"
      _(pagyx.series_nav_js(style, id: 'test-nav-id', anchor_string: 'raw="attribute"', steps: { 0 => 5, 600 => 7 })).must_rematch :"extras_#{page}"
    end
    pagy = Pagy::Offset.new(count: 1000, page: 20, steps: { 0 => 5, 600 => 7 }, request:)
    _ { pagy.series_nav_js(style, steps: { 600 => 7 }) }.must_raise Pagy::OptionError
    pagyk = Pagy::Keyset::Keynav.new(Pet.order(:animal, :name, :id),
                                     page: ['key', 2, 2, ["cat", "Ella", 18], nil], request:)
    _(pagyk.series_nav_js(style)).must_rematch :keyset
  end

  def series_nav_js_countless_tests(style)
    [[1, 0], [2, 23]].each do |page, rest|
      pagy  = Pagy::Offset::Countless.new(page: page, last: page, request:).send(:finalize, rest)
      pagyx = Pagy::Offset::Countless.new(page: page, last: page, request:).send(:finalize, rest)
      _(pagy.series_nav_js(style)).must_rematch :"plain_#{page}_#{rest}"
      _(pagyx.series_nav_js(style, id: 'test-nav-id', anchor_string: 'raw="attribute"', steps: { 0 => 5, 600 => 7 })).must_rematch :"extras_#{page}_#{rest}"
    end
  end

  def input_nav_js_tests(style)
    [1, 3, 6].each do |page|
      pagy  = Pagy::Offset.new(count: 103, page: page, request:)
      pagyx = Pagy::Offset.new(count: 103, page: page, request:)
      pagyk = Pagy::Keyset::Keynav.new(Pet.order(:animal, :name, :id),
                                       page: ['key', 2, 2, ["cat", "Ella", 18], nil], request:)
      _(pagy.input_nav_js(style)).must_rematch :"plain_#{page}"
      _(pagyx.input_nav_js(style, id: 'test-nav-id', anchor_string: 'raw="attribute"')).must_rematch :"extras_#{page}"
      _(pagyk.input_nav_js(style)).must_rematch :keyset
    end
  end

  # 2. The Shared Specs (The Structure)
  module Shared
    def self.included(base)
      base.class_eval do
        # Expects 'style' to be defined via 'let' in the including class

        describe "nav" do
          it 'renders first, intermediate and last pages' do
            series_nav_tests(style)
          end
        end

        describe "nav_js" do
          it 'renders single and multiple pages when used with Pagy::Offset::Countless' do
            series_nav_js_countless_tests(style)
          end
          it 'renders first, intermediate and last pages with required steps' do
            series_nav_js_tests(style)
          end
        end

        describe "input_nav_js" do
          it 'renders first, intermediate and last pages' do
            input_nav_js_tests(style)
          end
        end
      end
    end
  end
end
