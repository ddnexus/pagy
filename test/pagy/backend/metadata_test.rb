# frozen_string_literal: true

require_relative '../../test_helper'
require_relative '../../mock_helpers/collection'
require_relative '../../files/models'
require_relative '../../mock_helpers/app'

describe 'metadata' do
  describe '#pagy_metadata for Pagy' do
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

    # This must be the firt one, because it works with the DEFAULT[:metadata] not yet autoloaded (alpha order test required)
    it 'works with unset DEFAULT' do
      pagy, _records = app.send(:pagy_offset, @collection)
      _(app.send(:pagy_metadata, pagy)).must_rematch :unset_default
    end
    it 'checks for unknown metadata' do
      pagy, _records = app.send(:pagy_offset, @collection, metadata: %i[page unknown_key])
      _ { app.send(:pagy_metadata, pagy) }.must_raise Pagy::VariableError
    end
    it 'returns only specific metadata' do
      pagy, _records = app.send(:pagy_offset, @collection, metadata: %i[url_template page count prev next pages])
      _(app.send(:pagy_metadata, pagy)).must_rematch :metadata
    end
    # It permanently changes the  DEFAULT from now on (alpha order test required)
    it 'works with set DEFAULT' do
      Pagy::DEFAULT[:metadata] = %i[url_template page count prev next pages]
      pagy, _records = app.send(:pagy_offset, @collection)
      _(app.send(:pagy_metadata, pagy)).must_rematch :set_default
    end
    it 'checks for unknown metadata for Pagy::Offset::Calendar' do
      calendar, _pagy, _records = calendar_app.send(:pagy_calendar, Event.all,
                                                    year: { metadata: %i[page unknown_key] })
      _ { calendar_app.send(:pagy_metadata, calendar[:year]) }.must_raise Pagy::VariableError
    end
    it 'returns only specific metadata for Pagy::Offset::Calendar' do
      calendar, _pagy, _records = calendar_app(params: { month_page: 3 })
                                  .send(:pagy_calendar, Event.all,
                                        month: { metadata: %i[url_template page from to prev next pages] })
      _(calendar_app.send(:pagy_metadata, calendar[:month])).must_rematch :metadata
    end
  end
end
