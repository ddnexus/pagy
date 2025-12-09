# frozen_string_literal: true

require 'test_helper'
require 'mocks/app'
require 'db/models'

describe 'Pagy::KeysetPaginator' do
  # We test via the public API provided by the App/Controller mixin (MockApp)
  # which delegates to KeysetPaginator when the first argument is :keyset.

  describe 'with ActiveRecord' do
    let(:collection) { Pet.order(:id) }

    it 'paginates using request defaults (first page)' do
      # Initialize with empty params (page=nil) to indicate first page
      app = MockApp.new(params: {})

      pagy, records = app.pagy(:keyset, collection, limit: 5)

      _(pagy).must_be_kind_of Pagy::Keyset
      _(pagy.limit).must_equal 5
      _(records.size).must_equal 5
      _(records.first.id).must_equal 1
      _(records.last.id).must_equal 5
    end

    it 'paginates using request page token' do
      # 1. Manually get a token for page 2
      p1 = Pagy::Keyset.new(collection, limit: 5)
      token = p1.next
      _(token).wont_be_nil

      # 2. Simulate request with token
      app = MockApp.new(params: { page: token })

      _pagy, records = app.pagy(:keyset, collection, limit: 5)

      _(records.first.id).must_equal 6
    end

    it 'prioritizes options[:page] over request' do
      # Token for page 2
      p1 = Pagy::Keyset.new(collection, limit: 5)
      token = p1.next

      # Request says nil (page 1 via empty params), Options says token (page 2)
      app = MockApp.new(params: {})

      _pagy, records = app.pagy(:keyset, collection, page: token, limit: 5)

      _(records.first.id).must_equal 6
    end
  end

  describe 'with Sequel' do
    let(:collection) { PetSequel.order(:id) }

    it 'paginates using request defaults' do
      app = MockApp.new(params: {})

      pagy, records = app.pagy(:keyset, collection, limit: 5)

      _(pagy).must_be_kind_of Pagy::Keyset
      _(records.count).must_equal 5
      _(records.first[:id]).must_equal 1
    end

    it 'paginates using request page token' do
      # 1. Get token
      p1 = Pagy::Keyset.new(collection, limit: 5)
      token = p1.next

      # 2. Request with token
      app = MockApp.new(params: { page: token })

      _pagy, records = app.pagy(:keyset, collection, limit: 5)

      _(records.first[:id]).must_equal 6
    end
  end
end
