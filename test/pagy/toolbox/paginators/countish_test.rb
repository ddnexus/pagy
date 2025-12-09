# frozen_string_literal: true

require 'test_helper'
require 'mocks/app'
require 'db/models'

describe 'Pagy::CountishPaginator' do
  let(:collection) { Pet.all }
  let(:paginator) { Pagy::CountishPaginator }

  describe 'with ActiveRecord' do
    it 'paginates with defaults (recount)' do
      # No page param -> Page 1, Count calculated from DB
      app = MockApp.new(params: {})
      pagy, records = app.pagy(:countish, collection)

      _(pagy).must_be_kind_of Pagy::Offset::Countish
      _(pagy.count).must_equal 50
      _(pagy.page).must_equal 1
      _(records.size).must_equal 20
    end

    it 'uses cached count without TTL (ongoing)' do
      # Param "2 100" -> Page 2, Count 100
      app = MockApp.new(params: { page: '2 100' })

      # Force DB count to be different (0) to prove we used the cached value
      Pet.stub :count, 0 do
        pagy, records = app.pagy(:countish, collection)

        _(pagy.count).must_equal 100
        _(pagy.page).must_equal 2
        # Records are fetched based on page 2
        _(records.first.id).must_equal 21
      end
    end

    it 'uses cached count with valid TTL (ongoing)' do
      now = Time.now.to_i
      # Param "2 100 <now>" -> Page 2, Count 100, Epoch <now>
      page_param = "2 100 #{now}"
      app        = MockApp.new(params: { page: page_param })

      Pet.stub :count, 0 do
        # ttl: 100. now is within [now, now+100)
        pagy, = app.pagy(:countish, collection, ttl: 100)

        _(pagy.count).must_equal 100
        _(pagy.options[:epoch]).must_equal now
      end
    end

    it 'recounts when TTL expired' do
      now = Time.now.to_i
      # Epoch is (now - 200). TTL is 100. Expired.
      epoch      = now - 200
      page_param = "2 100 #{epoch}"

      app   = MockApp.new(params: { page: page_param })
      pagy, = app.pagy(:countish, collection, ttl: 100)

      # Should ignore 100 and use real count 50
      _(pagy.count).must_equal 50
      # Should reset epoch to now
      _(pagy.options[:epoch]).must_equal now
    end

    it 'recounts when epoch is missing but TTL required' do
      # Param has count but no epoch
      page_param = "2 100"
      app        = MockApp.new(params: { page: page_param })
      pagy,      = app.pagy(:countish, collection, ttl: 100)

      _(pagy.count).must_equal 50
      _(pagy.options[:epoch]).wont_be_nil
    end

    it 'uses options[:count] if provided (overrides param)' do
      # Param says 100, Options says 200
      app   = MockApp.new(params: { page: '2 100' })
      pagy, = app.pagy(:countish, collection, count: 200)

      _(pagy.count).must_equal 200
    end
  end

  describe 'with Sequel' do
    it 'paginates dataset' do
      app = MockApp.new(params: { page: '2 50' })
      pagy, records = app.pagy(:countish, PetSequel.dataset)

      _(pagy).must_be_kind_of Pagy::Offset::Countish
      _(pagy.count).must_equal 50
      _(records.count).must_equal 20
    end
  end
end
