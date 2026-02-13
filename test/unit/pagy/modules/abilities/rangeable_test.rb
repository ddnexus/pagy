# frozen_string_literal: true

require 'unit/test_helper'

describe 'Pagy::Offset::Rangeable Specs' do
  # Use an anonymous class to test the mixin without namespace pollution
  let(:rangeable_class) do
    Class.new do
      include Pagy::Offset::Rangeable

      attr_reader :options, :last, :page

      def initialize(in_range_value: true, raise_error: false)
        @in_range_value = in_range_value
        @options = { raise_range_error: raise_error }
        @last = 10
        @page = 15 # out of range for the message
      end

      def check_range
        in_range? { @in_range_value }
      end
    end
  end

  it 'returns true if block returns true' do
    mock = rangeable_class.new(in_range_value: true)
    _(mock.check_range).must_equal true
  end

  it 'raises RangeError if block returns false and option set' do
    mock = rangeable_class.new(in_range_value: false, raise_error: true)
    err = _ { mock.check_range }.must_raise Pagy::RangeError
    _(err.message).must_match 'expected :page in 1..10; got 15'
  end

  it 'returns false if block returns false and option not set' do
    mock = rangeable_class.new(in_range_value: false, raise_error: false)
    _(mock.check_range).must_equal false
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
