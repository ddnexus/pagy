# frozen_string_literal: true

require 'unit/test_helper'

describe 'Pagy::Offset::Shiftable Specs' do
  let(:shiftable_class) do
    Class.new do
      include Pagy::Offset::Shiftable

      attr_accessor :page, :last, :previous, :next

      def run
        assign_previous_and_next
      end
    end
  end

  let(:mock) { shiftable_class.new }

  it 'assigns previous and next for middle page' do
    mock.page = 5
    mock.last = 10
    mock.run
    _(mock.previous).must_equal 4
    _(mock.next).must_equal 6
  end

  it 'assigns nil previous for first page' do
    mock.page = 1
    mock.last = 10
    mock.run
    _(mock.previous).must_be_nil
    _(mock.next).must_equal 2
  end

  it 'assigns nil next for last page' do
    mock.page = 10
    mock.last = 10
    mock.run
    _(mock.previous).must_equal 9
    _(mock.next).must_be_nil
  end

  it 'handles single page (both nil)' do
    mock.page = 1
    mock.last = 1
    mock.run
    _(mock.previous).must_be_nil
    _(mock.next).must_be_nil
  end
end
