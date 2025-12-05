# frozen_string_literal: true

require 'test_helper'
require 'mock_helpers/collection'
require 'files/models'
require 'mock_helpers/app'

describe 'data_hash for Pagy' do
  let(:app) { MockApp.new }
  before do
    @collection = MockCollection.new
  end
  Time.zone = 'Etc/UTC'
  def calendar_app(**options)
    MockApp::Calendar.new(**options)
  end

  # Required to test the behaviour of the autoloaded DEFAULT constant
  # that in the real word will not be a problem
  def self.test_order
    :alpha
  end

  it 'works with unset DEFAULT' do
    pagy, _records = app.pagy(:offset, @collection)
    _(pagy.data_hash.keys).must_rematch :unset_default
  end
  it 'checks for unknown keys' do
    pagy, _records = app.pagy(:offset, @collection, data_keys: %i[page unknown_key])

    _ { pagy.data_hash }.must_raise Pagy::OptionError
  end
  it 'returns only specific keys' do
    pagy, _records = app.pagy(:offset, @collection, data_keys: %i[url_template page count previous next last])
    _(pagy.data_hash).must_rematch :data
  end
  it 'returns only specific keys (from helper args)' do
    pagy, _records = app.pagy(:offset, @collection)
    _(pagy.data_hash(data_keys: %i[url_template page count previous next last])).must_rematch :data
  end
  it 'checks for unknown keys for Pagy::Calendar::Unit' do
    calendar, _pagy, _records = calendar_app.pagy(:calendar, Event.all,
                                                  year: { data_keys: %i[page unknown_key] })

    _ { calendar[:year].data_hash }.must_raise Pagy::OptionError
  end
  it 'returns only specific keys for Pagy::Calendar::Unit' do
    calendar, _pagy, _records = calendar_app(params: { month_page: 3 })
                                .pagy(:calendar, Event.all,
                                      month: { data_keys: %i[url_template page from to previous next last] })
    _(calendar[:month].data_hash).must_rematch :data
  end
end
