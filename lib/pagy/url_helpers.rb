# frozen_string_literal: true

class Pagy
  # Provide the helpers to handle the url in frontend and backend
  module UrlHelpers
    # This works with all Rack-based frameworks (Sinatra, Padrino, Rails, ...)
    def pagy_url_for(pagy, page, absolute: nil)
      p_vars                            = pagy.vars
      params                            = request.GET.merge(p_vars[:params])
      params[p_vars[:page_param].to_s]  = page
      params[p_vars[:items_param].to_s] = p_vars[:items] if defined?(ItemsExtra)
      # we rely on Rack by default: use the standalone extra in non rack environments
      query_string = "?#{Rack::Utils.build_nested_query(pagy_massage_params(params))}" unless params.empty?
      "#{request.base_url if absolute}#{request.path}#{query_string}#{p_vars[:fragment]}"
    end

    # Sub-method called only by #pagy_url_for: here for easy customization of params by overriding
    def pagy_massage_params(params)
      params
    end
  end
end
