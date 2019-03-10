# encoding: utf-8
# frozen_string_literal: true

class TestController
  include Pagy::Backend
  # we ned to explicitly include this because Pagy::Backend
  # does not include it when the test loads this module witout the headers
  include Pagy::Helpers

  attr_reader :params

  def initialize(params={a: 'a', page: 3})
    @params = params
  end

  def request
    @request ||= Rack::Request.new('SCRIPT_NAME' => '/foo','HTTPS' => 'on', 'HTTP_HOST' => 'example.com:8080')
  end

  def response
    @response ||= Rack::Response.new
  end

end

class TestCollection < Array

  def initialize(*args)
    super
    @collection = self.clone
  end

  def offset(value)
    @collection = self[value..-1]
    self
  end

  def limit(value)
    @collection[0, value]
  end

  def count(*)
    size
  end

end

class TestGroupedCollection < TestCollection

  def count(*)
    Hash[@collection.map { |value| [value, value + 1] }]
  end

end
