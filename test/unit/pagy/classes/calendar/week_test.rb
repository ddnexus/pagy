# frozen_string_literal: true

require 'unit/test_helper'
require 'pagy/classes/calendar/calendar'

describe 'Pagy::Calendar::Week Specs' do
  let(:period) { [Time.zone.local(2021, 10, 21, 13, 18, 23, 0), Time.zone.local(2023, 11, 13, 15, 43, 40, 0)] }
  let(:default_opts) { { period: period } }

  before do
    Time.zone = 'Etc/GMT+5'
    Date.beginning_of_week = :sunday
  end

  after do
    Time.zone = 'UTC'
    Date.beginning_of_week = :monday
  end

  def build(opts = {})
    Pagy::Calendar::Week.new(**default_opts, **opts)
  end

  describe 'variables' do
    it 'computes variables for page 1' do
      p = build
      # 2021-10-21 is Thursday. Beginning of week (Sunday) is 2021-10-17
      _(p.instance_variable_get(:@initial)).must_equal Time.zone.local(2021, 10, 17)
      _(p.instance_variable_get(:@final)).must_equal Time.zone.local(2023, 11, 19)
      _(p.from).must_equal Time.zone.local(2021, 10, 17)
      _(p.to).must_equal Time.zone.local(2021, 10, 24)
      _(p.last).must_equal 109
    end

    it 'computes variables for page 2' do
      p = build(page: 2)
      _(p.from).must_equal Time.zone.local(2021, 10, 24)
      _(p.to).must_equal Time.zone.local(2021, 10, 31)
    end

    it 'computes variables for desc order' do
      p = build(order: :desc)
      _(p.from).must_equal Time.zone.local(2023, 11, 12)
      _(p.to).must_equal Time.zone.local(2023, 11, 19)
    end
  end

  describe '#page_at' do
    it 'returns page number' do
      p = build
      _(p.send(:page_at, Time.zone.local(2021, 10, 21))).must_equal 1
      _(p.send(:page_at, Time.zone.local(2021, 10, 26))).must_equal 2
      _(p.send(:page_at, Time.zone.local(2023, 11, 13))).must_equal 109
    end
  end
end
