# frozen_string_literal: true

class Pagy
  # Provide the helpers to handle the url in frontend and backend
  module UrlHelpers
    # Return the URL for the page, relying on the params method and Rack by default.
    # It supports all Rack-based frameworks (Sinatra, Padrino, Rails, ...).
    # For non-rack environments you can use the standalone extra
    def pagy_url_for(pagy, page, absolute: nil)
      vars                            = pagy.vars
      params                          = request.GET.merge(vars[:params].transform_keys(&:to_s))
      params[vars[:page_param].to_s]  = page
      params[vars[:items_param].to_s] = vars[:items] if vars[:items_extra]

      query_string = "?#{Rack::Utils.build_nested_query(pagy_massage_params(params))}"
      "#{request.base_url if absolute}#{request.path}#{query_string}#{vars[:fragment]}"
    end

    # Sub-method called only by #pagy_url_for: here for easy customization of params by overriding
    def pagy_massage_params(params)
      params
    end
  end
end
