# frozen_string_literal: true

require 'rack'
require 'active_support/core_ext/hash/indifferent_access'

# Backend and Frontend Mock app
class MockApp
  attr_reader :params, :request, :response

  include Pagy::Backend
  include Pagy::Frontend

  def initialize(url: 'http://example.com:3000/foo', params: { page: 3 })
    @request  = Rack::Request.new(Rack::MockRequest.env_for(url))
    @params   = ActiveSupport::HashWithIndifferentAccess.new(@request.params).merge(**params)
    @response = Rack::Response.new
  end

  def test_i18n_call
    I18n.t('test')
  end

  class Overridden < MockApp
    def pagy_massage_params(params)
      params.delete(:delete_me)
      params.merge!(add_me: 'add_me')
    end
  end
end
