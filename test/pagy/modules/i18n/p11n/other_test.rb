# frozen_string_literal: true

require 'test_helper'

describe Pagy::I18n::P11n::Other do
  let(:rule) { Pagy::I18n::P11n::Other }

  it 'always returns :other' do
    [0, 1, 2, 5, 10, 100, -1, 1.5].each do |n|
      _(rule.plural_for(n)).must_equal :other
    end
  end
end
