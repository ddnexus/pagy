# frozen_string_literal: true

require 'rack'
require 'active_support/core_ext/hash/indifferent_access'

# Backend and Frontend poor man mock app
class MockApp
  attr_reader :params, :request, :response

  include Pagy::Backend
  include Pagy::Frontend

  # App params are merged into the @request.params (and are all strings)
  # @params are taken from @request.params and merged with app params (which fixes symbols and strings in params)
  def initialize(url: 'http://example.com:3000/foo', params: { page: 3 })
    @request  = Rack::Request.new(Rack::MockRequest.env_for(url, params: params))
    @params   = ActiveSupport::HashWithIndifferentAccess.new(@request.params).merge(params)
    @response = Rack::Response.new
  end

  def test_i18n_call
    I18n.t('test')
  end

  class Calendar < MockApp
    def pagy_calendar_period(collection)
      collection.minmax.map(&:in_time_zone)
    end

    def pagy_calendar_filter(collection, from, to)
      collection.select_page_of_records(from, to)
    end
  end
end
