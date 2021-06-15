# frozen_string_literal: true

require_relative '../../test_helper'
require_relative '../../mock_helpers/meilisearch'
require 'pagy/extras/overflow'

describe 'pagy/extras/meilisearch' do

  describe 'model#pagy_search' do
    it 'extends the class with #pagy_search' do
      _(MockMeilisearch::Model).must_respond_to :pagy_search
    end
    it 'returns class and arguments' do
      _(MockMeilisearch::Model.pagy_search('a', b:2)).must_equal [MockMeilisearch::Model, 'a', {b: 2}]
    end
    it 'allows the query argument to be optional' do
      _(MockMeilisearch::Model.pagy_search(b:2)).must_equal [MockMeilisearch::Model, nil, {b: 2}]
    end
    it 'adds an empty option hash' do
      _(MockMeilisearch::Model.pagy_search('a')).must_equal [MockMeilisearch::Model, 'a', {}]
    end
  end
end
