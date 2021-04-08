# frozen_string_literal: true

require_relative '../test_helper'
require 'pagy/extras/countless'

describe Pagy::Countless do

  let(:controller) { MockController.new } # page = 3, items = 20

  describe '#finalize' do

    before do
      @empty_collection = MockCollection.new([])
      @collection = MockCollection.new(Array(1..59))
    end

    let(:last_page) { 3 }

    it 'raises exception with no retrieved items' do
      _(proc { Pagy::Countless.new(page: 2).finalize(0) }).must_raise Pagy::OverflowError
    end

    it 'initializes empty collection' do
      pagy, = controller.send(:pagy_countless, @empty_collection, page: 1)
      _(pagy.items).must_equal 20
      _(pagy.pages).must_equal 1
      _(pagy.last).must_equal 1
      _(pagy.from).must_equal 0
      _(pagy.to).must_equal 0
      _(pagy.prev).must_be_nil
      _(pagy.next).must_be_nil
    end

    it 'initializes first page' do
      pagy, = controller.send(:pagy_countless, @collection, page: 1)
      _(pagy).must_be_instance_of Pagy::Countless
      _(pagy.items).must_equal 20
      _(pagy.last).must_equal 2
      _(pagy.pages).must_equal 2 # current + 1. `Countless` does not know real count
      _(pagy.from).must_equal 1
      _(pagy.to).must_equal 20
      _(pagy.prev).must_be_nil
      _(pagy.next).must_equal 2
    end

    it 'initializes single full page' do
      pagy, = controller.send(:pagy_countless, MockCollection.new(Array(1..20)), page: 1)
      _(pagy.items).must_equal 20
      _(pagy.pages).must_equal 1
      _(pagy.from).must_equal 1
      _(pagy.to).must_equal 20
      _(pagy.prev).must_be_nil
      _(pagy.next).must_be_nil
    end

    it 'initialize single partial page' do
      pagy, = controller.send(:pagy_countless, MockCollection.new(Array(1..4)), page: 1)
      _(pagy.items).must_equal 4
      _(pagy.pages).must_equal 1
      _(pagy.from).must_equal 1
      _(pagy.to).must_equal 4
      _(pagy.prev).must_be_nil
      _(pagy.next).must_be_nil

    end

    it 'initializes last partial page' do
      pagy, = controller.send(:pagy_countless, @collection, page: last_page)
      _(pagy.items).must_equal 19
      _(pagy.pages).must_equal last_page
      _(pagy.from).must_equal 41
      _(pagy.to).must_equal 59
      _(pagy.prev).must_equal(last_page - 1)
      _(pagy.next).must_be_nil
    end

    it 'handles the :cycle variable' do
      pagy, = controller.send(:pagy_countless, @collection, page: last_page, cycle: true)
      _(pagy.items).must_equal 19
      _(pagy.pages).must_equal last_page
      _(pagy.from).must_equal 41
      _(pagy.to).must_equal 59
      _(pagy.prev).must_equal(last_page - 1)
      _(pagy.next).must_equal 1
    end

  end

end
