# frozen_string_literal: true

require 'test_helper'
require 'mocks/app'

describe Pagy::OffsetPaginator do
  # We test via the public API provided by the App/Controller mixin (MockApp)
  # which delegates to OffsetPaginator.

  let(:collection) { (1..20).to_a }

  describe 'with Array' do
    it 'paginates array' do
      app = MockApp.new(params: { page: 2 })
      pagy, results = app.pagy(collection, limit: 5)

      _(pagy).must_be_kind_of Pagy::Offset
      _(pagy.count).must_equal 20
      _(pagy.page).must_equal 2
      _(pagy.limit).must_equal 5
      _(results).must_equal [6, 7, 8, 9, 10]
    end

    it 'prioritizes params limit over option limit (when allowed)' do
      # Simulate client requesting limit 5 via params
      app = MockApp.new(params: { page: 1, limit: 5 })

      # Pass limit: 10 as option, but enable client_max_limit to allow client override
      # The params limit (5) should take precedence over the default/option (10)
      pagy, results = app.pagy(collection, limit: 10, client_max_limit: 20)

      _(pagy.page).must_equal 1
      _(pagy.limit).must_equal 5
      _(results).must_equal [1, 2, 3, 4, 5]
    end
  end

  describe 'with ActiveRecord' do
    it 'paginates relation' do
      collection = Pet.order(:id)
      app = MockApp.new(params: { page: 2 })

      pagy, results = app.pagy(collection, limit: 5)

      _(pagy).must_be_kind_of Pagy::Offset
      _(pagy.count).must_equal 50
      _(pagy.page).must_equal 2
      _(pagy.limit).must_equal 5

      # Page 2 (offset 5), limit 5 -> IDs 6..10
      _(results.first.id).must_equal 6
      _(results.last.id).must_equal 10
      _(results).must_be_kind_of ActiveRecord::Relation
    end

    it 'respects existing counts' do
      app = MockApp.new
      collection = Pet.none

      # Force count override via options
      pagy, = app.pagy(collection, count: 1000, limit: 5)

      _(pagy.count).must_equal 1000
      _(pagy.last).must_equal 200
    end
  end

  describe 'with Sequel' do
    it 'paginates dataset' do
      collection = PetSequel.order(:id)
      app = MockApp.new(params: { page: 2 })

      pagy, results = app.pagy(collection, limit: 5)

      _(pagy).must_be_kind_of Pagy::Offset
      _(pagy.count).must_equal 50
      _(pagy.page).must_equal 2
      _(pagy.limit).must_equal 5
      _(pagy.offset).must_equal 5

      rows = results.all
      _(rows.first[:id]).must_equal 6
      _(rows.last[:id]).must_equal 10
      _(results).must_be_kind_of Sequel::Dataset
    end
  end
end
