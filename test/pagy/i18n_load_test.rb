# frozen_string_literal: true

require_relative '../test_helper'

# isolated in this file because uses the frozen public API
describe 'pagy/i18n-load' do
  it 'loads with public API' do
    Pagy::I18n.load({ locale: 'de' }, { locale: 'en' })

    _(Pagy::I18n::DATA.size).must_equal 2
    _(Pagy::I18n::DATA.keys).must_include 'de'
    _(Pagy::I18n::DATA.keys).must_include 'en'
    _(proc { Pagy::I18n.load({ locale: 'de' }, { locale: 'en' }) }).must_raise FrozenError
  end
end
