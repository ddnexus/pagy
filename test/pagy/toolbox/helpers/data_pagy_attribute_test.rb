# frozen_string_literal: true

require 'test_helper'
require 'mock_helpers/app'
require 'mock_helpers/collection'
require 'pagy/toolbox/helpers/support/data_pagy_attribute'

describe 'Pagy data_pagy_attribute' do
  let(:app) { MockApp.new(params: {}) }

  # 1. Test the "Without Oj" scenario first (Simulated)
  describe 'without Oj' do
    before do
      # If Oj is already loaded by another test, hide it deeply
      if defined?(Oj)
        @original_oj = Oj
        Object.send(:remove_const, :Oj)
      end
    end

    after do
      # Restore Oj so we don't break other tests that need it
      Object.const_set(:Oj, @original_oj) if defined?(@original_oj)
    end

    it "runs without_oj" do
      # Verify isolation: Oj should appear missing here
      refute defined?(Oj)

      pagy, = app.pagy(:offset, MockCollection.new, count: 100)
      _(pagy.send(:data_pagy_attribute, :test_function, 'some-string', 123, true)).must_rematch :data_1
    end
  end

  # 2. Test the "With Oj" scenario
  describe 'with Oj' do
    before do
      # Ensure Oj is loaded.
      # If it was hidden by the previous test, the 'after' block above restored it.
      # If it was never loaded, this loads it now.
      require 'oj'
    end

    it "runs with_oj" do
      # Verify environment: Oj must be present
      assert defined?(Oj)

      pagy, = app.pagy(:offset, MockCollection.new, count: 100)
      _(pagy.send(:data_pagy_attribute, :test_function, 'some-string', 123, true)).must_rematch :data_1
    end
  end
end
