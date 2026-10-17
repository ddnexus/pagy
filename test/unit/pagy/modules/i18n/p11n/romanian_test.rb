# frozen_string_literal: true

require 'unit/test_helper'

describe 'Pagy::I18n::P11n::Romanian Specs' do
  let(:rule) { Pagy::I18n::P11n::Romanian }

  it 'returns :one for 1' do
    _(rule.plural_for(1)).must_equal :one
  end

  it 'returns :few for 0 and n % 100 in 1..19 (except 1)' do
    [0, 2, 5, 19, 101, 102, 119, 1001].each do |n|
      _(rule.plural_for(n)).must_equal :few, "Failed for #{n}"
    end
  end

  it 'returns :other for everything else' do
    [20, 21, 99, 100, 120, 200, 1000].each do |n|
      _(rule.plural_for(n)).must_equal :other, "Failed for #{n}"
    end
  end
end
