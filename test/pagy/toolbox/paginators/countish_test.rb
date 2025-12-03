# frozen_string_literal: true

require_relative '../../../test_helper'
require_relative '../../../mock_helpers/collection'
require_relative '../../../mock_helpers/app'

describe 'Countish special options' do
  let(:app) { MockApp.new }

  before do
    @collection = MockCollection.new
  end
  it 'uses memoized count from page param without ttl' do
    app = MockApp.new(params: {page: '2 500'})
    pagy, _records = app.send(:pagy, :countish, @collection)

    _(pagy.page).must_equal 2
    _(pagy.count).must_equal 500 # Uses memoized count, not 1000 from collection
    _(pagy.options[:epoch]).must_be_nil
    _(pagy.send(:compose_page_param, 3)).must_equal '3+500'
  end
  it 'uses memoized count and preserves epoch when within ttl window' do
    now   = Time.now.to_i
    epoch = now - 10
    app   =  MockApp.new(params: {page: "2 500 #{epoch}"})  # format: "page count epoch"
    pagy, _records = app.send(:pagy, :countish, @collection, ttl: 60)

    _(pagy.count).must_equal 500
    _(pagy.options[:epoch]).must_equal epoch
    _(pagy.send(:compose_page_param, 3)).must_equal "3+500+#{epoch}"
  end
  it 'recounts and resets epoch when memoized epoch is expired' do
    now   = Time.now.to_i
    epoch = now - 70 # Expired (> 60s)
    app   =  MockApp.new(params: {page: "2 500 #{epoch}"})

    pagy, _records = app.send(:pagy, :countish, @collection, ttl: 60)

    _(pagy.count).must_equal 1000 # Fetches fresh count
    _(pagy.options[:epoch]).must_be_close_to now, 1 # Resets epoch to now
    _(pagy.send(:compose_page_param, 3)).must_match '3+1000+'
  end
  it 'recounts when passed count and memoized epoch is ongoing' do
    now   = Time.now.to_i
    epoch = now + 30 # ongoing
    app   =  MockApp.new(params: {page: "2 500 #{epoch}"})

    pagy, _records = app.send(:pagy, :countish, @collection, count: 300, ttl: 60)

    _(pagy.count).must_equal 300 # Fetches fresh count
    _(pagy.options[:epoch]).must_be_close_to (now = Time.now.to_i), 1 # Resets epoch to now, 1 # Resets epoch to now
    _(pagy.send(:compose_page_param, 3)).must_equal "3+300+#{now}"
  end
  it 'recounts when memoized epoch is in the future (tampering protection)' do
    now   = Time.now.to_i
    epoch = now + 100 # Future
    app   =  MockApp.new(params: {page: "2 500 #{epoch}"})

    pagy, _records = app.send(:pagy, :countish, @collection, ttl: 60)

    _(pagy.count).must_equal 1000
    _(pagy.options[:epoch]).must_be_close_to now, 1
    _(pagy.send(:compose_page_param, 3)).must_equal "3+1000+#{now}"
  end
  it 'recount without ttl (first page)' do
    app = MockApp.new(params: {page: ''})
    pagy, _records = app.send(:pagy, :countish, @collection)

    _(pagy.count).must_equal 1000
    _(pagy.options[:epoch]).must_be_nil
    _(pagy.send(:compose_page_param, 3)).must_equal "3+1000"
  end
end
