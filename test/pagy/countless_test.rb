# encoding: utf-8
# frozen_string_literal: true

require_relative '../test_helper'
require 'pagy/extras/countless'

SingleCov.covered! unless ENV['SKIP_SINGLECOV']

describe Pagy::Countless do

  let(:backend) { TestController.new } # page = 3, items = 20

  describe "#finalize" do

    before do
      @empty_collection = TestCollection.new([])
      @collection = TestCollection.new(Array(1..59))
    end

    let(:last_page) { 3 }

    it 'raises exception with no retrieved items' do
      proc { Pagy::Countless.new(page: 2).finalize(0) }.must_raise Pagy::OverflowError
    end

    it 'initializes empty collection' do
      pagy, _ = backend.send(:pagy_countless, @empty_collection, page: 1)
      pagy.items.must_equal 20
      pagy.pages.must_equal 1
      pagy.last.must_equal 1
      pagy.from.must_equal 0
      pagy.to.must_equal 0
      pagy.prev.must_be_nil
      pagy.next.must_be_nil
    end

    it 'initializes first page' do
      pagy, _ = backend.send(:pagy_countless, @collection, page: 1)
      pagy.must_be_instance_of Pagy::Countless
      pagy.items.must_equal 20
      pagy.last.must_equal 2
      pagy.pages.must_equal 2 # current + 1. `Countless` does not know real count
      pagy.from.must_equal 1
      pagy.to.must_equal 20
      pagy.prev.must_be_nil
      pagy.next.must_equal 2
    end

    it 'initializes single full page' do
      pagy, _ = backend.send(:pagy_countless, TestCollection.new(Array(1..20)), page: 1)
      pagy.items.must_equal 20
      pagy.pages.must_equal 1
      pagy.from.must_equal 1
      pagy.to.must_equal 20
      pagy.prev.must_be_nil
      pagy.next.must_be_nil
    end

    it 'initialize single partial page' do
      pagy, _ = backend.send(:pagy_countless, TestCollection.new(Array(1..4)), page: 1)
      pagy.items.must_equal 4
      pagy.pages.must_equal 1
      pagy.from.must_equal 1
      pagy.to.must_equal 4
      pagy.prev.must_be_nil
      pagy.next.must_be_nil

    end

    it 'initializes last partial page' do
      pagy, _ = backend.send(:pagy_countless, @collection, page: last_page)
      pagy.items.must_equal 19
      pagy.pages.must_equal last_page
      pagy.from.must_equal 41
      pagy.to.must_equal 59
      pagy.prev.must_equal(last_page - 1)
      pagy.next.must_be_nil
    end

    it 'handles the :cycle variable' do
      pagy, _ = backend.send(:pagy_countless, @collection, page: last_page, cycle: true)
      pagy.items.must_equal 19
      pagy.pages.must_equal last_page
      pagy.from.must_equal 41
      pagy.to.must_equal 59
      pagy.prev.must_equal(last_page - 1)
      pagy.next.must_equal 1
    end

  end

end
