# frozen_string_literal: true

require_relative '../../test_helper'
require 'pagy/extras/shared'       # include :sequels in VARS[:metadata]
require 'pagy/extras/metadata'
require 'pagy/countless'

describe 'pagy/extras/metadata' do

  describe '#pagy_metadata' do
    before do
      @controller = MockController.new
      @collection = MockCollection.new
    end
    it 'defines all metadata' do
      _(Pagy::VARS[:metadata]).must_rematch
    end
    it 'returns the full pagy metadata' do
      pagy, _records = @controller.send(:pagy, @collection)
      _(@controller.send(:pagy_metadata, pagy)).must_rematch
    end
    it 'checks for unknown metadata' do
      pagy, _records = @controller.send(:pagy, @collection, metadata: %i[page unknown_key])
      _(proc { @controller.send(:pagy_metadata, pagy)}).must_raise Pagy::VariableError
    end
    it 'returns only specific metadata' do
      pagy, _records = @controller.send(:pagy, @collection, metadata: %i[scaffold_url page count prev next pages])
      _(@controller.send(:pagy_metadata, pagy)).must_rematch
    end
  end

end
