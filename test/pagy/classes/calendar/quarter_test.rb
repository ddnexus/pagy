# frozen_string_literal: true

require 'test_helper'
require 'pagy/classes/calendar/calendar'

describe Pagy::Calendar::Quarter do
  let(:period) { [Time.zone.local(2021, 10, 21, 13, 18, 23, 0), Time.zone.local(2023, 11, 13, 15, 43, 40, 0)] }
  let(:default_opts) { { period: period } }

  before do
    Time.zone = 'Etc/GMT+5'
  end

  after do
    Time.zone = 'UTC'
  end

  def build(opts = {})
    Pagy::Calendar::Quarter.new(**default_opts, **opts)
  end

  describe 'variables' do
    it 'computes variables for page 1' do
      p = build
      _(p.instance_variable_get(:@initial)).must_equal Time.zone.local(2021, 10, 1)
      _(p.instance_variable_get(:@final)).must_equal Time.zone.local(2024, 1, 1)
      _(p.from).must_equal Time.zone.local(2021, 10, 1)
      _(p.to).must_equal Time.zone.local(2022, 1, 1)
      _(p.last).must_equal 9
    end

    it 'computes variables for page 2' do
      p = build(page: 2)
      _(p.from).must_equal Time.zone.local(2022, 1, 1)
      _(p.to).must_equal Time.zone.local(2022, 4, 1)
    end

    it 'computes variables for desc order' do
      p = build(order: :desc)
      _(p.from).must_equal Time.zone.local(2023, 10, 1)
      _(p.to).must_equal Time.zone.local(2024, 1, 1)
    end
  end

  describe '#page_label' do
    it 'formats with %q token' do
      p = build(format: 'Q%q %Y')
      # Page 1: Oct 2021 -> Q4 2021
      _(p.send(:page_label, 1)).must_equal 'Q4 2021'
      # Page 2: Jan 2022 -> Q1 2022
      _(p.send(:page_label, 2)).must_equal 'Q1 2022'
    end
  end

  describe '#page_at' do
    it 'returns page number' do
      p = build
      _(p.send(:page_at, Time.zone.local(2021, 10, 21))).must_equal 1
      _(p.send(:page_at, Time.zone.local(2022, 1, 1))).must_equal 2
      _(p.send(:page_at, Time.zone.local(2023, 11, 13))).must_equal 9
    end
  end
end
