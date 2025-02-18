# frozen_string_literal: true

require_relative '../../../test_helper'
require_relative '../../../mock_helpers/app'
require_relative '../../../mock_helpers/collection'
require_relative '../../../../gem/lib/pagy/resources/components/utils/data_pagy_attribute'

OJ = %i[without_oj with_oj].freeze
OJ.each do |test|
  require 'oj' if test == :with_oj

  describe 'features and ' do
    let(:app) { MockApp.new(params: {}) }

    describe "data_pagy_attribute #{test}" do
      it "runs #{test}" do
        pagy, = app.send(:pagy_offset, MockCollection.new, count: 100)
        _(pagy.send(:data_pagy_attribute, :test_function, 'some-string', 123, true)).must_rematch :data_1
      end
    end
  end
end
