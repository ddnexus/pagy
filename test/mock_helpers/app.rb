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

  class Overridden < MockApp
    # deprecated but still used for testing deprecations
    def pagy_massage_params(params)  # remove in 6.0
      params.delete('delete_me')
      params.merge!('add_me' => 'add_me')
    end
  end

  class Calendar < MockApp
    def pagy_calendar_get_vars(collection, vars)
      super
      vars[:local_minmax] ||= collection.minmax.map { |t| t.getlocal(0) }
      vars
    end

    def pagy_calendar_get_items(collection, pagy)
      collection.select_page_of_records(pagy.utc_from, pagy.utc_to)
    end
  end
end
