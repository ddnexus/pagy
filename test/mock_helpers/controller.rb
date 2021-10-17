# frozen_string_literal: true

require 'rack'
require_relative 'collection'
class MockController
  include Pagy::Backend
  # we ned to explicitly include this because Pagy::Backend
  # does not include it when the test loads this module without the headers
  include Pagy::UrlHelpers

  attr_reader :params

  def initialize(params={a: 'a', page: 3}, url='https://example.com:8080/foo?page=3')
    @params = params
    @url    = url
  end

  def request
    @request ||= Rack::Request.new(Rack::MockRequest.env_for(@url))
  end

  def response
    @response ||= Rack::Response.new
  end

end
