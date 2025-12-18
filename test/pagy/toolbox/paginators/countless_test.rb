# frozen_string_literal: true

require 'test_helper'
require 'mocks/app'

describe 'Pagy::CountlessPaginator' do
  let(:collection) { Pet.all }

  describe 'with ActiveRecord' do
    it 'paginates with defaults' do
      # MockApp default params: { page: 3 }. Rack converts 3 to "3".
      # options[:page] becomes "3" (String), entering the String branch.
      app = MockApp.new
      pagy, records = app.pagy(:countless, collection)

      _(pagy).must_be_kind_of Pagy::Offset::Countless
      _(pagy.page).must_equal 3
      _(records.size).must_equal 10
    end

    it 'handles integer page option (skips string parsing)' do
      # Pass page as Integer via options.
      # options[:page] is 2. is_a?(String) is false.
      app = MockApp.new(params: {})
      pagy, records = app.pagy(:countless, collection, page: 2)

      _(pagy.page).must_equal 2
      _(records.size).must_equal 20
    end

    it 'handles string page param with last hint' do
      # Simulate "2 5" (page 2, last known 5)
      app = MockApp.new(params: { page: '2 5' })
      pagy, records = app.pagy(:countless, collection)

      _(pagy.page).must_equal 2
      _(pagy.last).must_equal 5
      _(records.size).must_equal 20
      _(records.first.id).must_equal 21
    end

    it 'handles string page param without last hint' do
      app = MockApp.new(params: { page: '2' })
      pagy, records = app.pagy(:countless, collection)

      _(pagy.page).must_equal 2
      _(pagy.last).must_equal 3
      _(records.size).must_equal 20
    end
  end

  describe 'with Sequel' do
    it 'paginates dataset' do
      app = MockApp.new(params: { page: 2 })
      pagy, records = app.pagy(:countless, PetSequel.dataset)

      _(pagy).must_be_kind_of Pagy::Offset::Countless
      _(pagy.page).must_equal 2
      _(records.count).must_equal 20
    end
  end
end
