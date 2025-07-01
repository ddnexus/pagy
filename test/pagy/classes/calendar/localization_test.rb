# frozen_string_literal: true

require_relative '../../../test_helper'
require_relative '../../../mock_helpers/app'
require_relative '../../../../gem/lib/pagy/toolbox/helpers/support/a_lambda' # just to check the page_label

Time.zone = 'EST'
Date.beginning_of_week = :sunday

## Test not needed: Now it's a manual patch in the pagy.rb initializer
describe 'Calendar with I18n.localize' do
  ##### pagy.rb initializer ###############
  require 'rails-i18n'
  Pagy::Calendar.localize_with_rails_i18n_gem(:de)
  #########################################

  it 'works in :en' do
    pagy = Pagy::Calendar::Month.new(period: [Time.zone.local(2021, 10, 21, 13, 18, 23, 0),
                                              Time.zone.local(2023, 11, 13, 15, 43, 40, 0)],
                                     page: 3, format: '%B, %A')

    _(pagy.send(:page_label, 3)).must_equal "December, Wednesday"
    _(pagy.send(:page_label, 3, locale: :de)).must_equal "Dezember, Mittwoch"
    _(pagy.send(:page_label, 3, format: '%b')).must_equal "Dec"
    _(pagy.send(:page_label, 3, format: '%b', locale: :de)).must_equal "Dez"
    _(pagy.send(:page_label, 5)).must_equal "February, Tuesday"
    _(pagy.send(:page_label, 5, locale: :de)).must_equal "Februar, Dienstag"
    I18n.locale = :de

    _(pagy.send(:page_label, 3)).must_equal "Dezember, Mittwoch"
    _(pagy.send(:page_label, 3, format: '%b')).must_equal "Dez"
    _(pagy.send(:page_label, 5)).must_equal "Februar, Dienstag"
    _(pagy.send(:page_label, 5, format: '%b')).must_equal "Feb"
    I18n.locale = :en
  end
end
