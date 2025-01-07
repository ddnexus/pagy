# frozen_string_literal: true

require_relative '../../test_helper'
require 'pagy/extras/calendar'
require 'pagy/extras/metadata'

require_relative '../../mock_helpers/collection'
require_relative '../../files/models'
require_relative '../../mock_helpers/app'

describe 'pagy/extras/metadata' do
  describe '#pagy_metadata for Pagy' do
    let(:app) { MockApp.new }
    before do
      @collection = MockCollection.new
    end
    it 'defines all metadata' do
      _(Pagy::DEFAULT[:metadata]).must_rematch :metadata
    end
    it 'checks for unknown metadata' do
      pagy, _records = app.send(:pagy, @collection, metadata: %i[page unknown_key])
      _ { app.send(:pagy_metadata, pagy) }.must_raise Pagy::VariableError
    end
    it 'returns only specific metadata' do
      pagy, _records = app.send(:pagy, @collection, metadata: %i[url_template page count prev next pages])
      _(app.send(:pagy_metadata, pagy)).must_rematch :metadata
    end
  end

  describe '#pagy_metadata for Pagy::Offset::Calendar' do
    Time.zone = 'EST'
    def calendar_app(**opts)
      MockApp::Calendar.new(**opts)
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
