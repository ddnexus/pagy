# frozen_string_literal: true

require_relative '../../../test_helper'
require_relative '../../../mock_helpers/app'
require_relative '../../../mock_helpers/collection'

describe 'Pagy URLs' do
  let(:app) { MockApp.new }

  before do
    @collection = MockCollection.new
  end

  describe 'page_url' do
    it 'renders basic url' do
      pagy, = app.send(:pagy, :offset, @collection, count: 1000, page: 3)

      _(pagy.page_url('5')).must_equal '/foo?page=5'
      _(pagy.page_url('5', absolute: true)).must_equal 'http://example.com:3000/foo?page=5'
      _(pagy.page_url(:first)).must_equal '/foo'
      _(pagy.page_url(:last)).must_equal '/foo?page=50'
      _(pagy.page_url(:previous)).must_equal '/foo?page=2'
      _(pagy.page_url(:next)).must_equal '/foo?page=4'
      _(pagy.page_url(:current)).must_equal '/foo?page=3'
    end
  end
end
