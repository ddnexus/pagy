# frozen_string_literal: true

require_relative '../../test_helper'
require_relative '../../../gem/lib/pagy/modules/console'

# Create a mock class to simulate including the Pagy::Console module
class MockContext
  include Pagy::Console
end

describe 'Pagy::Console' do
  before do
    @mock_context = MockContext.new
  end

  describe 'params' do
    it 'returns the request params' do
      result = @mock_context.params
      _(result).must_equal({ example: '123' })
    end
  end

  describe 'included' do
    it 'includes Pagy::Paginator' do
      _(MockContext).must_be :<, Pagy::Method
    end
  end

  describe 'request' do
    it 'returns an instance of the Request class' do
      result = @mock_context.request
      _(result).must_be_instance_of Pagy::Console::Request
    end

    it 'has a default base_url' do
      result = @mock_context.request.base_url
      _(result).must_equal 'http://www.example.com'
    end

    it 'has a default path' do
      result = @mock_context.request.path
      _(result).must_equal '/path'
    end
  end

  describe 'collection' do
    it 'returns an instance of the SeriesCollection class' do
      result = @mock_context.collection.new
      _(result).must_be_instance_of Pagy::Console::Collection
    end

    it 'offsets and limits the collection correctly' do
      # Assuming @mock_context.collection is an array from 1 to 1000
      result = @mock_context.collection.new.offset(5).limit(10)

      # The expected result should start from index 5 and return 10 items
      expected_result = (6..15).to_a # This creates an array from 6 to 15
      _(result).must_equal expected_result
    end
    it 'returns the correct size for count' do
      result = @mock_context.collection.new.count
      _(result).must_equal 1000
    end
  end
end
