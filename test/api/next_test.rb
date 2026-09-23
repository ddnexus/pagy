# frozen_string_literal: true

ENV['PAGY_NEXT'] = 'true'

require 'unit/test_helper'
require 'pagy/classes/request'

describe 'Pagy Next Mode' do
  it 'loads the next module' do
    _(ENV.fetch('PAGY_NEXT', nil)).must_equal 'true'
  end

  describe 'Deprecated :max_pages option' do
    it 'works with Offset' do
      # Confirm the 'max_pages' override is not active
      err = _ { Pagy::Offset.new(page: 10, max_pages: 5) }.must_raise Pagy::NextError
      _(err.message).must_match(':max_pages')
    end

    it 'works with Countless' do
      # Confirm the 'max_pages' override is not active
      err = _ { Pagy::Offset::Countless.new(page: 10, max_pages: 5) }.must_raise Pagy::NextError
      _(err.message).must_match(':max_pages')
    end

    it 'works with Keynav' do
      set = Pet.order(:id)
      err = _ do
                Pagy::Keyset::Keynav.new(set,
                                         page: ['key', 3, 5, [40], [50]],
                                         limit: 10,
                                         max_pages: 4)
              end.must_raise Pagy::NextError
      _(err.message).must_match(':max_pages')
    end
  end

  describe 'Deprecated :client_max_limit option' do
    it 'allows client_limit options' do
      pagy = Pagy::Offset.new(limit: 10, client_limit: 5)
      _(pagy.options[:client_limit]).must_equal 5
    end

    it 'does not warn or translate legacy client_max_limit options' do
      err = _ { Pagy::Offset.new(limit: 10, client_max_limit: 5) }.must_raise Pagy::NextError
      _(err.message).must_match(':client_max_limit')
    end

    it 'does not warn or translate legacy max_limit options' do
      err = _ { Pagy::Offset.new(limit: 10, max_limit: 5) }.must_raise Pagy::NextError
      _(err.message).must_match(':max_limit')
    end

    it 'works with the resolve_limit' do
      limit = Pagy::Request.new({ request: { base_url: 'http://example.com',
                                             params: { 'limit' => 21 } },
                                  client_max_limit: 30 }).resolve_limit
      _(limit).must_equal 20
    end
  end

  describe 'Deprecated Configurable methods' do
    it "works with Pagy.options" do
      # Using 'respond_to?' avoids triggering a NoMethodError
      _(Pagy.respond_to?(:options)).must_equal false
    end

    it "works with Pagy.sync_javascript" do
      _(Pagy.respond_to?(:sync_javascript)).must_equal false
    end
  end
end
