# frozen_string_literal: true

require_relative '../../../test_helper'
require_relative '../../../mock_helpers/app'
require_relative '../../../mock_helpers/collection'
require_relative '../../../../gem/lib/pagy/toolbox/methods/support/data_pagy_attribute'

OJ = %i[without_oj with_oj].freeze
describe 'Pagy data_pagy_attribute' do
  OJ.each do |test|
    require 'oj' if test == :with_oj

    describe "data_pagy Attribute #{test} " do
      let(:app) { MockApp.new(params: {}) }

      describe "data_pagy_attribute #{test}" do
        it "runs #{test}" do
          pagy, = app.send(:pagy, :offset, MockCollection.new, count: 100)
          _(pagy.send(:data_pagy_attribute, :test_function, 'some-string', 123, true)).must_rematch :data_1
        end
      end
    end
  end
end
