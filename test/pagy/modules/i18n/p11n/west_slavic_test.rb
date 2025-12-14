# frozen_string_literal: true

require 'test_helper'

describe Pagy::I18n::P11n::WestSlavic do
  let(:rule) { Pagy::I18n::P11n::WestSlavic }

  it 'returns :one for 1' do
    _(rule.plural_for(1)).must_equal :one
  end

  it 'returns :few for 2, 3, 4' do
    [2, 3, 4].each do |n|
      _(rule.plural_for(n)).must_equal :few, "Failed for #{n}"
    end
  end

  it 'returns :other for everything else' do
    [0, 5, 10, 22, 100].each do |n|
      _(rule.plural_for(n)).must_equal :other, "Failed for #{n}"
    end
  end
end
