# frozen_string_literal: true

require_relative '../test_helper'
require 'pagy/calendar'

def pagy(vars={})
  default = { local_minmax: [ Time.new(2021, 10, 21, 13, 18, 23, 0), Time.new(2023, 11, 13, 15, 43, 40, 0)] }
  Pagy::Calendar.new default.merge(vars)
end

describe 'pagy/calendar' do
  describe 'instance methods and variables' do
    it 'defines calendar specific attr readers' do
      %i[utc_from utc_to unit week_offset order count= in=].each { |meth| assert_respond_to pagy, meth}
    end
    it 'raises Pagy::VariableError' do
      _ { pagy(unit: :unknown) }.must_raise Pagy::VariableError
      _ { pagy(local_minmax: [1, 10]) }.must_raise Pagy::VariableError
      _ { pagy(local_minmax: [Time.now]) }.must_raise Pagy::VariableError
      _ { pagy(local_minmax: [Time.now, 2]) }.must_raise Pagy::VariableError
      _ { pagy(local_minmax: [Time.now.utc, Time.now]) }.must_raise Pagy::VariableError
      _ { pagy(order: :unknown) }.must_raise Pagy::VariableError
      _ { pagy(year_format: :unknown) }.must_raise Pagy::VariableError
      _ { pagy(month_format: :unknown) }.must_raise Pagy::VariableError
      _ { pagy(week_format: :unknown) }.must_raise Pagy::VariableError
      _ { pagy(day_format: :unknown) }.must_raise Pagy::VariableError
    end
  end

  describe 'it computes date variables for page 1 (default)' do
    it 'computes variables for :year' do
      p = pagy(unit: :year)
      _(p.instance_variable_get('@initial')).must_equal Time.gm(2021)
      _(p.instance_variable_get('@final')).must_equal Time.gm(2024)
      _(p.utc_from).must_equal Time.gm(2021)
      _(p.utc_to).must_equal Time.gm(2022)
      _(p.pages).must_equal 3
      _(p.last).must_equal 3
    end
    it 'computes variables for :year desc' do
      p = pagy(unit: :year, order: :desc)
      _(p.instance_variable_get('@initial')).must_equal Time.gm(2021)
      _(p.instance_variable_get('@final')).must_equal Time.gm(2024)
      _(p.utc_from).must_equal Time.gm(2023)
      _(p.utc_to).must_equal Time.gm(2024)
      _(p.pages).must_equal 3
      _(p.last).must_equal 3
    end
    it 'computes variables for :month (default)' do
      p = pagy
      _(p.instance_variable_get('@initial')).must_equal Time.gm(2021, 10, 1)
      _(p.instance_variable_get('@final')).must_equal Time.gm(2023, 12, 1)
      _(p.utc_from).must_equal Time.gm(2021, 10, 1)
      _(p.utc_to).must_equal Time.gm(2021, 11, 1)
      _(p.pages).must_equal 26
      _(p.last).must_equal 26
    end
    it 'computes variables for :week' do
      p = pagy(unit: :week)
      _(p.instance_variable_get('@initial')).must_equal Time.gm(2021, 10, 17)
      _(p.instance_variable_get('@final')).must_equal Time.gm(2023, 11, 19)
      _(p.utc_from).must_equal Time.gm(2021, 10, 17)
      _(p.utc_to).must_equal Time.gm(2021, 10, 24)
      _(p.pages).must_equal 109
      _(p.last).must_equal 109
    end
    it 'computes variables for :week with week_offset: 1 (Monday)' do
      p = pagy(unit: :week, week_offset: 1)
      _(p.instance_variable_get('@initial')).must_equal Time.gm(2021, 10, 18)
      _(p.instance_variable_get('@final')).must_equal Time.gm(2023, 11, 20)
      _(p.utc_from).must_equal Time.gm(2021, 10, 18)
      _(p.utc_to).must_equal Time.gm(2021, 10, 25)
      _(p.pages).must_equal 109
      _(p.last).must_equal 109
    end
    it 'computes variables for :week with week_offset: 6 (Saturday)' do
      p = pagy(unit: :week, week_offset: 6)
      _(p.instance_variable_get('@initial')).must_equal Time.gm(2021, 10, 16)
      _(p.instance_variable_get('@final')).must_equal Time.gm(2023, 11, 18)
      _(p.utc_from).must_equal Time.gm(2021, 10, 16)
      _(p.utc_to).must_equal Time.gm(2021, 10, 23)
      _(p.pages).must_equal 109
      _(p.last).must_equal 109
    end
    it 'computes variables for :day' do
      p = pagy(unit: :day)
      _(p.instance_variable_get('@initial')).must_equal Time.gm(2021, 10, 21)
      _(p.instance_variable_get('@final')).must_equal Time.gm(2023, 11, 14)
      _(p.utc_from).must_equal Time.gm(2021, 10, 21)
      _(p.utc_to).must_equal Time.gm(2021, 10, 22)
      _(p.pages).must_equal 754
      _(p.last).must_equal 754
    end
  end

  describe 'it computes date variables for page 2' do
    it 'computes variables for :year' do
      p = pagy(unit: :year, page: 2)
      _(p.instance_variable_get('@initial')).must_equal Time.gm(2021)
      _(p.instance_variable_get('@final')).must_equal Time.gm(2024)
      _(p.utc_from).must_equal Time.gm(2022)
      _(p.utc_to).must_equal Time.gm(2023)
      _(p.pages).must_equal 3
      _(p.last).must_equal 3
    end
    it 'computes variables for :month (default)' do
      p = pagy(page: 2)
      _(p.instance_variable_get('@initial')).must_equal Time.gm(2021, 10, 1)
      _(p.instance_variable_get('@final')).must_equal Time.gm(2023, 12, 1)
      _(p.utc_from).must_equal Time.gm(2021, 11, 1)
      _(p.utc_to).must_equal Time.gm(2021, 12, 1)
      _(p.pages).must_equal 26
      _(p.last).must_equal 26
    end
    it 'computes variables for :week' do
      p = pagy(unit: :week, page: 2)
      _(p.instance_variable_get('@initial')).must_equal Time.gm(2021, 10, 17)
      _(p.instance_variable_get('@final')).must_equal Time.gm(2023, 11, 19)
      _(p.utc_from).must_equal Time.gm(2021, 10, 24)
      _(p.utc_to).must_equal Time.gm(2021, 10, 31)
      _(p.pages).must_equal 109
      _(p.last).must_equal 109
    end
    it 'computes variables for :week with week_offset: 1 (Monday)' do
      p = pagy(unit: :week, week_offset: 1, page: 2)
      _(p.instance_variable_get('@initial')).must_equal Time.gm(2021, 10, 18)
      _(p.instance_variable_get('@final')).must_equal Time.gm(2023, 11, 20)
      _(p.utc_from).must_equal Time.gm(2021, 10, 25)
      _(p.utc_to).must_equal Time.gm(2021, 11, 1)
      _(p.pages).must_equal 109
      _(p.last).must_equal 109
    end
    it 'computes variables for :week with week_offset: 6 (Saturday)' do
      p = pagy(unit: :week, week_offset: 6, page: 2)
      _(p.instance_variable_get('@initial')).must_equal Time.gm(2021, 10, 16)
      _(p.instance_variable_get('@final')).must_equal Time.gm(2023, 11, 18)
      _(p.utc_from).must_equal Time.gm(2021, 10, 23)
      _(p.utc_to).must_equal Time.gm(2021, 10, 30)
      _(p.pages).must_equal 109
      _(p.last).must_equal 109
    end
    it 'computes variables for :day' do
      p = pagy(unit: :day, page: 2)
      _(p.instance_variable_get('@initial')).must_equal Time.gm(2021, 10, 21)
      _(p.instance_variable_get('@final')).must_equal Time.gm(2023, 11, 14)
      _(p.utc_from).must_equal Time.gm(2021, 10, 22)
      _(p.utc_to).must_equal Time.gm(2021, 10, 23)
      _(p.pages).must_equal 754
      _(p.last).must_equal 754
    end
  end

  describe 'it computes date variables for last page and overflow' do
    it 'computes variables for :year' do
      p = pagy(unit: :year, page: 3)
      _(p.instance_variable_get('@initial')).must_equal Time.gm(2021)
      _(p.instance_variable_get('@final')).must_equal Time.gm(2024)
      _(p.utc_from).must_equal Time.gm(2023)
      _(p.utc_to).must_equal Time.gm(2024)
      _(p.pages).must_equal 3
      _(p.last).must_equal 3
      _(pagy(unit: :year, page: 3, cycle: true).next).must_equal 1
      _{ pagy(unit: :year, page: 4) }.must_raise Pagy::OverflowError
    end
    it 'computes variables for :month (default)' do
      p = pagy(page: 26)
      _(p.instance_variable_get('@initial')).must_equal Time.gm(2021, 10, 1)
      _(p.instance_variable_get('@final')).must_equal Time.gm(2023, 12, 1)
      _(p.utc_from).must_equal Time.gm(2023, 11, 1)
      _(p.utc_to).must_equal Time.gm(2023, 12, 1)
      _(p.pages).must_equal 26
      _(p.last).must_equal 26
      _(pagy(page: 26, cycle: true).next).must_equal 1
      _{ pagy(page: 27) }.must_raise Pagy::OverflowError
    end
    it 'computes variables for :week' do
      p = pagy(unit: :week, page: 109)
      _(p.instance_variable_get('@initial')).must_equal Time.gm(2021, 10, 17)
      _(p.instance_variable_get('@final')).must_equal Time.gm(2023, 11, 19)
      _(p.utc_from).must_equal Time.gm(2023, 11, 12)
      _(p.utc_to).must_equal Time.gm(2023, 11, 19)
      _(p.pages).must_equal 109
      _(p.last).must_equal 109
      _(pagy(unit: :week, page: 109, cycle: true).next).must_equal 1
      _{ pagy(unit: :week, page: 110) }.must_raise Pagy::OverflowError
    end
    it 'computes variables for :week with week_offset: 1 (Monday)' do
      p = pagy(unit: :week, week_offset: 1, page: 109)
      _(p.instance_variable_get('@initial')).must_equal Time.gm(2021, 10, 18)
      _(p.instance_variable_get('@final')).must_equal Time.gm(2023, 11, 20)
      _(p.utc_from).must_equal Time.gm(2023, 11, 13)
      _(p.utc_to).must_equal Time.gm(2023, 11, 20)
      _(p.pages).must_equal 109
      _(p.last).must_equal 109
      _(pagy(unit: :week, page: 109, cycle: true).next).must_equal 1
      _{ pagy(unit: :week, page: 110) }.must_raise Pagy::OverflowError
    end
    it 'computes variables for :week with week_offset: 6 (Saturday)' do
      p = pagy(unit: :week, week_offset: 6, page: 109)
      _(p.instance_variable_get('@initial')).must_equal Time.gm(2021, 10, 16)
      _(p.instance_variable_get('@final')).must_equal Time.gm(2023, 11, 18)
      _(p.utc_from).must_equal Time.gm(2023, 11, 11)
      _(p.utc_to).must_equal Time.gm(2023, 11, 18)
      _(p.pages).must_equal 109
      _(p.last).must_equal 109
      _(pagy(unit: :week, page: 109, cycle: true).next).must_equal 1
      _{ pagy(unit: :week, page: 110) }.must_raise Pagy::OverflowError
    end
    it 'computes variables for :day' do
      p = pagy(unit: :day, page: 754)
      _(p.instance_variable_get('@initial')).must_equal Time.gm(2021, 10, 21)
      _(p.instance_variable_get('@final')).must_equal Time.gm(2023, 11, 14)
      _(p.utc_from).must_equal Time.gm(2023, 11, 13)
      _(p.utc_to).must_equal Time.gm(2023, 11, 14)
      _(p.pages).must_equal 754
      _(p.last).must_equal 754
      _(pagy(unit: :day, page: 754, cycle: true).next).must_equal 1
      _{ pagy(unit: :day, page: 755) }.must_raise Pagy::OverflowError
    end
  end

  describe 'snap' do
    it 'inverts the order' do
      p = pagy(unit: :month, order: :desc)
      _(p.send(:snap, 1)).must_equal 25
      _(p.send(:snap, 2)).must_equal 24
      _(p.send(:snap, 3)).must_equal 23
      _(p.send(:snap, 24)).must_equal 2
      _(p.send(:snap, 25)).must_equal 1
      _(p.send(:snap, 26)).must_equal 0
    end
  end
end
