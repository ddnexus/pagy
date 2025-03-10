# frozen_string_literal: true

require_relative '../../test_helper'
require_relative '../../mock_helpers/pagy_buggy'

describe 'Pagy Exceptions' do
  describe 'option and value' do
    it 'raises for wrong page type' do
      begin
        Pagy::Offset.new(count: 1, page: 0)
      rescue Pagy::OptionError => e
        _(e.option).must_equal :page
        _(e.value).must_equal 0
      end

      begin
        Pagy::Offset.new(count: 1, page: -10)
      rescue Pagy::OptionError => e
        _(e.option).must_equal :page
        _(e.value).must_equal(-10)
      end

      begin
        Pagy::Offset.new(count: 1, page: 'string')
      rescue Pagy::OptionError => e
        _(e.option).must_equal :page
        _(e.value).must_equal 'string'
      end

      begin
        Pagy::Offset.new(count: 1, page: {})
      rescue Pagy::OptionError => e
        _(e.option).must_equal :page
        _(e.value).must_equal({})
      end
    end

    it 'raises for other options' do
      Pagy::Offset.new(count: -10)
    rescue Pagy::OptionError => e
      _(e.option).must_equal :count
      _(e.value).must_equal(-10)
    end
    it 'rescues as ArgumentError' do
      Pagy::Offset.new(count: 1, page: -10)
    rescue ArgumentError => e
      _(e.option).must_equal :page
      _(e.value).must_equal(-10)
    end
    it 'does not raise for :count and :offset set to arbitrary strings (converted to 0)' do
      pagy = Pagy::Offset.new(count: 'string')
      _(pagy).must_be_instance_of Pagy::Offset
      _(pagy.count).must_equal 0
    end
  end
end
