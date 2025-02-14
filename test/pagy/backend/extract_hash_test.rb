# frozen_string_literal: true

require_relative '../../test_helper'
require_relative '../../mock_helpers/collection'
require_relative '../../files/models'
require_relative '../../mock_helpers/app'

describe 'Extract pagy hash' do
  describe '#pagy_extract_hash for Pagy' do
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
      _(pagy.extract_hash).must_rematch :unset_default
    end
    it 'checks for unknown pluck_keys' do
      pagy, _records = app.send(:pagy_offset, @collection, pluck_keys: %i[page unknown_key])
      _ { pagy.extract_hash }.must_raise Pagy::OptionError
    end
    it 'returns only specific dats_keys' do
      pagy, _records = app.send(:pagy_offset, @collection, pluck_keys: %i[url_template page count previous next pages])
      _(pagy.extract_hash).must_rematch :data
    end
    it 'returns only specific pluck_keys (from helper args)' do
      pagy, _records = app.send(:pagy_offset, @collection)
      _(pagy.extract_hash(pluck_keys: %i[url_template page count previous next pages])).must_rematch :data
    end
    # it 'checks for unknown pluck_keys for Pagy::Calendar::Unit' do
    #   calendar, _pagy, _records = calendar_app.send(:pagy_calendar, Event.all,
    #                                                 year: { pluck_keys: %i[page unknown_key] })
    #     _ { calendar_app.send(:pagy_extract_hash, calendar[:year]) }.must_raise Pagy::OptionError
    # end
    # it 'returns only specific pluck_keys for Pagy::Calendar::Unit' do
    #   calendar, _pagy, _records = calendar_app(params: { month_page: 3 })
    #                               .send(:pagy_calendar, Event.all,
    #                                     month: { pluck_keys: %i[url_template page from to previous next pages] })
    #   _(calendar_app.send(:pagy_extract_hash, calendar[:month])).must_rematch :data
    # end
  end
end
