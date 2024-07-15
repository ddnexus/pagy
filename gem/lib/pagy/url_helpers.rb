# frozen_string_literal: true

class Pagy
  # Provide the helpers to handle the url in frontend and backend
  module UrlHelpers
    # Return the URL for the page, relying on the params method and Rack by default.
    # It supports all Rack-based frameworks (Sinatra, Padrino, Rails, ...).
    # For non-rack environments you can use the standalone extra
    def pagy_url_for(pagy, page, absolute: false, fragment: nil, **_)
      vars         = pagy.vars
      query_params = request.GET.clone
      query_params.merge!(vars[:params].transform_keys(&:to_s)) if vars[:params].is_a?(Hash)
      pagy_set_query_params(page, vars, query_params)
      query_params = vars[:params].(query_params) if vars[:params].is_a?(Proc)
      query_string = "?#{Rack::Utils.build_nested_query(query_params)}"
      "#{request.base_url if absolute}#{vars[:request_path] || request.path}#{query_string}#{fragment}"
    end

    # Add the page and items params
    # Overridable by the jsonapi extra
    def pagy_set_query_params(page, vars, query_params)
      query_params[vars[:page_param].to_s]  = page if page
      query_params[vars[:items_param].to_s] = vars[:items] if vars[:items_extra]
    end
  end
end
