# frozen_string_literal: true

require 'test_helper'

describe Pagy::I18n::P11n::OneOther do
  let(:rule) { Pagy::I18n::P11n::OneOther }

  it 'returns :one for 1' do
    _(rule.plural_for(1)).must_equal :one
  end

  it 'returns :other for 0' do
    _(rule.plural_for(0)).must_equal :other
  end

  it 'returns :other for other numbers' do
    _(rule.plural_for(2)).must_equal :other
    _(rule.plural_for(10)).must_equal :other
    _(rule.plural_for(100)).must_equal :other
  end
end
