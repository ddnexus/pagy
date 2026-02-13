# frozen_string_literal: true

require 'unit/test_helper'

describe 'Pagy::I18n::P11n::Polish Specs' do
  let(:rule) { Pagy::I18n::P11n::Polish }

  it 'returns :one for 1' do
    _(rule.plural_for(1)).must_equal :one
  end

  it 'returns :few for 2-4 (excluding teens 12-14)' do
    # 2, 3, 4, 22, 23, 24, 102...
    [2, 3, 4, 22, 23, 24, 32, 42, 102].each do |n|
      _(rule.plural_for(n)).must_equal :few, "Failed for #{n}"
    end
  end

  it 'returns :many for 0, 5-9, teens, and others' do
    # Ends in 0, 1 (except 1), 5-9
    # 0, 5, 6, 7, 8, 9, 10, 11
    [0, 5, 6, 7, 8, 9, 10, 11, 20, 21, 25].each do |n|
      _(rule.plural_for(n)).must_equal :many, "Failed for #{n}"
    end

    # Teens 12, 13, 14 (override the 2,3,4 rule)
    [12, 13, 14, 112, 113, 114].each do |n|
      _(rule.plural_for(n)).must_equal :many, "Failed for #{n}"
    end
  end

  it 'returns :other for fractionals' do
    _(rule.plural_for(1.5)).must_equal :other
  end
end
