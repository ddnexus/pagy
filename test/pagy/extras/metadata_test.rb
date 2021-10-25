# frozen_string_literal: true

require_relative '../../test_helper'
require 'pagy/extras/shared'       # include :sequels in DEFAULT[:metadata]
require 'pagy/extras/countless'
require 'pagy/extras/metadata'
require_relative '../../mock_helpers/controller'
require_relative '../../mock_helpers/collection'

describe 'pagy/extras/metadata' do
  describe '#pagy_metadata' do
    before do
      @controller = MockController.new
      @collection = MockCollection.new
    end
    it 'defines all metadata' do
      _(Pagy::DEFAULT[:metadata]).must_rematch
    end
    it 'returns the full pagy metadata' do
      pagy, _records = @controller.send(:pagy, @collection, metadata: (Pagy::DEFAULT[:metadata])+[:sequels])
      _(@controller.send(:pagy_metadata, pagy)).must_rematch
    end
    it 'checks for unknown metadata' do
      pagy, _records = @controller.send(:pagy, @collection, metadata: %i[page unknown_key])
      _(proc { @controller.send(:pagy_metadata, pagy) }).must_raise Pagy::VariableError
    end
    it 'returns only specific metadata' do
      pagy, _records = @controller.send(:pagy, @collection, metadata: %i[scaffold_url page count prev next pages])
      _(@controller.send(:pagy_metadata, pagy)).must_rematch
    end
  end
end
