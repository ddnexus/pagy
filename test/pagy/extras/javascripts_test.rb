# frozen_string_literal: true

require_relative '../../test_helper'
require_relative '../../mock_helpers/app'

OJ = %i[without_oj with_oj].freeze
OJ.each do |test|
  require 'oj' if test == :with_oj

  Time.zone = 'EST'
  Date.beginning_of_week = :sunday

  describe 'pagy/frontend/javascript_json' do
    let(:app) { MockApp.new(params: {}) }

    describe "pagy_data #{test}" do
      it "runs #{test}" do
        _(app.pagy_data(Pagy::Offset.new(count: 10), :test_function, 'some-string', 123, true)).must_rematch :data_1
      end
    end
    describe "Calendar sequels and label_sequels #{test}" do
      it 'generate the labels for the sequels' do
        steps = { 0 => 5, 600 => 7 }
        pagy = Pagy::Offset::Calendar.send(:create, :month,
                                           period: [Time.zone.local(2021, 10, 21, 13, 18, 23, 0),
                                                    Time.zone.local(2023, 11, 13, 15, 43, 40, 0)],
                                           steps: steps,
                                           ends: true,   # to hit the :gap condition in the calendar sequels override
                                           page: 6)
        _(pagy.sequels).must_rematch :sequels
      end
    end
  end
end
