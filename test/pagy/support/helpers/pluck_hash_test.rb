# frozen_string_literal: true

require_relative '../../../test_helper'
require_relative '../../../mock_helpers/collection'
require_relative '../../../files/models'
require_relative '../../../mock_helpers/app'

describe 'Pluck pagy hash' do
  describe 'pluck_hash for Pagy' do
    let(:app) { MockApp.new }
    before do
      @collection = MockCollection.new
    end
    Time.zone = 'EST'
    def calendar_app(**options)
      MockApp::Calendar.new(**options)
    end

    # Required to test the behaviour of the autoloaded DEFAULT constant
    # that in the real word will not be a problem
    def self.test_order
      :alpha
    end

    it 'works with unset DEFAULT' do
      pagy, _records = app.send(:pagy_offset, @collection)
      _(pagy.pluck_hash).must_rematch :unset_default
    end
    it 'checks for unknown keys' do
      pagy, _records = app.send(:pagy_offset, @collection, keys: %i[page unknown_key])
      _ { pagy.pluck_hash }.must_raise Pagy::OptionError
    end
    it 'returns only specific keys' do
      pagy, _records = app.send(:pagy_offset, @collection, keys: %i[url_template page count previous next pages])
      _(pagy.pluck_hash).must_rematch :data
    end
    it 'returns only specific keys (from helper args)' do
      pagy, _records = app.send(:pagy_offset, @collection)
      _(pagy.pluck_hash(keys: %i[url_template page count previous next pages])).must_rematch :data
    end
    it 'checks for unknown keys for Pagy::Calendar::Unit' do
      calendar, _pagy, _records = calendar_app.send(:pagy_calendar, Event.all,
                                                    year: { keys: %i[page unknown_key] })
      _ { calendar[:year].pluck_hash }.must_raise Pagy::OptionError
    end
    it 'returns only specific keys for Pagy::Calendar::Unit' do
      calendar, _pagy, _records = calendar_app(params: { month_page: 3 })
                                  .send(:pagy_calendar, Event.all,
                                        month: { keys: %i[url_template page from to previous next pages] })
      _(calendar[:month].pluck_hash).must_rematch :data
    end
  end
end
