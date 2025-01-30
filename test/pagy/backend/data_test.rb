# frozen_string_literal: true

require_relative '../../test_helper'
require_relative '../../mock_helpers/collection'
require_relative '../../files/models'
require_relative '../../mock_helpers/app'

describe 'Pagy data' do
  describe '#pagy_data for Pagy' do
    let(:app) { MockApp.new }
    before do
      @collection = MockCollection.new
    end
    Time.zone = 'EST'
    def calendar_app(**opts)
      MockApp::Calendar.new(**opts)
    end

    # Required to test the behaviour of the autoloaded DEFAULT constant
    # that in the real word will not be a problem
    def self.test_order
      :alpha
    end

    it 'works with unset DEFAULT' do
      pagy, _records = app.send(:pagy_offset, @collection)
      _(app.send(:pagy_data, pagy)).must_rematch :unset_default
    end
    it 'checks for unknown data_keys' do
      pagy, _records = app.send(:pagy_offset, @collection, data_keys: %i[page unknown_key])
      _ { app.send(:pagy_data, pagy) }.must_raise Pagy::OptionError
    end
    it 'returns only specific dats_keys' do
      pagy, _records = app.send(:pagy_offset, @collection, data_keys: %i[url_template page count prev next pages])
      _(app.send(:pagy_data, pagy)).must_rematch :data
    end
    it 'returns only specific data_keys (from helper args)' do
      pagy, _records = app.send(:pagy_offset, @collection)
      _(app.send(:pagy_data, pagy, data_keys: %i[url_template page count prev next pages])).must_rematch :data
    end
    it 'checks for unknown data_keys for Pagy::Calendar::Unit' do
      calendar, _pagy, _records = calendar_app.send(:pagy_calendar, Event.all,
                                                    year: { data_keys: %i[page unknown_key] })
      _ { calendar_app.send(:pagy_data, calendar[:year]) }.must_raise Pagy::OptionError
    end
    it 'returns only specific data_keys for Pagy::Calendar::Unit' do
      calendar, _pagy, _records = calendar_app(params: { month_page: 3 })
                                  .send(:pagy_calendar, Event.all,
                                        month: { data_keys: %i[url_template page from to prev next pages] })
      _(calendar_app.send(:pagy_data, calendar[:month])).must_rematch :data
    end
  end
end
