# frozen_string_literal: true

require_relative '../../test_helper'
require 'pagy/extras/shared'       # include :sequels in DEFAULT[:metadata]
require 'pagy/extras/calendar'
require 'pagy/extras/countless'
require 'pagy/extras/metadata'

require_relative '../../mock_helpers/collection'
require_relative '../../mock_helpers/app'

describe 'pagy/extras/metadata' do
  describe '#pagy_metadata for Pagy' do
    let(:app) { MockApp.new }
    before do
      @collection = MockCollection.new
    end
    it 'defines all metadata' do
      _(Pagy::DEFAULT[:metadata]).must_rematch
    end
    it 'returns the full pagy metadata' do
      pagy, _records = app.send(:pagy, @collection, metadata: (Pagy::DEFAULT[:metadata]) + [:sequels])
      _(app.send(:pagy_metadata, pagy)).must_rematch
    end
    it 'checks for unknown metadata' do
      pagy, _records = app.send(:pagy, @collection, metadata: %i[page unknown_key])
      _ { app.send(:pagy_metadata, pagy) }.must_raise Pagy::VariableError
    end
    it 'returns only specific metadata' do
      pagy, _records = app.send(:pagy, @collection, metadata: %i[scaffold_url page count prev next pages])
      _(app.send(:pagy_metadata, pagy)).must_rematch
    end
  end

  describe '#pagy_metadata for Pagy::Calendar' do
    let(:calendar_app) { MockApp::Calendar.new }
    before do
      @collection = MockCollection::Calendar.new
    end
    it 'checks for unknown metadata for Pagy::Calendar' do
      pagy, _records = calendar_app.send(:pagy_calendar, @collection, metadata: %i[page unknown_key])
      _ { calendar_app.send(:pagy_metadata, pagy) }.must_raise Pagy::VariableError
    end
    it 'returns only specific metadata for Pagy::Calendar' do
      pagy, _records = calendar_app.send(:pagy_calendar, @collection, metadata: %i[scaffold_url page utc_from utc_to prev next pages])
      _(calendar_app.send(:pagy_metadata, pagy)).must_rematch
    end
  end
end
