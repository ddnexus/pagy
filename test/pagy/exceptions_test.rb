# frozen_string_literal: true

require_relative '../test_helper'

describe Pagy::VariableError do

  describe '#variable and #value' do

    it 'raises for non overflow pages' do
      begin
        Pagy.new(count: 1, page: 0)
      rescue Pagy::VariableError => e
        _(e.variable).must_equal :page
        _(e.value).must_equal 0
      end

      begin
        Pagy.new(count: 1, page: -10)
      rescue Pagy::VariableError => e
        _(e.variable).must_equal :page
        _(e.value).must_equal(-10)
      end

      begin
        Pagy.new(count: 1, page: 'string')
      rescue Pagy::VariableError => e
        _(e.variable).must_equal :page
        _(e.value).must_equal 'string'
      end
    end

    it 'raises for other variables' do
      Pagy.new(count: -10)
    rescue Pagy::VariableError => e
      _(e.variable).must_equal :count
      _(e.value).must_equal(-10)
    end

    it 'rescues as ArgumentError' do
      Pagy.new(count: 1, page: -10)
    rescue ArgumentError => e
      _(e.variable).must_equal :page
      _(e.value).must_equal(-10)
    end

    it 'does not raise for :count and :offset set to arbitrary strings (converted to 0)' do
      pagy = Pagy.new(count: 'string', outset: 'string')
      _(pagy).must_be_instance_of Pagy
      _(pagy.count).must_equal 0
      _(pagy.instance_variable_get(:@outset)).must_equal 0
    end

  end

end
