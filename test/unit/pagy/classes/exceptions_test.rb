# frozen_string_literal: true

require 'unit/test_helper'

describe 'Pagy::OptionError Specs' do
  it 'inherits from ArgumentError' do
    _(Pagy::OptionError.superclass).must_equal ArgumentError
  end

  it 'initializes with pagy, option, description, and value' do
    pagy_mock = Object.new
    error = Pagy::OptionError.new(pagy_mock, :limit, 'to be > 0', 0)

    _(error.pagy).must_equal pagy_mock
    _(error.option).must_equal :limit
    _(error.value).must_equal 0
    _(error.message).must_equal 'expected :limit to be > 0; got 0'
  end
end

describe 'Pagy::RangeError Specs' do
  it 'inherits from OptionError' do
    _(Pagy::RangeError.superclass).must_equal Pagy::OptionError
  end

  it 'behaves like OptionError' do
    error = Pagy::RangeError.new(nil, :page, 'to be < 10', 11)
    _(error.message).must_equal 'expected :page to be < 10; got 11'
  end
end

describe 'Pagy::RailsI18nLoadError Specs' do
  it 'inherits from LoadError' do
    _(Pagy::RailsI18nLoadError.superclass).must_equal LoadError
  end
end

describe 'Pagy::InternalError Specs' do
  it 'inherits from StandardError' do
    _(Pagy::InternalError.superclass).must_equal StandardError
  end
end
