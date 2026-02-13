# frozen_string_literal: true

require 'unit/test_helper'

describe 'Pagy::I18n::P11n::EastSlavic Specs' do
  let(:rule) { Pagy::I18n::P11n::EastSlavic }

  it 'returns :one for numbers ending in 1 (except 11)' do
    [1, 21, 31, 41, 101, 1001].each do |n|
      _(rule.plural_for(n)).must_equal :one, "Failed for #{n}"
    end
  end

  it 'returns :few for numbers ending in 2-4 (except 12-14)' do
    [2, 3, 4, 22, 23, 24, 32, 102].each do |n|
      _(rule.plural_for(n)).must_equal :few, "Failed for #{n}"
    end
  end

  it 'returns :many for 0, 5-9, and teens (11-14)' do
    # 0, 5-9, 10
    [0, 5, 6, 7, 8, 9, 10].each do |n|
      _(rule.plural_for(n)).must_equal :many, "Failed for #{n}"
    end

    # 11-19, 111-119 (The teens rule)
    [11, 12, 13, 14, 15, 19, 111, 112].each do |n|
      _(rule.plural_for(n)).must_equal :many, "Failed for #{n}"
    end

    # 20, 25-29, etc.
    [20, 25, 29, 100, 105].each do |n|
      _(rule.plural_for(n)).must_equal :many, "Failed for #{n}"
    end
  end

  it 'returns :other for fractional numbers' do
    # Logic: 1.5 % 10 != 1, not in 2..4, etc.
    _(rule.plural_for(1.5)).must_equal :other
  end
end
