# frozen_string_literal: true

require 'test_helper'

describe Pagy::I18n::P11n::Arabic do
  let(:rule) { Pagy::I18n::P11n::Arabic }

  it 'returns :zero for 0' do
    _(rule.plural_for(0)).must_equal :zero
  end

  it 'returns :one for 1' do
    _(rule.plural_for(1)).must_equal :one
  end

  it 'returns :two for 2' do
    _(rule.plural_for(2)).must_equal :two
  end

  it 'returns :few for 3-10 and 103-110' do
    [3, 5, 10, 103, 105, 110, 203].each do |n|
      _(rule.plural_for(n)).must_equal :few, "Failed for #{n}"
    end
  end

  it 'returns :many for 11-99 and 111-199' do
    [11, 20, 99, 111, 150, 199, 211].each do |n|
      _(rule.plural_for(n)).must_equal :many, "Failed for #{n}"
    end
  end

  it 'returns :other for 100, 101, 102, 200...' do
    [100, 101, 102, 200, 201, 202, 1000].each do |n|
      _(rule.plural_for(n)).must_equal :other, "Failed for #{n}"
    end
  end
end
