# encoding: utf-8
# frozen_string_literal: true

class TestView
  include Pagy::Frontend

  def request
    Rack::Request.new(Rack::MockRequest.env_for('http://example.com:3000/foo?page=2'))
  end
end

class TestSimpleView
  include Pagy::Frontend

  def request
    Rack::Request.new(Rack::MockRequest.env_for('http://example.com:3000/foo?'))
  end
end


class TestViewOverride < TestView
  def pagy_get_params(params)
    params.except(:a).merge!(k: 'k')
  end
end

class Hash
  def except!(*keys)
    keys.each { |key| delete(key) }
    self
  end

  def except(*keys)
    dup.except!(*keys)
  end
end

