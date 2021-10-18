# frozen_string_literal: true

require_relative '../test_helper'
require 'pagy/extras/countless'

describe 'pagy/countless' do
  describe '#finalize' do
    it 'initializes empty collection' do
      pagy, = Pagy::Countless.new(page: 1)
      pagy.finalize(0)
      _(pagy.items).must_equal 20
      _(pagy.pages).must_equal 1
      _(pagy.last).must_equal 1
      _(pagy.in).must_equal 0
      _(pagy.from).must_equal 0
      _(pagy.to).must_equal 0
      _(pagy.prev).must_be_nil
      _(pagy.next).must_be_nil
    end
    it 'initializes first page' do
      pagy, = Pagy::Countless.new(page: 1)
      pagy.finalize(21) # one more page
      _(pagy).must_be_instance_of Pagy::Countless
      _(pagy.items).must_equal 20
      _(pagy.last).must_equal 2
      _(pagy.pages).must_equal 2 # current + 1. `Countless` does not know real count
      _(pagy.in).must_equal 20
      _(pagy.from).must_equal 1
      _(pagy.to).must_equal 20
      _(pagy.prev).must_be_nil
      _(pagy.next).must_equal 2
    end
    it 'initializes single full page' do
      pagy, = Pagy::Countless.new(page: 1)
      pagy.finalize(20) # no more page - last full
      _(pagy.items).must_equal 20
      _(pagy.pages).must_equal 1
      _(pagy.in).must_equal 20
      _(pagy.from).must_equal 1
      _(pagy.to).must_equal 20
      _(pagy.prev).must_be_nil
      _(pagy.next).must_be_nil
    end
    it 'initialize single partial page' do
      pagy, = Pagy::Countless.new(page: 1)
      pagy.finalize(4) # partial page of 4 - also last
      _(pagy.items).must_equal 20
      _(pagy.pages).must_equal 1
      _(pagy.in).must_equal 4
      _(pagy.from).must_equal 1
      _(pagy.to).must_equal 4
      _(pagy.prev).must_be_nil
      _(pagy.next).must_be_nil
    end
    it 'initializes last partial page' do
      pagy, = Pagy::Countless.new(page: 3)
      pagy.finalize(19) # partial page of 4 - also last
      _(pagy.items).must_equal 20
      _(pagy.pages).must_equal 3
      _(pagy.in).must_equal 19
      _(pagy.from).must_equal 41
      _(pagy.to).must_equal 59
      _(pagy.prev).must_equal 2
      _(pagy.next).must_be_nil
    end
    it 'handles the :cycle variable' do
      pagy, = Pagy::Countless.new(page: 3, cycle: true)
      pagy.finalize(19) # partial page of 4 - also last
      _(pagy.items).must_equal 20
      _(pagy.pages).must_equal 3
      _(pagy.in).must_equal 19
      _(pagy.from).must_equal 41
      _(pagy.to).must_equal 59
      _(pagy.prev).must_equal 2
      _(pagy.next).must_equal 1
    end
    it 'raises exception with no retrieved items and page > 1' do
      _ { Pagy::Countless.new(page: 2, overflow: :exception).finalize(0) }.must_raise Pagy::OverflowError
    end
  end
end
