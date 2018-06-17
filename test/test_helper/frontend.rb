class TestView
  include Pagy::Frontend

  def request
    Rack::Request.new('SCRIPT_NAME' => '/foo')
  end
end

class TestViewOverride < TestView
  def pagy_get_params(params)
    params.except(:a).merge!(k: 'k')
  end
end

