# frozen_string_literal: true

require_relative '../../../test_helper'
require_relative '../../../../gem/lib/pagy/classes/calendar/calendar'         # required to use the Time.zone= defined by activesupport
require_relative '../../../../gem/lib/pagy/toolbox/methods/support/a_lambda' # just to check the page_label

Time.zone = "Pacific Time (US & Canada)"
Date.beginning_of_week = :sunday

describe 'DST last page_label' do
  describe ':day unit' do
    it 'calculates the last label out of DST' do
      starting = Time.zone.local(2022, 3, 1, 3)   # PST
      ending   = Time.zone.local(2022, 3, 10, 3)  # PST
      p = Pagy::Calendar::Day.new(format: '%Y-%m-%d', period: [starting, ending])
      _(p.send(:page_label, p.last)).must_equal "2022-03-10"
    end
    it 'calculates the last label entering DST' do
      starting = Time.zone.local(2022, 3, 10, 3)  # PST
      ending   = Time.zone.local(2022, 3, 20, 3)  # PDT
      p = Pagy::Calendar::Day.new(format: '%Y-%m-%d', period: [starting, ending])
      _(p.send(:page_label, p.last)).must_equal "2022-03-20"
    end
    it 'calculates the last label in DST' do
      starting = Time.zone.local(2022, 10, 1, 3)   # PDT
      ending   = Time.zone.local(2022, 10, 10, 3)  # PDT
      p = Pagy::Calendar::Day.new(format: '%Y-%m-%d', period: [starting, ending])
      _(p.send(:page_label, p.last)).must_equal "2022-10-10"
    end
    it 'calculates the last label exiting DST' do
      starting = Time.zone.local(2022, 11, 1, 3)   # PDT
      ending   = Time.zone.local(2022, 11, 10, 3)  # PST
      p = Pagy::Calendar::Day.new(format: '%Y-%m-%d', period: [starting, ending])
      _(p.send(:page_label, p.last)).must_equal "2022-11-10"
    end
  end

  describe ':week unit' do
    it 'calculates the last label out of DST' do
      starting = Time.zone.local(2022, 3, 1, 3)   # PST
      ending   = Time.zone.local(2022, 3, 10, 3)  # PST
      p = Pagy::Calendar::Week.new(period: [starting, ending])
      _(p.send(:page_label, p.last)).must_equal "2022-09"
    end
    it 'calculates the last label entering DST' do
      starting = Time.zone.local(2022, 3, 10, 3)  # PST
      ending   = Time.zone.local(2022, 3, 21, 3)  # PDT
      p = Pagy::Calendar::Week.new(period: [starting, ending])
      _(p.send(:page_label, p.last)).must_equal "2022-11"
    end
    it 'calculates the last label in DST' do
      starting = Time.zone.local(2022, 10, 1, 3)   # PDT
      ending   = Time.zone.local(2022, 10, 10, 3)  # PDT
      p = Pagy::Calendar::Week.new(period: [starting, ending])
      _(p.send(:page_label, p.last)).must_equal "2022-40"
    end
    it 'calculates the last label exiting DST' do
      starting = Time.zone.local(2022, 11, 1, 3)   # PDT
      ending   = Time.zone.local(2022, 11, 10, 3)  # PST
      p = Pagy::Calendar::Week.new(period: [starting, ending])
      _(p.send(:page_label, p.last)).must_equal "2022-44"
    end
  end

  describe ':month unit' do
    it 'calculates the last label out of DST' do
      starting = Time.zone.local(2021, 12, 3, 3)   # PST
      ending   = Time.zone.local(2022, 2, 10, 3)  # PST
      p = Pagy::Calendar::Month.new(format: '%Y-%m', period: [starting, ending])
      _(p.send(:page_label, p.last)).must_equal "2022-02"
    end
    it 'calculates the last label entering DST' do
      starting = Time.zone.local(2022, 2, 10, 3)  # PST
      ending   = Time.zone.local(2022, 4, 21, 3)  # PDT  W
      p = Pagy::Calendar::Month.new(format: '%Y-%m', period: [starting, ending])
      _(p.send(:page_label, p.last)).must_equal "2022-04"
    end
    it 'calculates the last label in DST' do
      starting = Time.zone.local(2022, 7, 1, 3)   # PDT
      ending   = Time.zone.local(2022, 9, 10, 3)  # PDT
      p = Pagy::Calendar::Month.new(format: '%Y-%m', period: [starting, ending])
      _(p.send(:page_label, p.last)).must_equal "2022-09"
    end
    it 'calculates the last label exiting DST' do
      starting = Time.zone.local(2022, 9, 10, 3)   # PDT
      ending   = Time.zone.local(2022, 11, 10, 3)  # PST
      p = Pagy::Calendar::Month.new(format: '%Y-%m', period: [starting, ending])
      _(p.send(:page_label, p.last)).must_equal "2022-11"
    end
  end

  describe ':quarter unit' do
    it 'calculates the last label out of DST' do
      starting = Time.zone.local(2022, 1, 3, 3)  # PST
      ending   = Time.zone.local(2022, 2, 10, 3)  # PST
      p = Pagy::Calendar::Quarter.new(format: '%Y-Q%q', period: [starting, ending])
      _(p.send(:page_label, p.last)).must_equal "2022-Q1"
    end
    it 'calculates the last label entering DST' do
      starting = Time.zone.local(2022, 2, 10, 3)  # PST
      ending   = Time.zone.local(2022, 4, 21, 3)  # PDT  W
      p = Pagy::Calendar::Quarter.new(format: '%Y-Q%q', period: [starting, ending])
      _(p.send(:page_label, p.last)).must_equal "2022-Q2"
    end
    it 'calculates the last label in DST' do
      starting = Time.zone.local(2022, 7, 1, 3)   # PDT
      ending   = Time.zone.local(2022, 9, 10, 3)  # PDT
      p = Pagy::Calendar::Quarter.new(format: '%Y-Q%q', period: [starting, ending])
      _(p.send(:page_label, p.last)).must_equal "2022-Q3"
    end
    it 'calculates the last label exiting DST' do
      starting = Time.zone.local(2022, 9, 10, 3)   # PDT
      ending   = Time.zone.local(2022, 11, 10, 3)  # PST
      p = Pagy::Calendar::Quarter.new(format: '%Y-Q%q', period: [starting, ending])
      _(p.send(:page_label, p.last)).must_equal "2022-Q4"
    end
  end
end
