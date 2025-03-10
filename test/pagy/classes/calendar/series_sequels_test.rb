# frozen_string_literal: true

require_relative '../../../test_helper'
require_relative '../../../mock_helpers/app'  # just for time zone
require_relative '../../../../gem/lib/pagy/toolbox/methods/support/nav_js' # just to check the sequels

Time.zone = 'EST'
Date.beginning_of_week = :sunday

describe 'Calendar sequels and page_labels' do
  it 'generate the labels for the sequels' do
    steps = { 0 => 5, 600 => 7 }
    pagy = Pagy::Calendar::Month.new(period:  [Time.zone.local(2021, 10, 21, 13, 18, 23, 0),
                                               Time.zone.local(2023, 11, 13, 15, 43, 40, 0)],
                                     steps:   steps,
                                     compact: false,   # to hit the :gap condition in the calendar sequels override
                                     page:    6)
    _(pagy.send(:sequels)).must_rematch :sequels
  end
end
