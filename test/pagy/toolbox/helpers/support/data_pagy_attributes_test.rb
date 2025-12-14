# frozen_string_literal: true

require 'test_helper'
require 'pagy/toolbox/helpers/support/data_pagy_attribute'
require 'json'

# Try to load Oj for the test if available
begin
  require 'oj'
rescue LoadError
  # Proceed without Oj
end

describe 'Pagy#data_pagy_attribute' do
  let(:pagy_class) do
    Class.new(Pagy) do
      public :data_pagy_attribute
    end
  end

  let(:pagy) { pagy_class.new }

  describe 'with Oj' do
    # Skip this block if Oj is not installed/loaded
    next unless defined?(Oj)

    it 'uses Oj to dump data' do
      args = [1, 'oj_test', { 'a' => 1 }]

      # This calls the real Oj.dump(..., mode: :compat)
      result = pagy.data_pagy_attribute(*args)

      encoded = result[/data-pagy="(.+)"/, 1]
      decoded = Pagy::B64.decode(encoded)

      # Verify integrity
      _(JSON.parse(decoded)).must_equal [1, 'oj_test', { 'a' => 1 }]
    end
  end

  describe 'without Oj (JSON fallback)' do
    before do
      # Hide Oj constant to force the `defined?(Oj) ? ... : JSON.dump` else branch
      if Object.const_defined?(:Oj)
        @real_oj = Object.const_get(:Oj)
        Object.send(:remove_const, :Oj)
      end
    end

    after do
      # Restore Oj
      Object.const_set(:Oj, @real_oj) if defined?(@real_oj)
    end

    it 'uses JSON to dump data' do
      args = [1, 'json_test', { 'b' => 2 }]

      # This calls the real JSON.dump
      result = pagy.data_pagy_attribute(*args)

      encoded = result[/data-pagy="(.+)"/, 1]
      decoded = Pagy::B64.decode(encoded)

      # Verify integrity
      _(JSON.parse(decoded)).must_equal [1, 'json_test', { 'b' => 2 }]
    end
  end
end
