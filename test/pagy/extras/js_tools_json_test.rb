# frozen_string_literal: true

require_relative '../../test_helper'
require 'pagy/extras/calendar'
require 'pagy/extras/js_tools'

require_relative '../../mock_helpers/app'

Time.zone = 'EST'
Date.beginning_of_week = :sunday

describe 'pagy/extras/js_tools_json' do
  let(:app) { MockApp.new(params: {}) }

  describe '#pagy_data' do
    it 'uses json' do
      _(app.pagy_data(Pagy.new(count: 10), :test_function, 'some-string', 123, true)).must_rematch :data
    end
  end

  describe 'Calendar sequels and label_sequels' do
    it 'generate the labels for the sequels' do
      steps = { 0 => [1, 2, 2, 1], 600 => [1, 3, 3, 1] }
      pagy = Pagy::Calendar.create(:month,
                                   period: [Time.zone.local(2021, 10, 21, 13, 18, 23, 0),
                                            Time.zone.local(2023, 11, 13, 15, 43, 40, 0)],
                                   steps: steps, page: 3)
      _(pagy.sequels).must_rematch :sequels
      _(pagy.label_sequels).must_rematch :label_sequels
    end
  end
end
