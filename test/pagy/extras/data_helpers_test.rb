# frozen_string_literal: true

OJ = %i[without_oj with_oj].freeze
OJ.each do |test|
  require 'oj' if test == :with_oj

  require_relative '../../test_helper'
  require_relative '../../mock_helpers/app'

  Time.zone = 'EST'
  Date.beginning_of_week = :sunday

  describe "pagy_data #{test}" do
    let(:app) { MockApp.new(params: {}) }

    describe "pagy_data #{test}" do
      it "runs #{test}" do
        _(app.pagy_data(Pagy.new(count: 10), :test_function, 'some-string', 123, true)).must_rematch :data_1
      end
    end
  end
end
