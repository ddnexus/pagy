# frozen_string_literal: true

require 'test_helper'

describe Pagy::Offset::Rangeable do
  # Use an anonymous class to test the mixin without namespace pollution
  let(:rangeable_class) do
    Class.new do
      include Pagy::Offset::Rangeable

      attr_reader :options, :last, :page, :empty_vars_assigned

      def initialize(in_range_value: true, raise_error: false)
        @in_range_value = in_range_value
        @options = { raise_range_error: raise_error }
        @last = 10
        @page = 15 # out of range for the message
        @empty_vars_assigned = false
      end

      def check_range
        in_range? { @in_range_value }
      end

      def assign_empty_page_variables
        @empty_vars_assigned = true
      end
    end
  end

  it 'returns true if block returns true' do
    mock = rangeable_class.new(in_range_value: true)
    _(mock.check_range).must_equal true
    _(mock.empty_vars_assigned).must_equal false
  end

  it 'raises RangeError if block returns false and option set' do
    mock = rangeable_class.new(in_range_value: false, raise_error: true)
    err = _ { mock.check_range }.must_raise Pagy::RangeError
    _(err.message).must_match 'expected :page in 1..10; got 15'
  end

  it 'assigns empty vars if block returns false and option not set' do
    mock = rangeable_class.new(in_range_value: false, raise_error: false)
    _(mock.check_range).must_equal false
    _(mock.empty_vars_assigned).must_equal true
  end

  it 'memoizes the result' do
    # First call false
    mock = rangeable_class.new(in_range_value: false)
    _(mock.check_range).must_equal false

    # Change underlying value to true, but memoization should keep it false
    mock.instance_variable_set(:@in_range_value, true)
    _(mock.check_range).must_equal false
  end
end
