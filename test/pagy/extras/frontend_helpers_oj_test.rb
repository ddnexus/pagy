# frozen_string_literal: true

require 'oj'
require_relative '../../test_helper'
require 'pagy/extras/calendar'
require 'pagy/extras/frontend_helpers'

require_relative '../../mock_helpers/app'

describe 'pagy/extras/frontend_helpers_oj' do
  let(:app) { MockApp.new(params: {}) }

  describe '#pagy_json_attr' do
    it 'uses oj' do
      _(app.pagy_json_attr(Pagy.new(count: 10), :test_function, 'some-string', 123, true)).must_rematch
      _(app.pagy_json_attr(Pagy.new(count: 10, trim_extra: true), :test_function, 'some-string', 123, true)).must_rematch
    end
  end

  describe '#pagy_marked_link' do
    it 'returns only the "standard" link' do
      pagy = Pagy.new(count: 100, page: 4)
      _(app.pagy_marked_link(app.pagy_link_proc(pagy))).must_rematch
      pagy = Pagy.new(count: 100, page: 4, page_param: 'p')
      _(app.pagy_marked_link(app.pagy_link_proc(pagy))).must_rematch
    end
  end

  describe 'Calendar sequels and label_sequels' do
    it 'generate the labels for the sequels' do
      steps = { 0 => [1, 2, 2, 1], 600 => [1, 3, 3, 1] }
      pagy = Pagy::Calendar.create(:month,
                                   minmax: [Time.new(2021, 10, 21, 13, 18, 23, 0), Time.new(2023, 11, 13, 15, 43, 40, 0)],
                                   steps: steps, page: 3)
      _(pagy.sequels).must_rematch
      _(pagy.label_sequels).must_rematch
    end
  end
end
