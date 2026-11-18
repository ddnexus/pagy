# frozen_string_literal: true

require 'unit/test_helper'
require 'mocks/app'
require 'pagy/modules/b64'

describe 'Pagy::KeynavJsPaginator Specs' do
  let(:collection) { Pet.order(:id) }

  it 'paginates with defaults (page 1)' do
    app = MockApp.new(params: {})
    pagy, records = app.pagy(:keynav_js, collection, limit: 10)

    _(pagy).must_be_kind_of Pagy::Keyset::Keynav
    _(records.size).must_equal 10
    _(pagy.next).must_equal 2
  end

  it 'paginates page 2 with token' do
    # Token structure from JS: [browserId, storageKey, pageNum, last, priorCutoff, pageCutoff]
    # browserId: 'secret_key' (must match cookie)
    # storageKey: 'store_key'
    # pageNum: 2
    # last: 2
    # priorCutoff: [10] (ID of last item on page 1)
    # pageCutoff: nil (current page)
    secret = 'secret_key'
    token_json = [secret, 'store_key', 2, 2, [10], nil].to_json
    token = Pagy::B64.urlsafe_encode(token_json)

    # Must pass the matching cookie 'pagy' => 'secret_key'
    app = MockApp.new(params: { page: token }, cookies: { pagy: secret })
    pagy, records = app.pagy(:keynav_js, collection, limit: 10)

    _(records.first.id).must_equal 11
    _(pagy.page).must_equal 2
  end

  it 'resets pagination if cookie mismatches' do
    secret = 'expected_key'
    token_json = [secret, 'store_key', 2, 2, [10], nil].to_json
    token = Pagy::B64.urlsafe_encode(token_json)

    # Request sends 'wrong_key' -> Mismatch -> Security Reset to page 1
    app = MockApp.new(params: { page: token }, cookies: { pagy: 'wrong_key' })

    pagy, records = app.pagy(:keynav_js, collection, limit: 10)

    # Should reset to page 1
    _(pagy.page).must_equal 1
    _(records.first.id).must_equal 1
  end

  it 'resets pagination if the cookie is missing' do
    # A null browserId must not match the missing cookie
    token = Pagy::B64.urlsafe_encode([nil, 'store_key', 2, 2, [10], nil].to_json)
    app   = MockApp.new(params: { page: token })

    pagy, records = app.pagy(:keynav_js, collection, limit: 10)

    _(pagy.page).must_equal 1
    _(records.first.id).must_equal 1
  end

  it 'treats a page param that is not an array as first page' do
    [5, 'key', true, { key: 1 }].each do |not_array|
      token = Pagy::B64.urlsafe_encode(not_array.to_json)
      app   = MockApp.new(params: { page: token }, cookies: { pagy: 'key' })

      pagy, records = app.pagy(:keynav_js, collection, limit: 10)

      _(pagy.page).must_equal 1
      _(records.first.id).must_equal 1
    end
  end

  it 'does not reflect a malformed last in the helpers' do
    injection = '"><img src=x onerror=alert(1)>'
    token     = Pagy::B64.urlsafe_encode(['key', 'store_key', 1, injection, nil, [50]].to_json)
    app       = MockApp.new(params: { page: token }, cookies: { pagy: 'key' })

    pagy, = app.pagy(:keynav_js, collection, limit: 10)

    _(pagy.page).must_equal 1
    _(pagy.last).must_equal 2 # the cutoff of the restarted page 1 has been added
    _(pagy.info_tag).wont_include injection
    _(pagy.input_nav_js).wont_include injection
  end

  it 'limits the records of a forged cutoff' do
    token = Pagy::B64.urlsafe_encode(['key', 'store_key', 1, 2, nil, [1_000_000], nil].to_json)
    app   = MockApp.new(params: { page: token }, cookies: { pagy: 'key' })

    pagy, records = app.pagy(:keynav_js, collection, limit: 10)

    _(pagy.page).must_equal 1
    _(records.size).must_equal 10
  end

  it 'falls back to Countless if page param contains space' do
    # '2 3' simulates a legacy/countless style param
    app = MockApp.new(params: { page: '2 3' })

    pagy, _records = app.pagy(:keynav_js, collection, limit: 10)

    _(pagy).must_be_kind_of Pagy::Offset::Countless
  end

  it 'treats malformed base64 page param as first page' do
    # Garbage that fails Base64.urlsafe_decode64 (raises ArgumentError)
    app = MockApp.new(params: { page: 'NOT_BASE64' })

    pagy, records = app.pagy(:keynav_js, collection, limit: 10)

    _(pagy).must_be_kind_of Pagy::Keyset::Keynav
    _(pagy.page).must_equal 1
    _(records.first.id).must_equal 1
  end

  it 'treats malformed JSON page param as first page' do
    # Valid base64 of "hello" but not valid JSON (raises JSON::ParserError)
    app = MockApp.new(params: { page: 'aGVsbG8' })

    pagy, records = app.pagy(:keynav_js, collection, limit: 10)

    _(pagy).must_be_kind_of Pagy::Keyset::Keynav
    _(pagy.page).must_equal 1
    _(records.first.id).must_equal 1
  end
end
