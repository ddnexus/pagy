# frozen_string_literal: true

require_relative '../../../test_helper'
require_relative '../../../mock_helpers/app'

describe 'array' do
  let(:app) { MockApp.new }

  describe 'pagy array' do
    before do
      @collection = (1..1000).to_a
    end
    it 'paginates with defaults' do
      pagy, records = app.send(:pagy, :offset, @collection)
      _(pagy).must_be_instance_of Pagy::Offset
      _(pagy.count).must_equal 1000
      _(pagy.limit).must_equal Pagy::DEFAULT[:limit]
      _(pagy.page).must_equal app.params[:page].to_i
      _(records.count).must_equal Pagy::DEFAULT[:limit]
      _(records).must_equal [41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60]
    end
    it 'paginates with options' do
      pagy, records = app.send(:pagy, :offset, @collection, page: 2, limit: 10)
      _(pagy).must_be_instance_of Pagy::Offset
      _(pagy.count).must_equal 1000
      _(pagy.limit).must_equal 10
      _(pagy.page).must_equal 2
      _(records.count).must_equal pagy.limit
      _(records).must_equal [11, 12, 13, 14, 15, 16, 17, 18, 19, 20]
    end
  end
end
