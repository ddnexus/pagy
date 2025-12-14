# frozen_string_literal: true

require 'test_helper'

describe Pagy::I18n::P11n::OneUptoTwoOther do
  let(:rule) { Pagy::I18n::P11n::OneUptoTwoOther }

  it 'returns :one for [0, 2)' do
    [0, 0.5, 1, 1.99].each do |n|
      _(rule.plural_for(n)).must_equal :one, "Failed for #{n}"
    end
  end

  it 'returns :other for 2 and above' do
    [2, 2.1, 3, 10, 100].each do |n|
      _(rule.plural_for(n)).must_equal :other, "Failed for #{n}"
    end
  end

  it 'returns :other for negative numbers' do
    _(rule.plural_for(-1)).must_equal :other
  end
end
