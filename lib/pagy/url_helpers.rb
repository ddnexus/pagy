# frozen_string_literal: true

class Pagy
  # Provide the helpers to handle the url in frontend and backend
  module UrlHelpers
    # Return the URL for the page, relying on the params method and Rack by default.
    # It supports all Rack-based frameworks (Sinatra, Padrino, Rails, ...).
    # For non-rack environments you can use the standalone extra
    def pagy_url_for(pagy, page, absolute: nil)
      vars                = pagy.vars
      page_param          = vars[:page_param].to_s
      items_param         = vars[:items_param].to_s
      params              = pagy.params.is_a?(Hash) ? pagy.params.transform_keys(&:to_s) : {}
      params              = request.GET.merge(params)
      params[page_param]  = page
      params[items_param] = vars[:items] if vars[:items_extra]
      query_string        = "?#{Rack::Utils.build_nested_query(pagy_deprecated_params(pagy, params))}"  # remove in 6.0
      # params              = pagy.params.call(params) if pagy.params.is_a?(Proc)                       # add in 6.0
      # query_string        = "?#{Rack::Utils.build_nested_query(params)}"                              # add in 6.0
      "#{request.base_url if absolute}#{request.path}#{query_string}#{vars[:fragment]}"
    end

    private

    # Transitional code to handle params deprecations. It will be removed in version 6.0
    def pagy_deprecated_params(pagy, params)   # remove in 6.0
      if pagy.params.is_a?(Proc)                # new code
        pagy.params.call(params)
      elsif respond_to?(:pagy_massage_params)   # deprecated code
        Warning.warn '[PAGY WARNING] The pagy_massage_params method has been deprecated and it will be ignored from version 6. ' \
                     'Set the :params variable to a Proc with the same code as the pagy_massage_params method.'
        pagy_massage_params(params)
      else
        params                                  # no massage params
      end
    end
  end
end
