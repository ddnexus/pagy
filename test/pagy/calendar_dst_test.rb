# frozen_string_literal: true

require_relative '../test_helper'
require 'pagy/calendar'

Time.zone = "Pacific Time (US & Canada)"
Date.beginning_of_week = :sunday

describe 'pagy/calendar_dst' do
  describe ':day unit' do
    it 'calculates the last label out of DST' do
      starting = Time.zone.local(2022, 3, 1, 3)   # PST
      ending   = Time.zone.local(2022, 3, 10, 3)  # PST
      p = Pagy::Calendar.send(:create, :day, format: '%Y-%m-%d', period: [starting, ending])

      _(p.label_for(p.last)).must_equal "2022-03-10"
    end
    it 'calculates the last label entering DST' do
      starting = Time.zone.local(2022, 3, 10, 3)  # PST
      ending   = Time.zone.local(2022, 3, 20, 3)  # PDT
      p = Pagy::Calendar.send(:create, :day, format: '%Y-%m-%d', period: [starting, ending])

      _(p.label_for(p.last)).must_equal "2022-03-20"
    end
    it 'calculates the last label in DST' do
      starting = Time.zone.local(2022, 10, 1, 3)   # PDT
      ending   = Time.zone.local(2022, 10, 10, 3)  # PDT
      p = Pagy::Calendar.send(:create, :day, format: '%Y-%m-%d', period: [starting, ending])

      _(p.label_for(p.last)).must_equal "2022-10-10"
    end
    it 'calculates the last label exiting DST' do
      starting = Time.zone.local(2022, 11, 1, 3)   # PDT
      ending   = Time.zone.local(2022, 11, 10, 3)  # PST
      p = Pagy::Calendar.send(:create, :day, format: '%Y-%m-%d', period: [starting, ending])

      _(p.label_for(p.last)).must_equal "2022-11-10"
    end
  end

  describe ':week unit' do
    it 'calculates the last label out of DST' do
      starting = Time.zone.local(2022, 3, 1, 3)   # PST
      ending   = Time.zone.local(2022, 3, 10, 3)  # PST
      p = Pagy::Calendar.send(:create, :week, period: [starting, ending])

      _(p.label_for(p.last)).must_equal "2022-09"
    end
    it 'calculates the last label entering DST' do
      starting = Time.zone.local(2022, 3, 10, 3)  # PST
      ending   = Time.zone.local(2022, 3, 21, 3)  # PDT
      p = Pagy::Calendar.send(:create, :week, period: [starting, ending])

      _(p.label_for(p.last)).must_equal "2022-11"
    end
    it 'calculates the last label in DST' do
      starting = Time.zone.local(2022, 10, 1, 3)   # PDT
      ending   = Time.zone.local(2022, 10, 10, 3)  # PDT
      p = Pagy::Calendar.send(:create, :week, period: [starting, ending])

      _(p.label_for(p.last)).must_equal "2022-40"
    end
    it 'calculates the last label exiting DST' do
      starting = Time.zone.local(2022, 11, 1, 3)   # PDT
      ending   = Time.zone.local(2022, 11, 10, 3)  # PST
      p = Pagy::Calendar.send(:create, :week, period: [starting, ending])

      _(p.label_for(p.last)).must_equal "2022-44"
    end
  end

  describe ':month unit' do
    it 'calculates the last label out of DST' do
      starting = Time.zone.local(2021, 12, 3, 3)   # PST
      ending   = Time.zone.local(2022, 2, 10, 3)  # PST
      p = Pagy::Calendar.send(:create, :month, format: '%Y-%m', period: [starting, ending])

      _(p.label_for(p.last)).must_equal "2022-02"
    end
    it 'calculates the last label entering DST' do
      starting = Time.zone.local(2022, 2, 10, 3)  # PST
      ending   = Time.zone.local(2022, 4, 21, 3)  # PDT  W
      p = Pagy::Calendar.send(:create, :month, format: '%Y-%m', period: [starting, ending])

      _(p.label_for(p.last)).must_equal "2022-04"
    end
    it 'calculates the last label in DST' do
      starting = Time.zone.local(2022, 7, 1, 3)   # PDT
      ending   = Time.zone.local(2022, 9, 10, 3)  # PDT
      p = Pagy::Calendar.send(:create, :month, format: '%Y-%m', period: [starting, ending])

      _(p.label_for(p.last)).must_equal "2022-09"
    end
    it 'calculates the last label exiting DST' do
      starting = Time.zone.local(2022, 9, 10, 3)   # PDT
      ending   = Time.zone.local(2022, 11, 10, 3)  # PST
      p = Pagy::Calendar.send(:create, :month, format: '%Y-%m', period: [starting, ending])

      _(p.label_for(p.last)).must_equal "2022-11"
    end
  end

  describe ':quarter unit' do
    it 'calculates the last label out of DST' do
      starting = Time.zone.local(2022, 1, 3, 3)  # PST
      ending   = Time.zone.local(2022, 2, 10, 3)  # PST
      p = Pagy::Calendar.send(:create, :quarter, format: '%Y-Q%q', period: [starting, ending])

      _(p.label_for(p.last)).must_equal "2022-Q1"
    end
    it 'calculates the last label entering DST' do
      starting = Time.zone.local(2022, 2, 10, 3)  # PST
      ending   = Time.zone.local(2022, 4, 21, 3)  # PDT  W
      p = Pagy::Calendar.send(:create, :quarter, format: '%Y-Q%q', period: [starting, ending])

      _(p.label_for(p.last)).must_equal "2022-Q2"
    end
    it 'calculates the last label in DST' do
      starting = Time.zone.local(2022, 7, 1, 3)   # PDT
      ending   = Time.zone.local(2022, 9, 10, 3)  # PDT
      p = Pagy::Calendar.send(:create, :quarter, format: '%Y-Q%q', period: [starting, ending])

      _(p.label_for(p.last)).must_equal "2022-Q3"
    end
    it 'calculates the last label exiting DST' do
      starting = Time.zone.local(2022, 9, 10, 3)   # PDT
      ending   = Time.zone.local(2022, 11, 10, 3)  # PST
      p = Pagy::Calendar.send(:create, :quarter, format: '%Y-Q%q', period: [starting, ending])

      _(p.label_for(p.last)).must_equal "2022-Q4"
    end
  end
end
