# frozen_string_literal: true

require 'test_helper'
require 'pagy/classes/calendar/calendar'

describe Pagy::Calendar::Month do
  let(:period) { [Time.zone.local(2021, 10, 21, 13, 18, 23, 0), Time.zone.local(2023, 11, 13, 15, 43, 40, 0)] }
  let(:default_opts) { { period: period } }

  before do
    Time.zone = 'Etc/GMT+5'
  end

  after do
    Time.zone = 'UTC'
  end

  def build(opts = {})
    Pagy::Calendar::Month.new(**default_opts, **opts)
  end

  describe 'variables' do
    it 'computes variables for page 1' do
      p = build
      _(p.instance_variable_get(:@initial)).must_equal Time.zone.local(2021, 10, 1)
      _(p.instance_variable_get(:@final)).must_equal Time.zone.local(2023, 12, 1)
      _(p.from).must_equal Time.zone.local(2021, 10, 1)
      _(p.to).must_equal Time.zone.local(2021, 11, 1)
      _(p.last).must_equal 26
    end

    it 'computes variables for page 2' do
      p = build(page: 2)
      _(p.from).must_equal Time.zone.local(2021, 11, 1)
      _(p.to).must_equal Time.zone.local(2021, 12, 1)
    end

    it 'computes variables for desc order' do
      p = build(order: :desc)
      _(p.from).must_equal Time.zone.local(2023, 11, 1)
      _(p.to).must_equal Time.zone.local(2023, 12, 1)
    end
  end

  describe '#page_at' do
    it 'returns page number' do
      p = build
      _(p.send(:page_at, Time.zone.local(2021, 10, 21))).must_equal 1
      _(p.send(:page_at, Time.zone.local(2022, 1, 1))).must_equal 4
      _(p.send(:page_at, Time.zone.local(2023, 11, 13))).must_equal 26
    end
  end
end
