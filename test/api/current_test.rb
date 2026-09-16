# frozen_string_literal: true

require 'unit/test_helper'
require 'pagy/classes/request'

describe 'Pagy Deprecated Code' do
  it 'does not load the next module' do
    _(defined?(Pagy::Next)).must_be_nil
  end

  describe 'Deprecated :max_pages option' do
    it 'works with Offset' do
      assert_output(nil, /:max_pages/) do
        options = { count: 100,
                    limit: 10,
                    max_pages: 5,
                    page: 6,
                    raise_range_error: true }
        _ { Pagy::Offset.new(**options) }.must_raise Pagy::RangeError
      end
    end

    it 'works with Countless' do
      assert_output(nil, /:max_pages/) do
        pagy = Pagy::Offset::Countless.new(page: 10, max_pages: 5)
        _(pagy.page).must_equal 5 # clamped
      end
    end

    it 'works with Keynav' do
      assert_output(nil, /:max_pages/) do
        set  = Pet.order(:id)
        pagy = Pagy::Keyset::Keynav.new(set,
                                        page: ['key', 5, 5, [40]],
                                        limit: 10,
                                        max_pages: 4)
        _(pagy.next).must_be_nil
      end
    end
  end

  describe 'Deprecated :client_max_limit option' do
    it 'works with Offset' do
      assert_output(nil, /:client_max_limit/) do
        pagy = Pagy::Offset.new(limit: 10, client_max_limit: 5)
        _(pagy.options[:client_limit]).must_equal 5
        _(pagy.options[:client_max_limit]).must_be_nil
      end
    end

    it 'works with the resolve_limit' do
      assert_output(nil, /:client_max_limit/) do
        limit = Pagy::Request.new({ request: { base_url: 'http://example.com',
                                               params: { 'limit' => 21 }},
                                    client_max_limit: 30 }).resolve_limit
        _(limit).must_equal 21
      end
    end
  end

  describe 'Deprecated :max_limit option' do
    it 'works with Offset' do
      assert_output(nil, /:max_limit/) do
        pagy = Pagy::Offset.new(limit: 10, max_limit: 5)
        _(pagy.options[:client_limit]).must_equal 5
        _(pagy.options[:max_limit]).must_be_nil
      end
    end

    it 'works with the resolve_limit' do
      assert_output(nil, /:max_limit/) do
        limit = Pagy::Request.new({ request: { base_url: 'http://example.com',
                                               params: { 'limit' => 21 }},
                                    max_limit: 30 }).resolve_limit
        _(limit).must_equal 21
      end
    end
  end

  describe 'Deprecated Configurable methods' do
    it "works with Pagy.options" do
      assert_output(nil, /Pagy.options/) do
        Pagy.options
      end
    end

    it "works with Pagy.sync_javascript" do
      assert_output(nil, /Pagy.sync_javascript/) do
        targets = %w[pagy.js pagy.min.js]
        Pagy.sync_javascript(Dir.mktmpdir, *targets)
      end
    end
  end
end
