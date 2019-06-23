# encoding: utf-8
# frozen_string_literal: true

require_relative '../test_helper'


describe Pagy::VariableError do

  describe "#variable and #value" do

    it 'raises for non overflow pages' do
      begin
        Pagy.new(count: 1, page: 0)
      rescue Pagy::VariableError => e
        e.variable.must_equal :page
        e.value.must_equal 0
      end

      begin
        Pagy.new(count: 1, page: -10)
      rescue Pagy::VariableError => e
        e.variable.must_equal :page
        e.value.must_equal(-10)
      end

      begin
        Pagy.new(count: 1, page: 'string')
      rescue Pagy::VariableError => e
        e.variable.must_equal :page
        e.value.must_equal 'string'
      end
    end

    it 'raises for other variables' do
      begin
        Pagy.new(count: -10)
      rescue Pagy::VariableError => e
        e.variable.must_equal :count
        e.value.must_equal(-10)
      end
      begin
        Pagy.new(count: 'string')
      rescue Pagy::VariableError => e
        e.variable.must_equal :count
        e.value.must_equal 'string'
      end
    end

    it 'rescues as ArgumentError (backward compatible)' do
      begin
        Pagy.new(count: 1, page: -10)
      rescue ArgumentError => e
        e.variable.must_equal :page
        e.value.must_equal(-10)
      end

      begin
        Pagy.new(count: 'string')
      rescue ArgumentError => e
        e.variable.must_equal :count
        e.value.must_equal 'string'
      end
    end

  end

end
